function [CT, CQ] = SolverPropeller(avlfilename,a,af0,af1,af2,V,w,M,rho,mu,R,beta75,pd15,B) % Ángulos en grados
    
    Nb = 24;
    Sections = 8;
    dT = zeros(length(Sections),1);
    dQ = zeros(length(Sections),1);
    
    [ wingData ] = runAVLa(avlfilename,0);

    parfor i=1:Sections
        if i == 1
            airfoil = af0;
        else
            airfoil = interpolateAirfoils(Sections-1,i-1,af1,af2);
        end
        c = wingData(1).strip{1,i*(Nb/Sections)}.Chord;
        
        x = 0.30 + 0.70*i/Sections;
        
        Vr = sqrt(V^2+(w*x*R)^2);
        phi = atan(V/(x*R*w))*180/pi;
        beta = beta75 - 15 + atan(pd15/(pi*x))*180/pi;
        
        ai = solveAI(x,beta,V,w,R,B,c,a);
        
        Cl = a*(beta-phi-ai);
        
        Re = rho*Vr*c/mu;
        Cdprof = runXFOIL(Cl,Re,M,airfoil);
        
        dL = 0.5*rho*Vr^2*c*Cl; % dr
        dD = 0.5*rho*Vr^2*c*(0.010*(Cl-0.15)^2+.006); % dr
        dT(i) = dL*cos(phi+ai)-dD*sin(phi+ai);
        dQ(i) = x*R*(dL*sin(phi+ai)+dD*cos(phi+ai));
    end
    
    T = B*trapz((0.7*R).*(1:Sections)/Sections, dT);
    CT = T/(rho*(w/(2*pi))^2*(R*2)^4);
    Q = B*trapz((0.7*R).*(1:Sections)/Sections, dQ);
    CQ = Q/(rho*(w/(2*pi))^3*(R*2)^5);
    
end
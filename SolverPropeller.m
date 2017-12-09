function [CT, CQ] = SolverPropeller(avlfilename,a,af0,af1,af2,Vt,w,M,rho,mu,R,beta75,pd15) % Ángulos en grados
    
    Nb = 24;
    Sections = 8;
    dT = zeros(length(Sections),1);
    dQ = zeros(length(Sections),1);
    
    [ wingData, S, CL, CDi ] = runAVLa(avlfilename,0);

    parfor i=1:Sections
        if i == 1
            airfoil = af0;
        else
            airfoil = interpolateAirfoils(Sections-1,i-1,af1,af2);
        end
        c = wingData(1).strip{1,i*(Nb/Sections)}.Chord;
        
        j = 0.30 + 0.70*i/Sections
        
        V = sqrt(Vt^2+(w*j*R)^2)
        phi = atan(Vt/(j*R*w))*180/pi
        beta = beta75 - 15 + atan(pd15/(pi*j))*180/pi
        
        Cl = a*(beta-phi);
        
        [ Cdprof, ai ] = stage2iterPropeller(Cl,M,V,rho,mu,c,phi,beta,airfoil);
        
        Cl = a*(beta-phi-ai)
        beta-phi-ai
        
        dL = 0.5*rho*V^2*c*Cl; % dr
        dD = 0.5*rho*V^2*c*(0.0010*(Cl-0.15)^2+Cdprof); % dr
        dT(i) = dL*cos(phi+ai)-dD*sin(phi+ai);
        dQ(i) = j*R*(dL*sin(phi+ai)+dD*cos(phi+ai));
    end
    
    CT = (pi/8)*trapz((0.7*R).*(1:Sections)/Sections, dT);
    CQ = (pi/8)*trapz((0.7*R).*(1:Sections)/Sections, dQ);
    
end
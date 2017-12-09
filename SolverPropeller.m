function [CT, CQ] = SolverPropeller(avlfilename,af0,af1,af2,Vt,w,M,rho,mu,R,beta75,pd15) % Ángulos en grados
    
    Nb = 24;
    Sections = 8;
    dT = zeros(length(Sections),1);
    dQ = zeros(length(Sections),1);
    
    A = beta75 - atan(Vt/(R*0.75*w))*180/pi;
    [ wingData, S, CL, CDi ] = runAVLa(avlfilename,A);

    for i=1:Sections
        if i == 1
            airfoil = af0;
        else
            airfoil = interpolateAirfoils(Sections-1,i-1,af1,af2);
        end
        Cl = wingData(1).strip{1,i*(Nb/Sections)}.cl;
        c = wingData(1).strip{1,i*(Nb/Sections)}.Chord;
        cdi = wingData(1).strip{1,i*(Nb/Sections)}.cd;
        
        j = 0.30 + 0.70*i/Nb;
        
        V = sqrt(Vt^2+(w*j*R)^2)
        phi = atan(Vt/(j*R*w))*180/pi
        beta = beta75 - 15 + atan(pd15/(pi*j))*180/pi;
        
        [ Cdprof, ai ] = stage2iterPropeller(Cl,M,V,rho,mu,c,phi,beta,airfoil);
        dL = 0.5*rho*V^2*c*Cl; % dr
        dD = 0.5*rho*V^2*c*(cdi+Cdprof); % dr
        dT(i) = dL*cos(phi+ai)-dD*sin(phi+ai);
        dQ(i) = j*R*(dL*sin(phi+ai)+dD*cos(phi+ai));
    end
    
    CT = (pi/8)*trapz((0.7*R).*(1:Sections)/Sections, dT);
    CQ = (pi/8)*trapz((0.7*R).*(1:Sections)/Sections, dQ);
    
end
function [ Cdprof, ai ] = stage2iterPropeller(Cl,M,V,rho,dynamic_viscocity,c,phi,beta,airfoil)
    % Todos los ángulos se esperan en grados
    Re = rho*V*c/dynamic_viscocity;    
    ai = 0;
    ai2 = 10;
    Cdeff = 0;
    i=0;
    j=0;
    
    while abs(ai - ai2)/ai > 0.01 && i<100 && j<2
        ai2 = ai;
        ai = ai*pi/180;
        
        Meff = M / cos(ai);
        Cleff = (Cl * cos(ai)^2 + Cdeff * sin(ai))/cos(ai);
        
        [aeff,Cdeff,Cdpeff,Cdfeff] = runXFOIL(Cleff,Re,Meff,airfoil);
        if aeff == -100 && Cdeff == -100
            ai = (ai+1)*180/pi;
            Cdeff = 0;
            j = j+5
        else
            ai = beta - phi - aeff;
        end
        i = i + 1;
    end
    
    Cdprof = ( Cdfeff + Cdpeff ) / cos(ai*pi/180);
    if abs(ai - ai2)/ai > 0.01, Cdprof = -100; end
 end
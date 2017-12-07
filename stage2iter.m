function [ Cdprof ] = stage2iter(Cl,M,V,rho,dynamic_viscocity,c,A,lambda,epsilon,airfoil)
    % Todos los ángulos se esperan en grados
    Re = rho*V*c/dynamic_viscocity;
    lambda = lambda*pi/180;
    Vp = V * cos(lambda);
    Mp = M * cos(lambda);
    cp = c * cos(lambda);
    Clp = Cl * sec(lambda)^2;
    
    ai = 0;
    ai2 = 10;
    Cdeff = 0;
    i=0;
    j=0;
    
    while abs(ai - ai2)/ai > 0.01 && i<100 && j<2
        ai2 = ai;
        ai = ai*pi/180;
        
        Meff = Mp / cos(ai);
        Veff = Vp / cos(ai);
        Reeff = Re *(Veff/V)*(cp/c); % En realidad bastaría con calcular Re sólo para cp y corregir por Veff
        Cleff = (Clp * cos(ai)^2 + Cdeff * sin(ai))/cos(ai);
        
        [aeff,Cdeff,Cdpeff,Cdfeff] = runXFOIL(Cleff,Reeff,Meff,airfoil);
        if aeff == -100 && Cdeff == -100
            ai = (ai+1)*180/pi;
            Cdeff = 0;
            j = j+5
        else
            ai = -aeff + (A + epsilon)* cos(lambda);
        end
        i = i + 1;
    end
    
    Cdprof = ( Cdfeff + Cdpeff * cos(lambda)^3 ) / cos(ai*pi/180);
    if abs(ai - ai2)/ai > 0.01, Cdprof = -100; end
 end
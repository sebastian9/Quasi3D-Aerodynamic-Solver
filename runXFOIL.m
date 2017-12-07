function [a,Cd,Cdp,Cdf] = runXFOIL(Cl,Re,M,airfoil)
    fid = fopen([airfoil,num2str(Cl*10000),'.run'], 'w');
    fprintf(fid, 'PLOP\ng\n\n');
    fprintf(fid, 'LOAD %s\n', [airfoil,'.dat']);
    fprintf(fid, 'OPER\n');
    fprintf(fid, 'Visc %f\n',Re);
    fprintf(fid, 'Mach %f\n',M);
    fprintf(fid, 'Cl %f\n',Cl);
    fprintf(fid, '!\n!\n!\n!\n!\n!\n!\n!\n!\n!\n');
    fprintf(fid, '\nquit\n');
    [status,result] = dos(['xfoil.exe < ',airfoil,num2str(Cl*10000),'.run']);
    fclose(fid);
    dos(['del ',airfoil,num2str(Cl*10000),'.run']);
    fid = fopen(['temp',num2str(Cl*10000)],'w');
    fprintf(fid,result);
    file = textread(['temp',num2str(Cl*10000)], '%s', 'delimiter', '\n','whitespace', '');
    fclose(fid);
    dos(['del temp',num2str(Cl*10000)]);
    a = findValue(file,'a =',[1,length(file)]); % grados
    Cd = findValue(file,'CD =',[1,length(file)]);
    Cdp = findValue(file,'CDp =',[1,length(file)]);
    Cdf = findValue(file,'CDf =',[1,length(file)]);
    if regexpi(result,'VISCAL:  Convergence failed')
        a = -100;
        Cd = -100;
        Cdp = -100;
        Cdf = -100;
    end
end
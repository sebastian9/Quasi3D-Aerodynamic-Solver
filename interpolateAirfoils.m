function [airfoil] = interpolateAirfoils(semispan,stage,dat1,dat2)
    fid = fopen([dat1,'.dat'],'r');
    coord1 = textscan(fid, '%f%f', 'HeaderLines', 1);
    fclose(fid);
    x1 = cell2mat(coord1(1));
    y1 = cell2mat(coord1(2));
    fid = fopen([dat2,'.dat'],'r');
    coord2 = textscan(fid, '%f%f', 'HeaderLines', 1);
    fclose(fid);
    x2 = cell2mat(coord2(1));
    y2 = cell2mat(coord2(2));
    airfoil = ['Interpolacion_',num2str(stage)];
    fid = fopen(['Interpolacion_',num2str(stage),'.dat'],'w');
    fprintf(fid,['Interpolacion ',num2str(stage),' ',dat1,' ',dat2,'\n']);
    for i=1:length(x1)
        x = ((x2(i)-x1(i))/semispan)*stage + x1(i);
        y = ((y2(i)-y1(i))/semispan)*stage + y1(i);
        fprintf(fid,' %f    %f\n',x,y);
    end
    fclose(fid);
end
function [ Surfaces, S, CL, CDi ] = runAVLa(avlfile,A)
    %dos(['del ',avlfile,'.SF']);
    %dos(['del ',avlfile,'.run']);
    fid = fopen([avlfile,num2str(A*10),'.run'], 'w');% Create run file
    fprintf(fid, 'LOAD %s\n', [avlfile,'.avl']);
    fprintf(fid, 'PLOP\ng\n\n'); %Disable Graphics
    fprintf(fid, 'OPER\n'); %Open the OPER menu
    fprintf(fid, 'a\na %f\n',A); %Define constraint
    fprintf(fid, 'x\n'); % Execute
    fprintf(fid, 'FS\n'); %Save the surface data
    fprintf(fid, '%s%s\n',[avlfile,num2str(A*10)],'.SF');
    fprintf(fid, '\nQuit\n'); 
    fclose(fid);
    [status,result] = dos(['avl.exe < ',avlfile,num2str(A*10),'.run']); % Execute run
    dos(['del ',avlfile,num2str(A*10),'.run']);
    
    fid = fopen(['temp',num2str(A*10)],'w');
    fprintf(fid,result);
    file = textread(['temp',num2str(A*10)], '%s', 'delimiter', '\n','whitespace', '');
    fclose(fid);
    dos(['del temp',num2str(A*10)]);
    CL = findValue(file,'CLtot =',[1,length(file)]);
    CDi = findValue(file,'CDind =',[1,length(file)]);
    
    file = textread([avlfile,num2str(A*10),'.SF'], '%s', 'delimiter', '\n','whitespace', '');
    dos(['del ',avlfile,num2str(A*10),'.SF']);
    S = 2*findValue(file,'Surface area =',[1,length(file)]);
    % Surfaces;
    surfIndex=1;
    i=1;
    while i<length(file)
        str = char(file(i));
        header = regexp(str, 'Surface #', 'once');
        if(~isempty(header))
            clearvars surface
            surface.name = strtrim(str(18:length(str)));
            i=i+1;
            while i<length(file)
                str = char(file(i));
                header = regexp(str, 'Strip Forces referred to Strip Area, Chord', 'once');
                if(~isempty(header))
                    i=i+2;
                    str = char(file(i));
                    j=1;
                    while(~isempty(str) && i<length(file))
                        surface.strip{j} = readLine(str);
                        j=j+1;
                        i=i+1;
                        str = char(file(i));
                    end
                    break;
                end
                i=i+1;
            end
            Surfaces(surfIndex) = surface;
            surfIndex = surfIndex+1;
        end
        i=i+1;
    end
        function [strip] = readLine(string)
            string = [string ' '];
            s2 = regexp(string, ' ', 'split');
            %j      Yle    Chord     Area     c cl      ai      cl_norm  cl
            %cd       cdv    cm_c/4    cm_LE  C.P.x/c
            [strip.j, sIndex] = readValue(s2,1);
            [strip.Yle, sIndex] = readValue(s2,sIndex+1);
            [strip.Chord, sIndex] = readValue(s2,sIndex+1);
            [strip.Area, sIndex] = readValue(s2,sIndex+1);
            [strip.ccl, sIndex] = readValue(s2,sIndex+1);
            [strip.ai, sIndex] = readValue(s2,sIndex+1);
            [strip.cl_norm, sIndex] = readValue(s2,sIndex+1);
            [strip.cl, sIndex] = readValue(s2,sIndex+1);
            [strip.cd, sIndex] = readValue(s2,sIndex+1);
            [strip.cdv, sIndex] = readValue(s2,sIndex+1);
            [strip.cm_c4, sIndex] = readValue(s2,sIndex+1);
            [strip.cm_LE, sIndex] = readValue(s2,sIndex+1);
            [strip.CPxc, sIndex] = readValue(s2,sIndex+1);
        end
        function [val,endIndex] = readValue(s2,index)
            val = 'NAN';
            while index<length(s2)
                if(length(char(s2(index)))>=1)
                    val = str2double(char(s2(index)));
                    break;
                end
                index = index+1;
            end
            endIndex = index;
        end
end
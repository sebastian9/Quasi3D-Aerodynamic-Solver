avlfilename = 'a0';
airfoil = 'ag35';
V = 10;
CL = 0.05;
Sections = 24; % Cambiar por 8 para interpolar
M = 0.2;
rho = 1.1896;
dynamic_viscocity = 0.0000180215;
epsilon = 0;
lambda = 2;

% [ Surfaces, a ] = runAVL(avlfile,CL)
[ wingData, a ] = runAVL(avlfilename,CL);
CDprof = zeros(length(Sections),1);

for i=1:Sections

    Cl = wingData(1).strip{1,i}.cl;
    c = wingData(1).strip{1,i}.Chord;
    % [ Cdprof ] = stage2iter(Cl,M,V,rho,dynamic_viscocity,c,a,lambda,epsilon,airfoil)
    CDprof(i) = stage2iter(Cl,M,V,rho,dynamic_viscocity,c,a,lambda,epsilon,airfoil);
    
end
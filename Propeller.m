tic
avlfilename = 'a15'; % Configurar Nb a 24 y Nc a 13
af0 = 'clarky39'; % Perfil de Núcleo
af1 = 'clarky11'; % Perfil medio
af2 = 'clarky08'; % Perfil punta
Vt = 80; % m/s
M = 0;
rho = 1.2250;
dynamic_viscocity = 1.5E-05;

beta75 = 35; % En grados
pd15 = 0.631; % cociente paso:diámetro a 15 grados
w = 80*pi; % rad/s
D = 2; % m

[CT, CQ] = SolverPropeller(avlfilename,af0,af1,af2,Vt,w,M,rho,dynamic_viscocity,D/2,beta75,pd15)
toc
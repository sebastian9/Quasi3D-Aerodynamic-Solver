avlfilename = 'a5'; % Configurar Nb a 24 y Nc a 13
af1 = 'n23020'; % Perfil de Raíz
af2 = 'n23009';
V = 277.1089;
M = 0;
rho = 1.2250;
dynamic_viscocity = 1.5E-05;
AR = 12;
epsilon = 0; % En grados !! Falta desarrollar
lambda = 0; % En grados
A = -2:.5:14; % En grados

CL = zeros(1,length(A));
CD = zeros(1,length(A));
CDi = CD;
CDv = CD;
tic
parfor i=1:length(A) % If available, computes data points in parallel
    [CL(i),CD(i),CDv(i),CDi(i)] = SolverA(A(i),avlfilename,af1,af2,V,M,rho,dynamic_viscocity,AR,epsilon,lambda);
end
toc
plot(CD,CL)
grid
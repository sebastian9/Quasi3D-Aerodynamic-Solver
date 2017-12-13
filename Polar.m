avlfilename = 'legacy600'; % Configurar Nb a 24 y Nc a 13
af1 = 'sc20714'; % Perfil de Raíz
af2 = 'sc20714';
M = 0.3;
V = (294.99)*(0.3);
rho = 0.28747;
dynamic_viscocity = 0.0000143226;
AR = 7.174;
epsilon = 0; % En grados !! Falta desarrollar
lambda = 21; % En grados
A = -2:.5:12; % En grados

CL = zeros(1,length(A));
CD = zeros(1,length(A));
CDi = CD;
CDv = CD;
% Extra Drag Homework
CDw = CD;
CDbody = CD;

tic
parfor i=1:length(A) % If available, computes data points in parallel
    [CL(i),CD(i),CDv(i),CDi(i),CDw(i),CDbody(i)] = SolverA(A(i),avlfilename,af1,af2,V,M,rho,dynamic_viscocity,AR,epsilon,lambda);
end
toc
plot(CD,CL)
grid
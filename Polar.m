avlfilename = 'a6'; % Configurar Nb a 24 y Nc a 13
af1 = 'n23020';
af2 = 'n23009';
V = 442.0384;
M = 0;
rho = 1.2250;
dynamic_viscocity = 1.8121E-05;
epsilon = 0; % En grados
lambda = 0; % En grados
A = -2:.5:14; % En grados

CL = zeros(1,length(A));
CD = zeros(1,length(A));
CDi = CD;
CDv = CD;
tic
parfor i=1:length(A) % If available, computes data points in parallel
    [CL(i),CD(i),CDv(i),CDi(i)] = SolverA(A(i),avlfilename,af1,af2,V,M,rho,dynamic_viscocity,epsilon,lambda);
end
toc
plot(CD,CL)
grid
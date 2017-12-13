function [ai] = solveAI(x,Beta,V,w,R,B,c,a)

lambda = V/(w*R);
sigma = B*c*pi()*R;
VT = w*R;
Vr = VT*sqrt(x^2+lambda^2);
phi = atan(lambda/x);

ai = 0.5 * ( -((lambda/x)+(sigma*a*Vr)/(8*x^2*VT)) + ( ((lambda/x)+(sigma*a*Vr)/(8*x^2*VT))^2 + (Beta-phi)*(sigma*a*Vr)/(2*x^2*VT) )^.5 );
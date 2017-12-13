function [cdw] = WaveDrag(m,t,cl,lambda,ka)
    
    mdd = ( ka - cl/(10*cos(lambda)^2) - t/cos(lambda))/cos(lambda);
    mcr = mdd - (.1/80)^(1/3);
    if m > mcr, cdw = 20*(m-mcr)^4; else, cdw = 0; end
    
end
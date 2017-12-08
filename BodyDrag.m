function [cdf_d] = BodyDrag(l,d,sw,sref)
    
    cf = 1;
    ff = 1 + .0025*(l/d) + 60/(l/d)^3;
    cdf_d = cf*ff*sw/sref;
    
end
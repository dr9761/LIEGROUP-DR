function [beta] = beta(b)
%   Detailed explanation goes here
beta(b) = 2*(1-cos(norm(b)))/norm(b)^2;
end
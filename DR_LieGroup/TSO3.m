function [TSO3] = TSO3(omega)
%   Detailed explanation goes here
if omega == 0
    TSO3 = zeros(3);
else
    TSO3 = eye(3)-get_beta(omega)/2*skew(omega)+(1-get_alpha(omega))/(dot(omega,omega))*(skew(omega)^2);
end
end
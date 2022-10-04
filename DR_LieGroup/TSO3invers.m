function [TSO3invers] = TSO3invers(omega)
%   Detailed explanation goes here
alpha = get_alpha(omega);
beta = get_beta(omega);
if omega == 0
    TSO3invers = eye(3);
else
    TSO3invers = eye(3)+0.5*skew(omega)+(1-alpha/beta)/(dot(omega,omega))*(skew(omega)^2);
end
end
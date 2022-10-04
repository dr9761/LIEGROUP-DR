function [d] = logSE3(HA,HB)
%logarithmic map
H = HA^-1*HB;
R = H(1:3,1:3);

if trace(R) == 3
    theta = 0;
    omegai = zeros(3);
else
    theta = acos(0.5*(trace(R)-1));
    omegai = theta*(R-R')/(2*sin(theta));
end

omega = [omegai(3,2);omegai(1,3);omegai(2,1)];
x=[H(1,4);H(2,4);H(3,4)];
d = zeros(6,1);
D = [omegai (TSO3invers(omega))'*x; zeros(1,3) 0];
dU = (TSO3invers(omega))'*x;
domega = omega;
d = [dU' domega']';




end
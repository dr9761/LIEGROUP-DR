function [R] = getR(phi)
% phi(3,1)
alpha = phi(1);
beta = phi(2);
gamma = phi(3);
if phi == zeros(3,1)
    R = eye(3);
else
    R1 = [1 0 0; 0 cos(alpha) sin(alpha); 0 -sin(alpha) cos(alpha)];
    R2 = [cos(beta) 0 -sin(beta);0 1 0;sin(beta) 0 cos(beta)];
    R3 = [cos(gamma) sin(gamma) 0; -sin(gamma) cos(gamma) 0; 0 0 1];
    R = R3*R2*R1;
end
end
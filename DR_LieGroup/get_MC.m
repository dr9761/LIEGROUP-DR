function [MC] = get_MC(BodyParameter)
%   Detailed explanation goes here
BodyNr = 1;
rho = BodyParameter.rho;
L  = BodyParameter.L;
ri  = BodyParameter.ri;
ra  = BodyParameter.ra;
m  = BodyParameter.m;
A  = BodyParameter.A;
Iy = BodyParameter.Iy;
Iz = BodyParameter.Iz;
J = diag([Iy+Iz,Iz,Iy]);
E = BodyParameter.E;
G = BodyParameter.G;
theta_B_0 = [1/2*m*(ra^2-ri^2),0,0;0,1/3*m*L^2,0;0,0,1/3*m*L^2];
r_B_0C = [L/2;0;0];
O0A = [1 0 0; 0 1 0; 0 0 1];
MC = [m/L*eye(3) zeros(3); zeros(3) -O0A*rho*J*O0A' ];


end


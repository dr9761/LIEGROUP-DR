function [H1,H2,H3,H4] = determine_H(BodyParameter)

G  = BodyParameter.G;
A  = BodyParameter.A;
E  = BodyParameter.E;
Iy = BodyParameter.Iy;
Iz = BodyParameter.Iz;
%% H1
% H1 = BodyParameter.Stiffness;
H1 = diag([E*A,G*A/4,G*A/4,G*(Iy+Iz)/4,E*Iz,E*Iy]);
%% H2
H2 = zeros(6,6);
H2(2,6) = -G*A/4;
H2(3,5) =  G*A/4;
% H2(5,3) =  G*A/4;
% H2(6,2) = -G*A/4;
%% H3
H3 = zeros(6,6);
H3(5,3) =  G*A/4;
H3(6,2) = -G*A/4;
%% H4
H4 = zeros(6,6);
H4(5,5) =  G*A/4;
H4(6,6) =  G*A/4;

end
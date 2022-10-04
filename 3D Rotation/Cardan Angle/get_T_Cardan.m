function T = get_T_Cardan(Angle)
%% B_omega = T * dphidt
%% B_kappa = T * dphids
%%
phi = Angle(1);
psi = Angle(2);
theta = Angle(3);
%%
M1 = zeros(3);M1(1,1) = 1;
M2 = zeros(3);M2(2,2) = 1;
M3 = zeros(3);M3(3,3) = 1;
%
Rz = get_R_z(theta);
Ry = get_R_y(psi);
Rx = get_R_x(phi);
%%
T = Rx'*Ry'*M3 + Rx'*M2 + M1;
%%
% get_R_Cardan(Angle) * T
% T = M3 + Rz*M2 + Rz*Ry*M1
end
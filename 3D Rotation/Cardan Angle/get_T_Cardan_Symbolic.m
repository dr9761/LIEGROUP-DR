function T = get_T_Cardan_Symbolic(Angle)
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
invRz = get_invR_z(theta);
invRy = get_invR_y(psi);
invRx = get_invR_x(phi);
%%
T = invRx*invRy*M3 + invRx*M2 + M1;
%%
% get_R_Cardan(Angle) * T
% T = M3 + Rz*M2 + Rz*Ry*M1
end
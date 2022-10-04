function [Mass,Force] = get_Element_MassForce(g,d,epsilon,BodyElementParameter)
%% 杆件的材料参数
rho = BodyElementParameter.rho;
%% 杆件的形状参数
L  = BodyElementParameter.L;
A  = BodyElementParameter.A;
Iy = BodyElementParameter.Iy;
Iz = BodyElementParameter.Iz;
J = diag([0,Iz,Iy]);
%坐标设置 
% q1 = qe(1:numel(qe)/2);
% q2 = qe(numel(qe)/2+1:end);
% 
% r01 = q1(1:3);
% phi1 = q1(4:6);
% R1 = get_R(phi1);
% 
% r02 = q2(1:3);
% phi2 = q2(4:6);
% R2 = get_R(phi2);
% 
% r0e = [r01;r02];
% Re = [R1;R2];
% 
% r_rigid_1 = [0;0;0];
% r_rigid_2 = [L;0;0];
% [qd_end,dqd_end,Td_end,dTd_enddt] = ...
% 	get_Deformation_Coordination_at_Endpoint(...
% 	r0e,Re,dqe,r0B,RB,dqB,TB,dTBdt,r_rigid_1,r_rigid_2);
%
% dqd_enddt = dqd_end;
gext = zeros(6,1);


% 初始化相关矩阵
MC = zeros(6,6);
M = zeros(12);
K = zeros(6,6);
P = zeros(6,12);
Q = zeros(6,12);


MC = get_MC(BodyElementParameter);
K = get_K(BodyElementParameter);
P = get_P(d,BodyElementParameter);

%nodal internal force
gintAB = P'*K*epsilon;
%Gauss Integration
gaussn = 5;
x_set = gaussx(0,L,gaussn);
w_set = gaussw(gaussn)*L/2;
gextAB = zeros(12,1);

for i = 1:gaussn
	x = x_set(i);
	w = w_set(i);
    Q = get_Q(x,d,BodyElementParameter);
% mass Matrix
    M = M + w*Q'*MC*Q;
    gext1 = MC(1:3,1:3)*g;
    gext2 = MC(4:6,4:6)*g;
    gext = [gext1; gext2];
% nodal external force
    gextAB = gextAB + w*Q'*gext;

end
%nodal inertia force

%%
Force = -gintAB +gextAB;
Mass = M;


end

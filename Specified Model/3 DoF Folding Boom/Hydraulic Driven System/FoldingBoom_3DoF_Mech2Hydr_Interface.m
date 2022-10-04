function [s,dsdt] = FoldingBoom_3DoF_Mech2Hydr_Interface(qb,dqb,ModelParameter)
%%
Joint_Parameter = ModelParameter.Joint_Parameter;
gx = [1;0;0];
%%
phi1 = qb{1}(4:6);
R1 = get_R(phi1);

r8 = qb{8}(1:3);
phi8 = qb{8}(4:6);
R8 = get_R(phi8);

r9 = qb{9}(1:3);
phi9 = qb{9}(4:6);
R9 = get_R(phi9);


dr8dt = dqb{8}(1:3);
dr9dt = dqb{9}(1:3);
omega1 = dqb{1}(4:6);

r8_7 = r8 + R8*Joint_Parameter{8}.Joint{7}.r;
r9_2 = r9 + R9*Joint_Parameter{9}.Joint{2}.r;

L8_9 = norm(r9-r8);
r8_9 = L8_9*gx;
dL8_9dt = gx' * (R8'*(dr9dt-dr8dt) + skew(r8_9)*R8'*R1*omega1);

s1 = norm(r9_2 - r8_7);
ds1dt = dL8_9dt;
%%
phi11 = qb{11}(4:6);
R11 = get_R(phi11);
r12 = qb{12}(1:3);
phi12 = qb{12}(4:6);
R12 = get_R(phi12);
r13 = qb{13}(1:3);
phi13 = qb{13}(4:6);
R13 = get_R(phi13);

dr12dt = dqb{12}(1:3);
dr13dt = dqb{13}(1:3);
omega11 = dqb{11}(4:6);

r12_7 = r12 + R12*Joint_Parameter{12}.Joint{7}.r;
r13_2 = r13 + R13*Joint_Parameter{13}.Joint{2}.r;

L12_13 = norm(r13 - r12);
dL12_13dt = gx' * ...
	(R12'*(dr13dt-dr12dt) + L12_13*skew(gx)*R12'*R11*omega11);

s2 = norm(r13_2 - r12_7);
ds2dt = dL12_13dt;
%%
s = [s1;s2];
dsdt = [ds1dt;ds2dt];

end
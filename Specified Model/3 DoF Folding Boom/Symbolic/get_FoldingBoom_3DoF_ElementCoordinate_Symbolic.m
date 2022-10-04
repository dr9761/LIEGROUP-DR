function [r0b,Rb,dqb,Tb,dTb] = get_FoldingBoom_3DoF_ElementCoordinate_Symbolic(...
	q,dq,ModelParameter)
%%
Joint_Parameter = ModelParameter.Joint_Parameter;
BodyElementParameter = ModelParameter.BodyElementParameter;
%%
gx = [1;0;0];
gy = [0;1;0];
gz = [0;0;1];
%%
dpsi  = q(1);
dphi1 = q(2);
dphi2 = q(3);
%% Body 1
r1 = [0;0;0];
phi1 = [0;0;dpsi];
R1 = get_R_Symbolic(phi1);
% q1 = [r1;phi1];

Tr1 = zeros(3);
Tphi1 = zeros(3);Tphi1(3,1) = 1;
T1 = [Tr1;Tphi1];

dr1dt = Tr1 * dq;
omega1 = Tphi1 * dq;
dq1 = [dr1dt;omega1];

dTr1 = zeros(3);
dTphi1 = zeros(3);
dT1 = [dTr1;dTphi1];
%% Body 2
r2 = r1 + R1*Joint_Parameter{1}.Joint{2}.r;
R2 = R1 * get_R_Symbolic([0;-dphi1;0]);
% phi2 = get_Rotation_from_R(R2,[0;0;0]);

% q2 = [r2;phi2];
%
Tr2 = Tr1 - R1*skew(Joint_Parameter{1}.Joint{2}.r)*Tphi1;
Tphi2 = zeros(3);Tphi2(2,2) = -1;
Tphi2 = R2'*R1*Tphi1 + Tphi2;
T2 = [Tr2;Tphi2];

dr2dt = Tr2 * dq;
omega2 = Tphi2 * dq;
dq2 = [dr2dt;omega2];

dTr2 = dTr1 - R1*skew(Joint_Parameter{1}.Joint{2}.r)*dTphi1 - ...
	R1*skew(omega1)*skew(Joint_Parameter{1}.Joint{2}.r)*Tphi1;
dTphi2 = (R2'*R1*skew(omega1) - skew(omega2)*R2'*R1)*Tphi1 + ...
	R2'*R1*dTphi1;
dT2 = [dTr2;dTphi2];
%% Body 3
r3 = r2 + R2*Joint_Parameter{2}.Joint{2}.r;
% phi3 = phi2;
R3 = R2;
% q3 = [r3;phi3];
%
Tr3 = Tr2 - R2*skew(Joint_Parameter{2}.Joint{2}.r)*Tphi2;
Tphi3 = Tphi2;
T3 = [Tr3;Tphi3];

dr3dt = Tr3 * dq;
omega3 = Tphi3 * dq;
dq3 = [dr3dt;omega3];

dTr3 = dTr2 - R2*skew(Joint_Parameter{2}.Joint{2}.r)*dTphi2 - ...
	R2*skew(omega2)*skew(Joint_Parameter{2}.Joint{2}.r)*Tphi2;
dTphi3 = dTphi2;
dT3 = [dTr3;dTphi3];
%% Body 4
r4 = r3 + R3*Joint_Parameter{3}.Joint{2}.r;
% phi4 = phi3;
R4 = R3;
% q4 = [r4;phi4];
%
Tr4 = Tr3 - R3*skew(Joint_Parameter{3}.Joint{2}.r)*Tphi3;
Tphi4 = Tphi3;
T4 = [Tr4;Tphi4];

dr4dt = Tr4 * dq;
omega4 = Tphi4 * dq;
dq4 = [dr4dt;omega4];

dTr4 = dTr3 - R3*skew(Joint_Parameter{3}.Joint{2}.r)*dTphi3 - ...
	R3*skew(omega3)*skew(Joint_Parameter{3}.Joint{2}.r)*Tphi3;
dTphi4 = dTphi3;
dT4 = [dTr4;dTphi4];
%% Body 5
r5 = r4 + R4*Joint_Parameter{4}.Joint{2}.r;
R5 = R4 * get_R_Symbolic([0;dphi2-pi;0]);
% phi5 = get_Rotation_from_R(R5,[0;0;0]);
% q5 = [r5;phi5];
%
Tr5 = Tr4 - R4*skew(Joint_Parameter{4}.Joint{2}.r)*Tphi4;
Tphi5 = R5'*R4*Tphi4 + [0,0,0;0,0,1;0,0,0];
T5 = [Tr5;Tphi5];

dr5dt = Tr5 * dq;
omega5 = Tphi5 * dq;
dq5 = [dr5dt;omega5];

dTr5 = dTr4 - R4*skew(Joint_Parameter{4}.Joint{2}.r)*dTphi4 - ...
	R4*skew(omega4)*skew(Joint_Parameter{4}.Joint{2}.r)*Tphi4;
dTphi5 = (R5'*R4*skew(omega4) - skew(omega5)*R5'*R4)*dTphi4 + ...
	R5'*R4*dTphi4;
dT5 = [dTr5;dTphi5];
%% Body 6
r6 = r5 + R5*Joint_Parameter{5}.Joint{2}.r;
% phi6 = phi5;
R6 = R5;
% q6 = [r6;phi6];
%
Tr6 = Tr5 - R5*skew(Joint_Parameter{5}.Joint{2}.r)*Tphi5;
Tphi6 = Tphi5;
T6 = [Tr6;Tphi6];

dr6dt = Tr6 * dq;
omega6 = Tphi6 * dq;
dq6 = [dr6dt;omega6];

dTr6 = dTr5 - R5*skew(Joint_Parameter{5}.Joint{2}.r)*dTphi5 - ...
	R5*skew(omega5)*skew(Joint_Parameter{5}.Joint{2}.r)*Tphi5;
dTphi6 = dTphi5;
dT6 = [dTr6;dTphi6];
%% Body 7
r7 = r6 + R6*Joint_Parameter{6}.Joint{2}.r;
% phi7 = phi6;
R7 = R6;
% q7 = [r7;phi7];
%
Tr7 = Tr6 - R6*skew(Joint_Parameter{6}.Joint{2}.r)*Tphi6;
Tphi7 = Tphi6;
T7 = [Tr7;Tphi7];

dr7dt = Tr7 * dq;
omega7 = Tphi7 * dq;
dq7 = [dr7dt;omega7];

dTr7 = dTr6 - R6*skew(Joint_Parameter{6}.Joint{2}.r)*dTphi6 - ...
	R6*skew(omega6)*skew(Joint_Parameter{6}.Joint{2}.r)*Tphi6;
dTphi7 = dTphi6;
dT7 = [dTr7;dTphi7];
%% Body 8 & Body 9
r8 = r1 + R1*Joint_Parameter{1}.Joint{3}.r;
nx8 = (r3-r8)/norm(r3-r8);
ny8 = R2(:,2);
nz8 = skew(nx8)*ny8;
R8 = [nx8,ny8,nz8];
% phi8 = get_Rotation_from_R(R8,[0;0;0]);

r9 = r3;
R9 = R8 * get_R_Symbolic([0;pi;0]);
% phi9 = get_Rotation_from_R(R9,[0;0;0]);

% q8 = [r8;phi8];
% q9 = [r9;phi9];
%
Tr8 = Tr1 - R1*skew(Joint_Parameter{1}.Joint{3}.r)*Tphi1;
Tr9 = Tr3;

dr8dt = Tr8 * dq;
dr9dt = Tr9 * dq;

L8_9 = norm(r9-r8);
r8_9 = L8_9*gx;
dphi1_8dt = [0,0,1/L8_9] * ...
	(R8'*(dr9dt-dr8dt) + skew(r8_9)*R8'*R1*omega1);
dL8_9dt = [1,0,0] * ...
	(R8'*(dr9dt-dr8dt) + skew(r8_9)*R8'*R1*omega1);
Tphi8 = -1/L8_9*gy*gz'*R8'*(Tr9-Tr8) + ...
	(eye(3)-gy*gz'*skew(gx))*R8'*R1*Tphi1;

Tphi9 = -1/L8_9*gy*gz'*R9'*(Tr8-Tr9) + ...
	(eye(3)-gy*gz'*skew(gx))*R9'*R3*Tphi3;
dphi3_9dt = -1/L8_9*gz'* ...
	(R9'*(dr8dt-dr9dt) + skew(r8_9)*R9'*R3*omega3);
dL9_8dt = gx'* ...
	(R9'*(dr8dt-dr9dt) + skew(r8_9)*R9'*R3*omega3);

T8 = [Tr8;Tphi8];
T9 = [Tr9;Tphi9];

omega8 = Tphi8 * dq;
omega9 = Tphi9 * dq;

dq8 = [dr8dt;omega8];
dq9 = [dr9dt;omega9];
%
dTr8 = dTr1 - R1*skew(Joint_Parameter{1}.Joint{3}.r)*dTphi1 - ...
	R1*skew(omega1)*skew(Joint_Parameter{1}.Joint{3}.r)*Tphi1;
dTr9 = dTr3;

dTphi8 = (eye(3)-gy*gz'*skew(gx))*R8'*R1*dTphi1 - ...
	dphi1_8dt*(eye(3)-gy*gz'*skew(gx))*skew(gy)*Tphi8 - ...
	1/L8_9*gy*gz'*(R8'*(dTr9-dTr8)+2*dL8_9dt*skew(gx)*Tphi8) - ...
	gy*gz'*skew(omega8)*skew(gx)*Tphi8;
dTphi9 = (eye(3)-gy*gz'*skew(gx))*R9'*R3*dTphi3 - ...
	dphi3_9dt*(eye(3)-gy*gz'*skew(gx))*skew(gy)*Tphi9 - ...
	1/L8_9*gy*gz'*(R9'*(dTr8-dTr9)+2*dL9_8dt*skew(gx)*Tphi9) - ...
	gy*gz'*skew(omega9)*skew(gx)*Tphi9;

dT8 = [dTr8;dTphi8];
dT9 = [dTr9;dTphi9];
%% Body 10 & Body 11
r10 = r4+R4*Joint_Parameter{4}.Joint{3}.r;
r11 = r5+R5*Joint_Parameter{5}.Joint{3}.r;

L10_11 = norm(r11 - r10);
L10 = BodyElementParameter{10}.L;
L11 = BodyElementParameter{11}.L;
cosPhi_4_10 = (L10_11^2 + L10^2 - L11^2)/(2*L10_11*L10);
Phi_4_10 = acos(cosPhi_4_10);
Temp_nx4 = (r11 - r10) / L10_11;
Temp_ny4 = R4(:,2);
Temp_nz4 = skew(Temp_nx4) * Temp_ny4;
Temp_R4 = [Temp_nx4,Temp_ny4,Temp_nz4];

R10 = Temp_R4 * get_R_Symbolic([0;-Phi_4_10;0]);
nx10 = R10(:,1);
nz10 = R10(:,3);
% phi10 = get_Rotation_from_R(R10,[0;0;0]);

rp = r10+R10*Joint_Parameter{10}.Joint{2}.r;
nx11 = (rp - r11) / norm(rp - r11);
ny11 = R5(:,2);
nz11 = skew(nx11) * ny11;
R11 = [nx11,ny11,nz11];
% phi11 = get_Rotation_from_R(R11,[0;0;0]);

% q10 = [r10;phi10];
% q11 = [r11;phi11];
%
Tr10 = Tr4 - R4*skew(Joint_Parameter{4}.Joint{3}.r)*Tphi4;
Tr11 = Tr5 - R5*skew(Joint_Parameter{5}.Joint{3}.r)*Tphi5;

Tphi10 = 1/(nx11'*nz10*L10)*gy*nx11'*(Tr10-Tr11) + ...
	(eye(3)-1/(nx11'*nz10)*gy*nx11'*R10*skew(gx))*R10'*R4*Tphi4 + ...
	L11/(nx11'*nz10*L10)*gy*nx11'*R11*skew(gx)*R11'*R5*Tphi5;
Tphi11 = 1/(nx10'*nz11*L11)*gy*nx10'*(Tr11-Tr10) + ...
	(eye(3)-1/(nx10'*nz11)*gy*nx10'*R11*skew(gx))*R11'*R5*Tphi5 + ...
	L10/(nx10'*nz11*L11)*gy*nx10'*R10*skew(gx)*R10'*R4*Tphi4;

T10 = [Tr10;Tphi10];
T11 = [Tr11;Tphi11];
%
dr10dt = Tr10 * dq;
omega10 = Tphi10 * dq;
dq10 = [dr10dt;omega10];

dr11dt = Tr11 * dq;
omega11 = Tphi11 * dq;
dq11 = [dr11dt;omega11];
%
dphi4_10dt = 1/(L10*nx11'*nz10)*nx11'* ...
	(dr10dt-dr11dt+L11*R11*skew(gx)*R11'*R5*omega5-L10*R10*skew(gx)*R10'*R4*omega4);
dphi5_11dt = -1/(L11*nx10'*nz11)*nx10'* ...
	(dr10dt-dr11dt+L11*R11*skew(gx)*R11'*R5*omega5-L10*R10*skew(gx)*R10'*R4*omega4);

% Tphi4_10 = 1/(L10*nx11'*nz10)*nx11'* ...
% 	(Tr10-Tr11+L11*R11*skew(gx)*R11'*R5*Tphi5-L10*R10*skew(gx)*R10'*R4*Tphi4);
%
dTr10 = dTr4 - R4*skew(Joint_Parameter{4}.Joint{3}.r)*dTphi4 - ...
	R4*skew(omega4)*skew(Joint_Parameter{4}.Joint{3}.r)*Tphi4;
dTr11 = dTr5 - R5*skew(Joint_Parameter{5}.Joint{3}.r)*dTphi5 - ...
	R5*skew(omega5)*skew(Joint_Parameter{5}.Joint{3}.r)*Tphi5;

dTphi10 = R10'*R4*dTphi4 - dphi4_10dt*skew(gy)*Tphi10 + ...
	L11/(L10*nx11'*nz10)*gy*nx11'*R11* ...
	(skew(gx)*R11'*R5*dTphi5+(skew(omega11)*skew(gx)-dphi5_11dt*skew(gx)*skew(gy))*Tphi11) - ...
	1/(nx11'*nz10)*gy*nx11'*R10* ...
	(skew(gx)*R10'*R4*dTphi4+(skew(omega10)*skew(gx)-dphi4_10dt*skew(gx)*skew(gy))*Tphi10);
dTphi11 = R11'*R5*dTphi5 - dphi5_11dt*skew(gy)*Tphi11 + ...
	L10/(L11*nx10'*nz11)*gy*nx10'*R10* ...
	(skew(gx)*R10'*R4*dTphi4+(skew(omega10)*skew(gx)-dphi4_10dt*skew(gx)*skew(gy))*Tphi10) - ...
	1/(nx10'*nz11)*gy*nx10'*R11* ...
	(skew(gx)*R11'*R5*dTphi5+(skew(omega11)*skew(gx)-dphi5_11dt*skew(gx)*skew(gy))*Tphi11);

dT10 = [dTr10;dTphi10];
dT11 = [dTr11;dTphi11];
%% Body 12 & Body 13
r12 = rp;
nx12 = (r7 - r12) / norm(r7 - r12);
ny12 = R11(:,2);
nz12 = skew(nx12) * ny12;
R12 = [nx12,ny12,nz12];
% phi12 = get_Rotation_from_R(R12,[0;0;0]);

r13 = r7;
R13 = R12 * get_R_Symbolic([0;pi;0]);
% phi13 = get_Rotation_from_R(R13,[0;0;0]);

% q12 = [r12;phi12];
% q13 = [r13;phi13];
%
Tr12 = (eye(3)-1/(nx11'*nz10)*R10*skew(gx)*gy*nx11')* ...
	(Tr10 - L10*R10*skew(gx)*R10'*R4*Tphi4) + ...
	1/(nx11'*nz10)*R10*skew(gx)*gy*nx11'* ...
	(Tr11 - L11*R11*skew(gx)*R11'*R5*Tphi5) - ...
	L10*(eye(3)-1/(nx11'*nz10)*R10*skew(gx)*gy*nx11')*R10*skew(gx)*R10'*R4*Tphi4 - ...
	L11/(nx11'*nz10)*R10*skew(gx)*gy*nx11'*R11*skew(gx)*R11'*R5*Tphi5;
Tr13 = Tr7;

L12_13 = norm(r13 - r12);

Tphi12 = (eye(3) - gy*gz'*skew(gx))*R12'*R11*Tphi11 - ...
	1/L12_13*gy*gz'*R12'*(Tr13 - Tr12);
Tphi13 = (eye(3) - gy*gz'*skew(gx))*R13'*R7*Tphi7 - ...
	1/L12_13*gy*gz'*R13'*(Tr12 - Tr13);


T12 = [Tr12;Tphi12];
T13 = [Tr13;Tphi13];
%
dr12dt = Tr12 * dq;
omega12 = Tphi12 * dq;
dq12 = [dr12dt;omega12];

dr13dt = Tr13 * dq;
omega13 = Tphi13 * dq;
dq13 = [dr13dt;omega13];


dphi11_12dt = -1/L12_13*gz' * ...
	(R12'*(dr13dt-dr12dt) + L12_13*skew(gx)*R12'*R11*omega11);
dphi7_13dt = -1/L12_13*gz' * ...
	(R13'*(dr12dt-dr13dt) + L12_13*skew(gx)*R13'*R7*omega7);
dL12_13dt = gx' * ...
	(R12'*(dr13dt-dr12dt) + L12_13*skew(gx)*R12'*R11*omega11);
dL13_12dt = gx' * ...
	(R13'*(dr12dt-dr13dt) + L12_13*skew(gx)*R13'*R7*omega7);
%
dTr12 = (eye(3)-1/(nx11'*nz10)*R10*skew(gx)*gy*nx11'- ...
	1/(nx11'*nz10)*R10*skew(omega10)*skew(gx)*gy*nx11') * dTr10 + ...
	1/(nx11'*nz10)*R10*(eye(3)+skew(omega10))*skew(gx)*gy*nx11'*dTr11 + ...
	L10*R10*(1/(nx11'*nz10)*skew(omega10)*skew(gx)*gy*nx11'*R10*skew(gx)*R10'*R4 - ...
	skew(omega10)*skew(gx)*R10'*R4 + skew(gx)*skew(omega10)*R10'*R4 - ...
	skew(gx)*R10'*R4*skew(omega4))*Tphi4 - ...
	L11/(nx11'*nz10)*R10*skew(omega10)*skew(gx)*gy*nx11'*R11*skew(gx)*R11'*R5*Tphi5 + ...
	L10*R10*skew(gx)*(1/(nx11'*nz10)*gy*nx11'*R10*skew(gx)-eye(3))*R10'*R4*dTphi4 - ...
	L11/(nx11'*nz10)*R10*skew(gx)*gy*nx11'*R11*(skew(omega11)*skew(gx)-dphi5_11dt*skew(gx)*skew(gy))*Tphi11 + ...
	L10/(nx11'*nz10)*R10*skew(gx)*gy*nx11'*R11*(skew(omega10)*skew(gx)-dphi4_10dt*skew(gx)*skew(gy))*Tphi10;
dTr13 = dTr7;

dTphi12 = (eye(3)-gy*gz'*skew(gx))*R12'*R11*dTphi11 - ...
	dphi11_12dt*(eye(3)-gy*gz'*skew(gx))*skew(gy)*Tphi11 - ...
	1/L12_13*gy*gz'*(R11'*(dTr13-dTr12)+2*dL12_13dt*skew(gx)*Tphi11) - ...
	gy*gz'*skew(omega11)*skew(gx)*Tphi11;
dTphi13 = (eye(3)-gy*gz'*skew(gx))*R13'*R7*dTphi7 - ...
	dphi7_13dt*(eye(3)-gy*gz'*skew(gx))*skew(gy)*Tphi13 - ...
	1/L12_13*gy*gz'*(R13'*(dTr12-dTr13)+2*dL13_12dt*skew(gx)*Tphi13) - ...
	gy*gz'*skew(omega13)*skew(gx)*Tphi13;

dT12 = [dTr12;dTphi12];
dT13 = [dTr13;dTphi13];
%%
r0b = cell(13,1);
r0b{1}  = r1;	r0b{2}  = r2;	r0b{3}  = r3;	r0b{4}  = r4;	r0b{5}  = r5;
r0b{6}  = r6;	r0b{7}  = r7;	r0b{8}  = r8;	r0b{9}  = r9;	r0b{10} = r10;
r0b{11} = r11;	r0b{12} = r12;	r0b{13} = r13;
%%
Rb = cell(13,1);
Rb{1}  = R1;	Rb{2}  = R2;	Rb{3}  = R3;	Rb{4}  = R4;	Rb{5}  = R5;
Rb{6}  = R6;	Rb{7}  = R7;	Rb{8}  = R8;	Rb{9}  = R9;	Rb{10} = R10;
Rb{11} = R11;	Rb{12} = R12;	Rb{13} = R13;
%%
dqb = cell(13,1);
dqb{1}  = dq1;	dqb{2}  = dq2;	dqb{3}  = dq3;	dqb{4}  = dq4;	dqb{5}  = dq5;
dqb{6}  = dq6;	dqb{7}  = dq7;	dqb{8}  = dq8;	dqb{9}  = dq9;	dqb{10} = dq10;
dqb{11} = dq11;	dqb{12} = dq12;	dqb{13} = dq13;
%%
Tb = cell(13,1);
Tb{1}  = T1;	Tb{2}  = T2;	Tb{3}  = T3;	Tb{4}  = T4;	Tb{5}  = T5;
Tb{6}  = T6;	Tb{7}  = T7;	Tb{8}  = T8;	Tb{9}  = T9;	Tb{10} = T10;
Tb{11} = T11;	Tb{12} = T12;	Tb{13} = T13;
%%
dTb = cell(13,1);
dTb{1}  = dT1;	dTb{2}  = dT2;	dTb{3}  = dT3;	dTb{4}  = dT4;	dTb{5}  = dT5;
dTb{6}  = dT6;	dTb{7}  = dT7;	dTb{8}  = dT8;	dTb{9}  = dT9;	dTb{10} = dT10;
dTb{11} = dT11;	dTb{12} = dT12;	dTb{13} = dT13;

end
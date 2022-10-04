function DriveForce = get_FoldingBoom_3DoF_DriveForce(u,qb,Tb,ModelParameter)
Joint_Parameter = ModelParameter.Joint_Parameter;
DriveForce = zeros(3,1);
ut = u(1);
u1 = u(2);
u2 = u(3);
%% Torsion
T1 = Tb{1};
Tphi1 = T1(4:6,:);

Mt = [0;0;ut];
DriveForce = DriveForce + Tphi1'*Mt;
%% Lower Drive Lower Part
q8 = qb{8};
phi8 = q8(4:6);
R8 = get_R(phi8);

T8 = Tb{8};
Tr8 = T8(1:3,:);
Tphi8 = T8(4:6,:);
Tr8_2 = Tr8 - R8*skew(Joint_Parameter{8}.Joint{2}.r)*Tphi8;

FLL = R8*[-u1;0;0];
DriveForce = DriveForce + Tr8_2'*FLL;
%% Lower Drive Upper Part
q9 = qb{9};
phi9 = q9(4:6);
R9 = get_R(phi9);

T9 = Tb{9};
Tr9 = T9(1:3,:);
Tphi9 = T9(4:6,:);
Tr9_2 = Tr9 - R9*skew(Joint_Parameter{9}.Joint{2}.r)*Tphi9;

FLU = R9*[-u1;0;0];
DriveForce = DriveForce + Tr9_2'*FLU;
%% Upper Drive Lower Part
q12 = qb{12};
phi12 = q12(4:6);
R12 = get_R(phi12);

T12 = Tb{12};
Tr12 = T12(1:3,:);
Tphi12 = T12(4:6,:);
Tr12_2 = Tr12 - R12*skew(Joint_Parameter{12}.Joint{2}.r)*Tphi12;

FUL = R12*[-u2;0;0];
DriveForce = DriveForce + Tr12_2'*FUL;
%% Upper Drive Upper Part
q13 = qb{13};
phi13 = q13(4:6);
R13 = get_R(phi13);

T13 = Tb{13};
Tr13 = T13(1:3,:);
Tphi13 = T13(4:6,:);
Tr13_2 = Tr13 - R13*skew(Joint_Parameter{13}.Joint{2}.r)*Tphi13;

FUU = R13*[-u2;0;0];
DriveForce = DriveForce + Tr13_2'*FUU;
%%
DriveForce = -DriveForce;
end
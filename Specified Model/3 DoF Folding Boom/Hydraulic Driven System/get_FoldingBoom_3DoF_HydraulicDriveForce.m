function DriveForce = get_FoldingBoom_3DoF_HydraulicDriveForce(...
	u,qb,Tb,ModelParameter)
%%
ut = u(1);
pL1 = u(2);
pL2 = u(3);
pU1 = u(4);
pU2 = u(5);
%%
Joint_Parameter = ModelParameter.Joint_Parameter;

% HydraulicParameter = ModelParameter.HydraulicParameter;
HydraulicCylinderParameter = HydraulicParameter.HydraulicCylinderParameter;
% Lower Hydraulic Cylinder
alphaL = HydraulicCylinderParameter{1}.alpha;
AL = HydraulicCylinderParameter{1}.A;
% Upper Hydraulic Cylinder
alphaU = HydraulicCylinderParameter{2}.alpha;
AU = HydraulicCylinderParameter{2}.A;

DriveForce = zeros(3,1);
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
%
Tr8_2 = Tr8 - R8*skew(Joint_Parameter{8}.Joint{2}.r)*Tphi8;
FLL2 = R8*[alphaL*pL2*AL;0;0];
DriveForce = DriveForce + Tr8_2'*FLL2;
%
Tr8_7 = Tr8 - R8*skew(Joint_Parameter{8}.Joint{7}.r)*Tphi8;
FLL1 = R8*[-pL1*AL;0;0];
DriveForce = DriveForce + Tr8_7'*FLL1;
%% Lower Drive Upper Part
q9 = qb{9};
phi9 = q9(4:6);
R9 = get_R(phi9);

T9 = Tb{9};
Tr9 = T9(1:3,:);
Tphi9 = T9(4:6,:);
%
Tr9_2 = Tr9 - R9*skew(Joint_Parameter{9}.Joint{2}.r)*Tphi9;
FLU = R9*[alphaL*pL2*AL-pL1*AL;0;0];
DriveForce = DriveForce + Tr9_2'*FLU;
%% Upper Drive Lower Part
q12 = qb{12};
phi12 = q12(4:6);
R12 = get_R(phi12);

T12 = Tb{12};
Tr12 = T12(1:3,:);
Tphi12 = T12(4:6,:);
%
Tr12_2 = Tr12 - R12*skew(Joint_Parameter{12}.Joint{2}.r)*Tphi12;
FUL2 = R12*[alphaU*pU2*AU;0;0];
DriveForce = DriveForce + Tr12_2'*FUL2;
%
Tr12_7 = Tr12 - R12*skew(Joint_Parameter{12}.Joint{7}.r)*Tphi12;
FUL1 = R12*[-pU1*AU;0;0];
DriveForce = DriveForce + Tr12_7'*FUL1;
%% Upper Drive Upper Part
q13 = qb{13};
phi13 = q13(4:6);
R13 = get_R(phi13);

T13 = Tb{13};
Tr13 = T13(1:3,:);
Tphi13 = T13(4:6,:);
%
Tr13_2 = Tr13 - R13*skew(Joint_Parameter{13}.Joint{2}.r)*Tphi13;
FUU = R13*[alphaU*pU2*AU-pU1*AU;0;0];
DriveForce = DriveForce + Tr13_2'*FUU;
%%
DriveForce = -DriveForce;
end
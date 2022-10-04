function dx = FoldingBoom_3DoF_Hydraulic_Dynamic_func(t,x,u, ...
	ModelParameter,SolverParameter,ComputingFigure)
%%
q = x(1:3);
dq = x(4:6);
%%
g = ModelParameter.g;
BodyElementParameter = ModelParameter.BodyElementParameter;
%%
[qb,dqb,Tb,dTb] = get_FoldingBoom_3DoF_ElementCoordinate(...
	q,dq,ModelParameter);
%%
BodyQuantity = numel(BodyElementParameter);
Mass = zeros(3);
Force = zeros(3,1);
q_plot = zeros(6*BodyQuantity,1);
for BodyNr = 1:BodyQuantity
	qe = qb{BodyNr};
	dqe = dqb{BodyNr};
	Te = Tb{BodyNr};
	dTe = dTb{BodyNr};
	RigidBodyParameter = BodyElementParameter{BodyNr};
	[BodyMass,BodyForce] = ...
		RigidBody_MassForce(qe,dqe,g,RigidBodyParameter);
	Mass = Mass + Te'*BodyMass*Te;
	Force = Force + Te'*BodyMass*dTe*dq + Te'*BodyForce;
	%
	q_plot(6*(BodyNr-1)+[1:6]) = qe;
end
%% Add Drive Force
ut = u(1);
pL1 = x(7);pL2 = x(7);pU1 = x(8);pU2 = x(8);
um = [ut;pL1;pL2;pU1;pU2];
DriveForce = get_FoldingBoom_3DoF_HydraulicDriveForce(um,qb,Tb,ModelParameter);
Force = Force + DriveForce;
%% Hydraulic Dynamics
[s,dsdt] = FoldingBoom_3DoF_Mech2Hydr_Interface(qb,dqb,ModelParameter);
[QL1,QL2,QU1,QU2] = FoldingBoom_3DoF_HydraulicControlSystem(...
	x,u,s,dsdt,ModelParameter);
%
HydraulicParameter = ModelParameter.HydraulicParameter;

s1 = s(1);
ds1dt = dsdt(1);
HydraulicOilParameter = HydraulicParameter.HydraulicOilParameter;
HydraulicCylinderParameter = HydraulicParameter.HydraulicCylinderParameter{1};
[dpL1dt,dpL2dt] = DoubleActing_HydraulicCylinder_Dynamic_func(...
	s1,ds1dt,QL1,QL2,HydraulicOilParameter,HydraulicCylinderParameter);

s2 = s(2);
ds2dt = dsdt(2);
HydraulicOilParameter = HydraulicParameter.HydraulicOilParameter;
HydraulicCylinderParameter = HydraulicParameter.HydraulicCylinderParameter{2};
[dpU1dt,dpU2dt] = DoubleActing_HydraulicCylinder_Dynamic_func(...
	s2,ds2dt,QU1,QU2,HydraulicOilParameter,HydraulicCylinderParameter);
%
dp1dt = dpL1dt;
dp2dt = dpU1dt;
%%
ddq = - Mass \ Force;
dx = [dq;ddq;dp1dt;dp2dt];
%%
fprintf('t = %16.14f\n',t);
plot_Mechanism(q_plot,ModelParameter,SolverParameter,ComputingFigure);
drawnow;
% pause(0.01);
end
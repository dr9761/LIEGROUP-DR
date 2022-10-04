function Force = FoldingBoom_3DoF_Hydraulic_Dynamic_Force(...
	q,p,ModelParameter)
%%
dq = zeros(3,1);
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
ut = 0;
pL1 = p(1);pL2 = p(1);pU1 = p(2);pU2 = p(2);
um = [ut;pL1;pL2;pU1;pU2];
DriveForce = get_FoldingBoom_3DoF_HydraulicDriveForce(um,qb,Tb,ModelParameter);
Force = Force + DriveForce;
end
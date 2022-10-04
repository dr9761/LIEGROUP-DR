function dx = FoldingBoom_3DoF_Dynamic_func(t,x,u, ...
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
% u = u * 1e6;
DriveForce = get_FoldingBoom_3DoF_DriveForce(u,qb,Tb,ModelParameter);
Force = Force + DriveForce;
%%
ddq = - Mass \ Force;
dx = [dq;ddq];
%%
% fprintf('t = %16.14f\n',t);
hold(ComputingFigure,'off');

plot_Mechanism(q_plot,ModelParameter,SolverParameter,ComputingFigure);
drawnow;
% pause(0.01);
end
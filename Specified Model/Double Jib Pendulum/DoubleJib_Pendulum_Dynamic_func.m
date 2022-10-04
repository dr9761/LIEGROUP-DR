function dx = DoubleJib_Pendulum_Dynamic_func(t,x,u, ...
	ModelParameter,SolverParameter,ComputingFigure)
%%
q = x(1:4);
dq = x(5:8);
%%
g = ModelParameter.g;
BodyElementParameter = ModelParameter.BodyElementParameter;
%%
[qb,dqb,Tb,dTb] = get_DoubleJib_Pendulum_ElementCoordinate(...
	q,dq,ModelParameter);
%%
BodyQuantity = numel(BodyElementParameter);
Mass = zeros(numel(q));
Force = zeros(numel(q),1);
q_plot = zeros(6*BodyQuantity,1);
for BodyNr = 1:BodyQuantity
	qe = qb{BodyNr};
	dqe = dqb{BodyNr};
	Te = Tb{BodyNr};
	dTe = dTb{BodyNr};
	RigidBodyParameter = BodyElementParameter{BodyNr};
	if BodyNr == BodyQuantity
		[BodyMass,BodyForce] = ...
			PointMass_MassForce(qe,dqe,g,RigidBodyParameter);
		%
		q_plot(6*(BodyNr-1)+[1:3]) = qe;
	else
		[BodyMass,BodyForce] = ...
			RigidBody_MassForce(qe,dqe,g,RigidBodyParameter);
		%
		q_plot(6*(BodyNr-1)+[1:6]) = qe;
	end
	Mass = Mass + Te'*BodyMass*Te;
	Force = Force + Te'*BodyMass*dTe*dq + Te'*BodyForce;
	
end
%% Add Drive Force
% if mod(floor(t),2) == 1
% 	u = -2*u;
% end
DriveForce = get_DoubleJib_Pendulum_DriveForce(u,Tb);
Force = Force + DriveForce;
%%
ddq = - Mass \ Force;
dx = [dq;ddq];
%%
fprintf('t = %16.14f\n',t);
% fprintf('\tL = %16.14f\n',norm(q_plot(13:15)-q_plot(7:9)));
plot_Mechanism(q_plot,ModelParameter,SolverParameter,ComputingFigure);
% view(ComputingFigure,0,90);
drawnow;
% pause(0.01);
end
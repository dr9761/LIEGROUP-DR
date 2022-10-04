function [dx,Mass,Force] = DoubleJib_Pendulum_Dynamic_func_Symbolic(x,u, ...
	ModelParameter)
%%
q = x(1:4);
dq = x(5:8);
%%
g = ModelParameter.g;
BodyElementParameter = ModelParameter.BodyElementParameter;
%%
[r0b,Rb,dqb,Tb,dTb] = get_DoubleJib_Pendulum_ElementCoordinate_Symbolic(...
	q,dq,ModelParameter);
%%
BodyQuantity = numel(BodyElementParameter);
Mass = casadi.SX.zeros(numel(q),numel(q));
Force = casadi.SX.zeros(numel(q),1);
for BodyNr = 1:BodyQuantity
% 	qe = qb{BodyNr};
	r0e = r0b{BodyNr};
	Re = Rb{BodyNr};
	dqe = dqb{BodyNr};
	Te = Tb{BodyNr};
	dTe = dTb{BodyNr};
	RigidBodyParameter = BodyElementParameter{BodyNr};
	if BodyNr == BodyQuantity
		[BodyMass,BodyForce] = ...
			PointMass_MassForce(...
			[],dqe,g,RigidBodyParameter);
	else
		[BodyMass,BodyForce] = ...
			RigidBody_fromR_MassForce(...
			Re,dqe,g,RigidBodyParameter);
	end
	Mass = Mass + Te'*BodyMass*Te;
	Force = Force + Te'*BodyMass*dTe*dq + Te'*BodyForce;
	
end
%% Add Drive Force
DriveForce = get_DoubleJib_Pendulum_DriveForce_Symbolic(u,Tb);
Force = Force + DriveForce;
%%
ddq = - Mass \ Force;
dx = [dq;ddq];
%%
% fprintf('t = %16.14f\n',t);
% fprintf('\tL = %16.14f\n',norm(q_plot(13:15)-q_plot(7:9)));
% plot_Mechanism(q_plot,ModelParameter,SolverParameter,ComputingFigure);
% view(ComputingFigure,0,90);
% drawnow;
% pause(0.01);
end
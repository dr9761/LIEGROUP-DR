function [dx,Mass,Force] = SingleJib_Pendulum_Dynamic_func_Symbolic(x,u, ...
	ModelParameter)
%%
q = x(1:3);
dq = x(4:6);
%%
g = ModelParameter.g;
BodyElementParameter = ModelParameter.BodyElementParameter;
%%
[r0b,Rb,dqb,Tb,dTb] = get_SingleJib_Pendulum_ElementCoordinate_Symbolic(...
	q,dq,ModelParameter);
%%
BodyQuantity = numel(BodyElementParameter);
Mass = casadi.SX.zeros(3,3);
Force = casadi.SX.zeros(3,1);
for BodyNr = 1:BodyQuantity
% 	qe = qb{BodyNr};
	r0e = r0b{BodyNr};
	Re = Rb{BodyNr};
	dqe = dqb{BodyNr};
	Te = Tb{BodyNr};
	dTe = dTb{BodyNr};
	RigidBodyParameter = BodyElementParameter{BodyNr};
	if BodyNr == 3
		[BodyMass,BodyForce] = ...
			PointMass_MassForce(...
			[],dqe,g,RigidBodyParameter);
	else
		[BodyMass,BodyForce] = ...
			SingleJib_Pendulum_RigidBody_MassForce_Symbolic(...
			r0e,Re,dqe,g,RigidBodyParameter);
	end
	Mass = Mass + Te'*BodyMass*Te;
	Force = Force + Te'*BodyMass*dTe*dq + Te'*BodyForce;
	
end
%% Add Drive Force
DriveForce = get_SingleJib_Pendulum_DriveForce_Symbolic(u,Tb);
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
function [dx,Mass,Force] = FoldingBoom_3DoF_Dynamic_func_Symbolic(...
	x,u,ModelParameter)
%%
q = x(1:3);
dq = x(4:6);
%%
g = ModelParameter.g;
BodyElementParameter = ModelParameter.BodyElementParameter;
%%
[r0b,Rb,dqb,Tb,dTb] = get_FoldingBoom_3DoF_ElementCoordinate_Symbolic(...
	q,dq,ModelParameter);
%%
BodyQuantity = numel(BodyElementParameter);
Mass = zeros(3);
Force = zeros(3,1);
q_plot = zeros(6*BodyQuantity,1);
for BodyNr = 1:BodyQuantity
	r0e = r0b{BodyNr};
	Re = Rb{BodyNr};
	dqe = dqb{BodyNr};
	
	RigidBodyParameter = BodyElementParameter{BodyNr};
	[BodyMass,BodyForce] = ...
		FoldingBoom_3DoF_RigidBody_MassForce_Symbolic(...
		r0e,Re,dqe,g,RigidBodyParameter);
	%
	Te = Tb{BodyNr};
	dTe = dTb{BodyNr};
	
	Mass = Mass + Te'*BodyMass*Te;
	Force = Force + Te'*BodyMass*dTe*dq + Te'*BodyForce;
end
%% Add Drive Force
DriveForce = get_FoldingBoom_3DoF_DriveForce_Symbolic(u,Rb,Tb,ModelParameter);
Force = Force + DriveForce;
%%
ddq = - Mass \ Force;
dx = [dq;ddq];
%%
% fprintf('t = %16.14f\n',t);
% plot_Mechanism(q_plot,ModelParameter,SolverParameter,ComputingFigure);
% drawnow;
% pause(0.01);
end
function Force = TripleJib_Pendulum_Dynamic_Force(q,u, ...
	ModelParameter)
%%
dq = zeros(numel(q),1);
%%
g = ModelParameter.g;
BodyElementParameter = ModelParameter.BodyElementParameter;
%%
[qb,dqb,Tb,~] = get_TripleJib_Pendulum_ElementCoordinate(...
	q,dq,ModelParameter);
%%
BodyQuantity = numel(BodyElementParameter);
Force = zeros(numel(q),1);
for BodyNr = 1:BodyQuantity
	qe = qb{BodyNr};
	dqe = dqb{BodyNr};
	Te = Tb{BodyNr};
	RigidBodyParameter = BodyElementParameter{BodyNr};
	if BodyNr == BodyQuantity
		[~,BodyForce] = ...
			PointMass_MassForce(qe,dqe,g,RigidBodyParameter);
	else
		[~,BodyForce] = ...
			RigidBody_MassForce(qe,dqe,g,RigidBodyParameter);
	end
	Force = Force + Te'*BodyForce;
end
%% Add Drive Force
DriveForce = get_TripleJib_Pendulum_DriveForce(u,Tb);
Force = Force + DriveForce;

end
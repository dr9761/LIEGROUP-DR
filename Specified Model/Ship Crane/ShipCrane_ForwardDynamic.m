function [ddq, ...
	Mass_star,Force_star,B_star,C_star] = ...
	ShipCrane_ForwardDynamic(q,dq,s,u,ModelParameter)
%%
g = ModelParameter.g;
BodyElementParameter = ModelParameter.BodyElementParameter;
gx = [1;0;0];
gy = [0;1;0];
gz = [1;0;0];
%%
[~,Rn,dqn,~,Tn,dTn] = ShipCrane_ForwardKinematics(...
	q,dq,zeros(size(dq)),ModelParameter);
%%
BodyQuantity = 3;
Mass = zeros(numel(q));
Force = zeros(numel(q),1);
for BodyNr = 1:BodyQuantity
	Re = Rn{BodyNr};
	dqe = dqn{BodyNr};
	Te = Tn{BodyNr};
	dTe = dTn{BodyNr};
	RigidBodyParameter = BodyElementParameter{BodyNr};
	
	[BodyMass,BodyForce] = ...
			RigidBody_fromR_MassForce(...
			Re,dqe,g,RigidBodyParameter);
		
	Mass = Mass + Te'*BodyMass*Te;
	Force = Force + Te'*BodyMass*dTe*dq + Te'*BodyForce;
end
%%
Tphi1 = Tn{1}(4:6,:);
Tphi2 = Tn{2}(4:6,:);
Tphi3 = Tn{3}(4:6,:);
B = -[Tphi1'*gx,-Tphi2'*gy,-Tphi3'*gy];
%%
Mass_star = [eye(6),zeros(6,3);Mass(7:9,:)];
Force_star = [zeros(6,1);Force(7:9)];
B_star = [zeros(6,3);B(7:9,:)];
C_star = [-eye(6);zeros(3,6)];
%
ddq = - Mass_star \ (Force_star + B_star*u + C_star*s);
end
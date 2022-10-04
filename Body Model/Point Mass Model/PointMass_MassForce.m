function [Mass,Force] = ...
	PointMass_MassForce(qe,dqe,g,RigidBodyParameter)
%%
m_tot = RigidBodyParameter.m;

Mass  =  m_tot * eye(3);
Force = -m_tot * g;

end
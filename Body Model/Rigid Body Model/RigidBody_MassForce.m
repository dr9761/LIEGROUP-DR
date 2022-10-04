function [Mass,Force] = ...
	RigidBody_MassForce(qe,dqe,g,RigidBodyParameter)
%% Rigid Body Parameter
m_tot = RigidBodyParameter.m;
r_B_0C = RigidBodyParameter.r_B_0C;
theta_B_0 = RigidBodyParameter.theta_B_0;
%% generalized coordination
phi = qe(4:6);
R = get_R(phi);
%% generalized Velocity
omega = dqe(4:6);
%% virtual inertial power
Mass    = [	m_tot*eye(3),			-m_tot*R*skew(r_B_0C);
			m_tot*skew(r_B_0C)*R',	theta_B_0];
		
Dampfer = [	zeros(3,3),				m_tot*R*skew(omega)*skew(r_B_0C);
			zeros(3,3),				skew(omega)*theta_B_0];
%% virtual gravity power
F_ext_g = -m_tot * [eye(3);skew(r_B_0C)*R'] * g;
%% Force
Force = F_ext_g + Dampfer * dqe;
end
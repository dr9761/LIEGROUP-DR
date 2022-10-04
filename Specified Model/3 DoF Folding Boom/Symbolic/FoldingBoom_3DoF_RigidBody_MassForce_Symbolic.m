function [Mass,Force] = ...
	FoldingBoom_3DoF_RigidBody_MassForce_Symbolic(...
	r0e,Re,dqe,g,RigidBodyParameter)
%% Rigid Body Parameter
m_tot = RigidBodyParameter.m;
r_B_0C = RigidBodyParameter.r_B_0C;
theta_B_0 = RigidBodyParameter.theta_B_0;
%% generalized Velocity
omega = dqe(4:6);
%% virtual inertial power
Mass    = [	m_tot*eye(3),			-m_tot*Re*skew(r_B_0C);
			m_tot*skew(r_B_0C)*Re',	theta_B_0];
		
Dampfer = [	zeros(3,3),				m_tot*Re*skew(omega)*skew(r_B_0C);
			zeros(3,3),				skew(omega)*theta_B_0];
%% virtual gravity power
F_ext_g = -m_tot * [eye(3);skew(r_B_0C)*Re'] * g;
%% Force
Force = F_ext_g + Dampfer * dqe;
end
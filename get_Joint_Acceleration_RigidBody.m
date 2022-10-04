function ddrdtdt = get_Joint_Acceleration_RigidBody(qe,dqe,ddqe, ...
	r_B_0k)
%%
phi = qe(4:6);
R = get_R(phi);

omega = dqe(4:6);

ddr0dtdt = ddqe(1:3);
domegadt = ddqe(4:6);
%%
ddrdtdt = ddr0dtdt - R*skew(r_B_0k)*domegadt + ...
	R*skew(omega)*skew(r_B_0k)*omega;

end
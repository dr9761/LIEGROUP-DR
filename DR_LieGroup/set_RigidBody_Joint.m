function Joint = set_RigidBody_Joint(R, r,phi,qe,dqe)
%%
r0B = qe(1:3);
phiB = qe(4:6);

RB = get_R(phiB);
RBJ = get_R(phi);
%%
r0J = r0B + RB * r;
phiJ = get_Rotation_from_R(RB*RBJ,phiB);
%%
TJB = [	eye(3),		-RB*skew(r);
		zeros(3),	RBJ'];
%%
dqJ = TJB * dqe;
dr0Jdt = dqJ(1:3);
omegaJ = dqJ(4:6);
%%
Joint.r = r0J;
Joint.phi = phiJ;
Joint.R = R;

Joint.dr = dr0Jdt;
Joint.omega = omegaJ;

Joint.T_qi_q = TJB;
end
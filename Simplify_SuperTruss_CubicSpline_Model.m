Simplify_SuperTruss_CubicSpline_Model

r1   = [0;0;0];dr1dt  = [0;0;0];
phi1 = [0;0;0];omega1 = [0;0;0];
q1 = [r1;phi1];dq1 = [dr1dt;omega1];
q2 = [r2;phi2];dq2 = [dr2dt;omega2];
qe = [q1;q2];dqe = [dq1;dq2];

[Mass,Force] = Super_Truss_Element_MassForce(...
	qe,dqe,g,BodyParameter);


function dqedt = get_dqedt_CubicSplineBeam_Symbolic(qe,dqe)
%% qe  14x1
q1 = qe(1:7);
phi1 = q1(4:6);
T1 = get_T_Symbolic(phi1);

q2 = qe(8:14);
phi2 = q2(4:6);
T2 = get_T_Symbolic(phi2);
%% dqe 14x1
dq1 = dqe(1:7);
dr1dt  = dq1(1:3);
omega1 = dq1(4:6);
norm_ddr1dxdt = dq1(7);

dq2 = dqe(8:14);
dr2dt  = dq2(1:3);
omega2 = dq2(4:6);
norm_ddr2dxdt = dq2(7);
%% dqedt 14x1
dq1dt = casadi.SX.zeros(7,1);
dq1dt(1:3) = dr1dt;
dq1dt(4:6) = T1 \ omega1;
dq1dt(7) = norm_ddr1dxdt;

dq2dt = casadi.SX.zeros(7,1);
dq2dt(1:3) = dr2dt;
dq2dt(4:6) = T2 \ omega2;
dq2dt(7) = norm_ddr2dxdt;

dqedt = [dq1dt;dq2dt];
end
function Joint = set_CubicSplineBeam_Joint(qe,dqe)
%%
q1 = qe(1:7);
dq1 = dqe(1:7);
Joint{1}.T_qi_q = [eye(6,7),zeros(6,7)];
Joint{1}.r = q1(1:3);
Joint{1}.phi = q1(4:6);
Joint{1}.dr = dq1(1:3);
Joint{1}.omega = dq1(4:6);
%%
q2 = qe(8:14);
dq2 = dqe(8:14);
Joint{2}.T_qi_q = [zeros(6,7),eye(6,7)];
Joint{2}.r = q2(1:3);
Joint{2}.phi = q2(4:6);
Joint{2}.dr = dq2(1:3);
Joint{2}.omega = dq2(4:6);

end
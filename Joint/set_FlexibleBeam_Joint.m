function Joint = set_FlexibleBeam_Joint(qe,dqe)
%%
Joint{1}.T_qi_q = [eye(6),zeros(6)];
Joint{1}.r = qe(1:3);
Joint{1}.phi = qe(4:6);
Joint{1}.dr = dqe(1:3);
Joint{1}.omega = dqe(4:6);
%%
Joint{2}.T_qi_q = [zeros(6),eye(6)];
Joint{2}.r = qe(7:9);
Joint{2}.phi = qe(10:12);
Joint{2}.dr = dqe(7:9);
Joint{2}.omega = dqe(10:12);

end
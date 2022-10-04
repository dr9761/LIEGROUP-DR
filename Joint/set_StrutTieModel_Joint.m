function Joint = set_StrutTieModel_Joint(qe,dqe)
%%
Joint{1}.T_qi_q = [eye(3),zeros(3);zeros(3),zeros(3)];
Joint{1}.r = qe(1:3);
Joint{1}.dr = dqe(1:3);
%%
Joint{2}.T_qi_q = [zeros(3),eye(3);zeros(3),zeros(3)];
Joint{2}.r = qe(4:6);
Joint{2}.dr = dqe(4:6);

end
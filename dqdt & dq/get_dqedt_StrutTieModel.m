function dqedt = get_dqedt_StrutTieModel(qe,dqe)
%% qe  6x1
r1 = qe(1:3);
r2 = qe(4:6);
%% dqe 6x1
dr1dt = dqe(1:3);
dr2dt = dqe(4:6);
%% dqedt 6x1
dqedt = zeros(6,1);
dqedt(1:3) = dr1dt;
dqedt(4:6) = dr2dt;
end
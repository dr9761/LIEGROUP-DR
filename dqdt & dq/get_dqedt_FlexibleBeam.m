function dqedt = get_dqedt_FlexibleBeam(qe,dqe)
%% qe  12x1
r1 = qe(1:3);
phi1 = qe(4:6);
T1 = get_T(phi1);

r2 = qe(7:9);
phi2 = qe(10:12);
T2 = get_T(phi2);
%% dqe 12x1
dr1dt  = dqe(1:3);
omega1 = dqe(4:6);

dr2dt  = dqe(7:9);
omega2 = dqe(10:12);
%% dqedt 12x1
dqedt = zeros(12,1);
dqedt(1:3) = dr1dt;
dqedt(4:6) = T1 \ omega1;

dqedt(7:9) = dr2dt;
dqedt(10:12) = T2 \ omega2;
end
function dqedt = get_dqedt_RigidBody(qe,dqe)
%% qe  6x1
r = qe(1:3);
phi = qe(4:6);
T = get_T(phi);
%% dqe 6x1
drdt  = dqe(1:3);
omega = dqe(4:6);
%% dqedt 6x1
dqedt = zeros(6,1);
dqedt(1:3) = drdt;
dqedt(4:6) = T \ omega;

end
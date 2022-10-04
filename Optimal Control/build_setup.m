function d = build_setup(d, ...
	x_min,x_max,u_min,u_max, ...
	n_x,n_u,ts,tf,N_NMPC,x0)
%% state constraints
d.p.x_min = x_min;
d.p.x_max = x_max;
%% control input constraints
d.p.u_min = u_min;
d.p.u_max = u_max;
%% sampling time (in time units)
d.p.T = ts;
%% number of state variables
d.p.n_x = n_x;
%% number of control inputs
d.p.n_u = n_u;
%% simulation length (in number of time steps)
d.p.t_final = floor(tf / d.p.T);
%% NMPC prediction horizon (in number of time steps)
d.p.N_NMPC = min(N_NMPC,d.p.t_final);
% d.p.N_NMPC = N_NMPC;
%% pre-allocate memory
d.s.x = NaN(d.p.n_x,d.p.t_final);
d.s.u = NaN(d.p.n_u,d.p.t_final);
%% set initial state
d.p.x0 = x0;
d.s.x(:,1) = d.p.x0;
%% state limit constraints vector
d.p.x_min_v = d.p.x_min;
d.p.x_max_v = d.p.x_max;
%% control input limit constraints vector
d.p.u_min_v = d.p.u_min;
d.p.u_max_v = d.p.u_max;
end
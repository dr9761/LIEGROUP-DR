function d = create_NMPC(d,DynamicsFuncHandle, ...
	StageCostFuncHandle,TerminalCostFuncHandle, ...
	TerminalConstraintFuncHandle)
%% import dynamics
ode_casadi_NMPC = d.c.mpc.getCasadiFunc(...
	DynamicsFuncHandle, ...
	[d.p.n_x, d.p.n_u], ...
	{'x', 'u'});
%% discretize dynamics in time
F = d.c.mpc.getCasadiFunc(...
	ode_casadi_NMPC, ...
	[d.p.n_x, d.p.n_u], ...
	{'x', 'u'}, ...
	'rk4', true(), ...
	'Delta', d.p.T);
%% define stage cost
l = d.c.mpc.getCasadiFunc(StageCostFuncHandle, ...
	[d.p.n_x, d.p.n_u], ...
	{'x', 'u'});
%% define terminal cost
Vf = d.c.mpc.getCasadiFunc(TerminalCostFuncHandle, ...
	d.p.n_x, {'x'}, {'Vf'});
%% define terminal state constraint
ef = d.c.mpc.getCasadiFunc(TerminalConstraintFuncHandle, ...
	d.p.n_x, {'x'}, {'ef'});
%% define NMPC arguments
commonargs.l = l;
commonargs.lb.x = d.p.x_min_v;
commonargs.ub.x = d.p.x_max_v;
commonargs.lb.u = d.p.u_min_v;
commonargs.ub.u = d.p.u_max_v;
commonargs.Vf = Vf;
commonargs.ef = ef;
%% define NMPC problem dimensions
N.x = d.p.n_x; % state dimension
N.u = d.p.n_u; % control input dimension
N.t = d.p.N_NMPC; % time dimension (i.e., prediction horizon)
%% create NMPC solver
d.c.solvers.NMPC = d.c.mpc.nmpc(...
	'f', F, ... % dynamics (discrete-time)
	'N', N, ... % problem dimensions
	'Delta', d.p.T, ... % timestep
	'timelimit', 1800, ... % solver time limit (in seconds)
	'**', commonargs); % arguments

end
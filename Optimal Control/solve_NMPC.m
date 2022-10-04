function d = solve_NMPC(d,t)
% set state at time t as NMPC initial state
d.c.solvers.NMPC.fixvar('x', 1, d.s.x(:,t));
tic_c = tic;
% solve NMPC problem
d.c.solvers.NMPC.solve();
% record CPU time
d.s.CPU_time(t,1) = toc(tic_c);
% assign first element of the solution to the NMPC
% problem as the control input at time t
d.s.u(:,t) = d.c.solvers.NMPC.var.u(:,1);
% record the predicted state trajectory
% for the first time step
if t == 1	
	d.p.x_NMPC_t_1 = d.c.solvers.NMPC.var.x;
end
end
function [OptimalControlTrajectory,OptimalStateTrajectory] = ...
	solve_OptimalControl(d)
% set state at time t as NMPC initial state
d.c.solvers.NMPC.fixvar('x', 1, d.s.x(:,1));
% solve NMPC problem
d.c.solvers.NMPC.solve();
%
OptimalControlTrajectory = nan(size(d.s.u));
OptimalStateTrajectory = nan(size(d.s.x));
OptimalStateTrajectory(:,1) = d.p.x0;
for t = 1:d.p.N_NMPC
	OptimalControlTrajectory(:,t) = d.c.solvers.NMPC.var.u(:,t);
	OptimalStateTrajectory(:,t+1) = ...
		full(d.c.simulator(OptimalStateTrajectory(:,t), OptimalControlTrajectory(:,t)));
end
end
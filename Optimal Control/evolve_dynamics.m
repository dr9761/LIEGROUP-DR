function d = evolve_dynamics(d,t)
d.s.x(:,t+1) = ...
	full(d.c.simulator(d.s.x(:,t), d.s.u(:,t)));
end
function dxdt = define_dynamics(x, u)

dxdt = casadi.SX.zeros(4,1);
dxdt(1) = x(3);
dxdt(2) = x(4);
dxdt(3) = u(1);
dxdt(4) = u(2);

end
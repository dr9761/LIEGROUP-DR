function dxdt = Kinematics_2D_Dynamics(x,u)

dxdt = zeros(4,1);
dxdt(1:2) = x(3:4);
dxdt(3:4) = u;

end
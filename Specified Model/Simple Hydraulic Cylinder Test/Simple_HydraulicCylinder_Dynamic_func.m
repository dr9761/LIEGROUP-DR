function dx = Simple_HydraulicCylinder_Dynamic_func(...
	t,x,u)
% s0 = 0.01;
% t0 = 5;
% t1 = 0.3 * t0;
% t3 = 0.3 * t0;
% u = ThreeStage_PolyFunc_2(t,s0,t0,t1,t3);
u = t/5*0.01;
%% Parameter
A = 0.08;
K = 0;
L0 = 0;
HydraulicCylinderParameter.A = A;
HydraulicCylinderParameter.K = K;
HydraulicCylinderParameter.L0 = L0;
%
E = 1.29e9;
HydraulicOilParameter.E = E / 1e5;
%
m = 10;
F = 10000;
%% x = [s;dsdt;p]
s = x(1);
dsdt = x(2);
p = x(3);
%% Hydraulic Controll System
% xv = u;
% delta_p = p - pf;
% Q = cq*A0*sqrt(2*delta_p/rho)
Q = u;
%% Mechanic Dynamic
F = F + K*(s-L0);
ddsdtdt = 1/m * (1e5*p*A - F);
%% Mechanic-Hydraulic Interface
%% Hydraulic Dynamic
dpdt = SingleActing_HydraulicCylinder_Dynamic_func(...
	s,dsdt,Q,HydraulicOilParameter,HydraulicCylinderParameter);
%% state function
dx = [dsdt;ddsdtdt;dpdt];

%%
fprintf('t = %16.14f\n',t);
plot(s,0,'*');
axis([0;10;-1;1]);
grid on;
grid MINOR
drawnow;
end
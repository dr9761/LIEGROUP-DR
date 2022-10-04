% Simple_HydraulicCylinder_Test
%%
clc;clear;close all;
%%
s = 1;
dsdt = 0;
p = 1.25;

x = [s;dsdt;p];
%
u = 0.01;
%%
x0 = x;
tspan = [0,5];
AbsoluteTolerance = 0.001;
RelativeTolerance = 0.001;
MaxStep = 0.05;
opt = odeset('RelTol',RelativeTolerance, ...
	'AbsTol',AbsoluteTolerance, ...
	'MaxStep',MaxStep, ...
	'OutputFcn',[]);
%
[t_set,x_set] = ode23tb(...
	@(t,x)Simple_HydraulicCylinder_Dynamic_func(...
	t,x,u),tspan,x0,opt);
% Runge_Kutta_4
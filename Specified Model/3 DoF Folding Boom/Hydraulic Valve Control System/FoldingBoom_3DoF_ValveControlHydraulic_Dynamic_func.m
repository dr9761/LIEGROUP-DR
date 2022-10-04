function dx = FoldingBoom_3DoF_ValveControlHydraulic_Dynamic_func(t,x,u,up,tspan, ...
	ModelParameter,HydraulicParameter,SolverParameter,ComputingFigure)
%%
q = x(1:3);
dq = x(4:6);
%%
SwitchGap = 1;
SwitchGap = min(SwitchGap,tspan(2)-tspan(1));
SwitchTspan = tspan(1) + [0;SwitchGap];
u(1) = tanh_Substitute(t,SwitchTspan,[up(1);u(1)],0.99);
u(2) = tanh_Substitute(t,SwitchTspan,[up(2);u(2)],0.99);
u(3) = tanh_Substitute(t,SwitchTspan,[up(3);u(3)],0.99);
% u = up + (u-up) * (t-tspan(1)) / (tspan(2)-tspan(1));

% if t < 0
% 	u(2) = 0;
% 	u(3) = 0;
% elseif t < 10
% 	u(2) = t/10;
% 	u(3) = t/10;
% else
% 	u(2) = 1;
% 	u(3) = 1;
% end
%%
g = ModelParameter.g;
BodyElementParameter = ModelParameter.BodyElementParameter;

% HydraulicEquation = HydraulicParameter.HydraulicEquation;
% PressureFlowIndex = HydraulicParameter.PressureFlowIndex;
HydraulicElementParameter = HydraulicParameter.HydraulicElementParameter;
HydraulicOilParameter = HydraulicParameter.HydraulicOilParameter;
HydraulicConnectionParameter = HydraulicParameter.HydraulicConnectionParameter;
HydraulicSymbolicStateSolution = HydraulicParameter.HydraulicSymbolicStateSolution;
HydraulicSymbolicStateSolutionHandle = HydraulicParameter.HydraulicSymbolicStateSolutionHandle;
% HydraulicParameter.HydraulicNumericalEquationHandle = ...
% 	@(HydraulicState)create_HydraulicCalculationEquation_Numerical(HydraulicState,x,u, ...
% 	HydraulicOilParameter,HydraulicElementParameter, ...
% 	HydraulicConnectionParameter);
%%
[qb,dqb,Tb,dTb] = get_FoldingBoom_3DoF_ElementCoordinate(...
	q,dq,ModelParameter);
%%
BodyQuantity = numel(BodyElementParameter);
Mass = zeros(3);
Force = zeros(3,1);
q_plot = zeros(6*BodyQuantity,1);
for BodyNr = 1:BodyQuantity
	qe = qb{BodyNr};
	dqe = dqb{BodyNr};
	Te = Tb{BodyNr};
	dTe = dTb{BodyNr};
	RigidBodyParameter = BodyElementParameter{BodyNr};
	[BodyMass,BodyForce] = ...
		RigidBody_MassForce(qe,dqe,g,RigidBodyParameter);
	Mass = Mass + Te'*BodyMass*Te;
	Force = Force + Te'*BodyMass*dTe*dq + Te'*BodyForce;
	%
	q_plot(6*(BodyNr-1)+[1:6]) = qe;
end
%% Add Drive Force
ut = u(1);
pL1 = 1e6*x(7);pL2 = 1e6*x(8);pU1 = 1e6*x(9);pU2 = 1e6*x(10);
um = [ut;pL1;pL2;pU1;pU2];
DriveForce = get_FoldingBoom_3DoF_ValveControlHydraulicDriveForce(...
	um,qb,Tb,ModelParameter,HydraulicParameter);
Force = Force + DriveForce;
%% Mechanical / Hydraulic Interface
[s,dsdt] = FoldingBoom_3DoF_Mech2Hydr_Interface(qb,dqb,ModelParameter);
%% Hydraulic Dynamics
% [~,HydraulicElementState] = ...
% 	solve_HydraulicCalculationEquatition_Numerical(...
% 	HydraulicParameter);
% QL1 = HydraulicElementState{3}.Q1;
% QL2 = HydraulicElementState{3}.Q2;
% QU1 = HydraulicElementState{8}.Q1;
% QU2 = HydraulicElementState{8}.Q2;

% HydraulicElementState = solve_HydraulicCalculationEquatition(...
% 	x,u,HydraulicSymbolicStateSolution);
HydraulicElementState = ...
	HydraulicSymbolicStateSolutionHandle(u(2),u(3),x(7),x(8),x(9),x(10));
QL1 = HydraulicElementState(3,3);
QL2 = HydraulicElementState(3,4);
QU1 = HydraulicElementState(8,3);
QU2 = HydraulicElementState(8,4);
%%
s1 = s(1);
ds1dt = dsdt(1);
% HydraulicOilParameter = HydraulicParameter.HydraulicOilParameter;
HydraulicCylinderParameter = HydraulicElementParameter{3};
[dpL1dt,dpL2dt] = DoubleActing_HydraulicCylinder_Dynamic_func(...
	s1,ds1dt,QL1,QL2,HydraulicOilParameter,HydraulicCylinderParameter);

s2 = s(2);
ds2dt = dsdt(2);
HydraulicOilParameter = HydraulicParameter.HydraulicOilParameter;
HydraulicCylinderParameter = HydraulicElementParameter{8};
[dpU1dt,dpU2dt] = DoubleActing_HydraulicCylinder_Dynamic_func(...
	s2,ds2dt,QU1,QU2,HydraulicOilParameter,HydraulicCylinderParameter);
%
% dp1dt = dpL1dt;
% dp2dt = dpU1dt;
%%
ddq = - Mass \ Force;
dx = [dq;ddq;dpL1dt;dpL2dt;dpU1dt;dpU2dt];
%%
% fprintf('t = %16.14f\n',t);
if t == tspan(2)
	plot_Mechanism(q_plot,ModelParameter,SolverParameter,ComputingFigure);
end
% drawnow;
end
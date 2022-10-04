clear;
L = 15;
ra = 0.15;
ri = 0;
rho = 7800;
A  = pi*(ra^2-ri^2);
m = A * L * rho;
theta_B_0 = ...
    [1/2*m*(ra^2-ri^2),		0,					0;
    0,						1/3*m*L^2,			0;
    0,						0,					1/3*m*L^2];
r_B_0C = [L/2;0;0];
RigidBodyParameter.m = m;
RigidBodyParameter.r_B_0C = r_B_0C;
RigidBodyParameter.theta_B_0 = theta_B_0;

g = [0;0;-9.8];

Action = zeros(6,1);
[InitialObservation,LoggedSignals] = ...
    ResetFunction_RigidPendulum_Test();

[NextObs,Reward,IsDone,LoggedSignals] = ...
    StepFunction_RigidPendulum_Test(Action,LoggedSignals,RigidBodyParameter,g);
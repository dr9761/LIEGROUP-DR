function [y_d,dy_d,ddy_d] = DesignedTrajectoryFunc_PendulumWithMovingJoint(t)
T1_alpha = 1;
T2_alpha = 8;
lambda_alpha = 5;
T1_beta = 1;
T2_beta = 8;
lambda_beta = 5;
[alpha,dalphadt,ddalphadtdt] = SwayAngleFunction_Trigonometric(t,T1_alpha,T2_alpha,lambda_alpha);
[beta, dbetadt, ddbetadtdt]  = SwayAngleFunction_Trigonometric(t,T1_beta, T2_beta, lambda_beta);

y_d = [alpha;beta];
dy_d = [dalphadt;dbetadt];
ddy_d = [ddalphadtdt;ddbetadtdt];
end
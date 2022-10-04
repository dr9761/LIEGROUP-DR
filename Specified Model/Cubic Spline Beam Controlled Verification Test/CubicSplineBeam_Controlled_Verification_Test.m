% CubicSplineBeam_Controlled_Verification_Test
clear;close all;
for SegmentQuantity = 1:5
%% BodyParameter
L = 8/SegmentQuantity;
E = 6.8952e10;
v = 0.25;
g = 0*[0;0;-9.8];
rho = 2.7667e3;
%
G  = E / (2*(1+v));
A  = 7.2968e-5;
Iy = 8.2189e-9;
Iz = 8.2189e-9;

BodyParameter.L  = L;
BodyParameter.E  = E;
BodyParameter.G  = G;
BodyParameter.A  = A;
BodyParameter.Iy = Iy;
BodyParameter.Iz = Iz;
BodyParameter.rho = rho;
%% qe dqe
r1   = [0;0;0];dr1dt  = [0;0;0];
phi1 = [0;0;0];omega1 = [0;0;0];
norm_dr1dx = 1;norm_ddr1dxdt = 0;

q1 = [r1;phi1;norm_dr1dx];dq1 = [dr1dt;omega1;norm_ddr1dxdt];
qe = [q1];dqe = [dq1];
%
for SegmentNr = 1:SegmentQuantity
r2   = [SegmentNr*L;0;0];dr2dt  = [0;0;0];
phi2 = [0;0;0];omega2 = [0;0;0];
norm_dr2dx = 1;norm_ddr2dxdt = 0;

q2 = [r2;phi2;norm_dr2dx];dq2 = [dr2dt;omega2;norm_ddr2dxdt];
qe = [qe;q2];dqe = [dqe;dq2];
end

%%
% Forward
% DrivedData = ...
% 	load('Specified Model\Cubic Spline Beam Controlled Verification Test\DriveData.mat', ...
% 	'Tau');
% PID
DrivedData = ...
	load('Specified Model\Cubic Spline Beam Controlled Verification Test\DriveData2.mat', ...
	'Tau');
DrivedData = DrivedData.Tau;
%%
PlotFigureObj = figure(1);
PlotFigureObj = axes(PlotFigureObj);
x0 = [qe;dqe];
opt=odeset('RelTol',0.001,'AbsTol',0.001,'MaxStep',0.1);
tspan = [0 90];
tic;
[t_set,x_set]=ode23tb(...
	@(t,x)CubicSpline_Controlled_Verification_ode_Test_func(...
	t,x,g,BodyParameter,DrivedData,PlotFigureObj), ...
	tspan,x0,opt);
SolvingTime = toc;
save('CubicSplineBeam_Controlled_Verification_Test_Segment', ...
	num2str(SegmentQuantity),'.mat');
end
%%
function dx = CubicSpline_Controlled_Verification_ode_Test_func(...
	t,x,g,BodyParameter,DrivedData,PlotFigureObj)
q = x(1:numel(x)/2);
dq = x(numel(x)/2+1:end);
Mass = zeros(numel(q));
Force = zeros(numel(q),1);
SegmentQuantity = numel(q)/7-1;
for SegmentNr = 1:SegmentQuantity
	qe = q(7*(SegmentNr-1)+[1:14]);
	dqe = dq(7*(SegmentNr-1)+[1:14]);
	Te = zeros(14,numel(q));
	Te(:,7*(SegmentNr-1)+[1:14]) = eye(14);
	
	[BodyMass,BodyForce] = CubicSpline_MassForce(...
		qe,dqe,g,BodyParameter);
	
	Mass = Mass + Te'*BodyMass*Te;
	Force = Force + Te'*BodyForce;
end
%%
Mass(1:3,:) = 0;
Mass(1:3,1:3) = eye(3);
Force(1:3) = 0;
%
DriveDataTimeSet = DrivedData.Time;
DriveDataValueSet = DrivedData.Data;
if t == 90
	DriveDataValue = DriveDataValueSet(end);
else
DriveDataTimeMin = find(DriveDataTimeSet<=t);
DriveDataTimeMin = DriveDataTimeMin(end);
DriveDataTimeMax = find(DriveDataTimeSet>t);
DriveDataTimeMax = DriveDataTimeMax(1);

DriveTimeMin = DriveDataTimeSet(DriveDataTimeMin);
DriveTimeMax = DriveDataTimeSet(DriveDataTimeMax);

DriveDataValueMin = DriveDataValueSet(DriveDataTimeMin);
DriveDataValueMax = DriveDataValueSet(DriveDataTimeMax);

DriveDataValue = (DriveDataValueMax-DriveDataValueMin) * ...
	(t-DriveTimeMin) / (DriveTimeMax-DriveTimeMin) + DriveDataValueMin;
end
Force(5) = Force(5) + DriveDataValue;
%
ddqe = -Mass\Force;
%%
dqedt = dq;
dqedt(4:6) = get_T(q(4:6)) \ dq(4:6);
dqedt(11:13) = get_T(q(11:13)) \ dq(11:13);

dx = [dqedt;ddqe];
%%
fprintf('t = %d\n',t);
% plot_CubicSplineBeam(q,20,BodyParameter, ...
% 	'r.-',PlotFigureObj)
% axis([-10,10,-10,10,-10,10]);
% view(0,0);%x-z
% drawnow;
end


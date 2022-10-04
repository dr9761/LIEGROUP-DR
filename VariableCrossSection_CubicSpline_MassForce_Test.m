% VariableCrossSection_CubicSpline_MassForce_Test
clear;close all;
for SegmentQuantity = 1:10
% SegmentQuantity = 10;
%% BodyParameter
ra  = 0.15;
ri  = 0;
L = 15;
E = 2.06e11;
v = 0.25;
g = [0;0;-9.8];
rho = 7800;
%
G  = E / (2*(1+v));
A  = pi*(ra^2-ri^2);
Iy = pi*(2*ra)^4*(1-((ri/ra)^4))/64;
Iz = pi*(2*ra)^4*(1-((ri/ra)^4))/64;

BodyParameter.L  = L/SegmentQuantity;
BodyParameter.E  = E;
BodyParameter.G  = G;
BodyParameter.A  = A;
BodyParameter.Iy = Iy;
BodyParameter.Iz = Iz;
BodyParameter.rho = rho;

for SegmentNr = 1:SegmentQuantity
BodyElementParameter{SegmentNr} = BodyParameter;
BodyElementParameter{SegmentNr}.ra_func = ...
	@(x)VariableCrossSection_ParameterFunc(...
	x+(SegmentNr-1)*L/SegmentQuantity);
end
%% qe dqe
% r1   = [0;0;0];dr1dt  = [0;0;0];
% phi1 = [0;0;0];omega1 = [0;0;0];
% norm_dr1dx = 1;norm_ddr1dxdt = 0;
% r2   = [L;0;0];dr2dt  = [0;0;0];
% phi2 = [0.1;0.1;0];omega2 = [0;0;0];
% norm_dr2dx = 1;norm_ddr2dxdt = 0;

r1   = [0;0;0];dr1dt  = [0;0;0];
phi1 = [0;0;0];omega1 = [0;0;0];
norm_dr1dx = 1;norm_ddr1dxdt = 0;
q1 = [r1;phi1;norm_dr1dx];dq1 = [dr1dt;omega1;norm_ddr1dxdt];
qe = q1;dqe = dq1;
for SegmentNr = 1:SegmentQuantity
	
r2   = [SegmentNr*L/SegmentQuantity;0;0];dr2dt  = [0;0;0];
phi2 = [0;0;0];omega2 = [0;0;0];
norm_dr2dx = 1;norm_ddr2dxdt = 0;
q2 = [r2;phi2;norm_dr2dx];dq2 = [dr2dt;omega2;norm_ddr2dxdt];
qe = [qe;q2];dqe = [dqe;dq2];
end
% r3   = [L;0;0];dr3dt  = [0;0;0];
% phi3 = [0;0;0];omega3 = [0;0;0];
% norm_dr3dx = 1;norm_ddr3dxdt = 0;
% 
% q1 = [r1;phi1;norm_dr1dx];dq1 = [dr1dt;omega1;norm_ddr1dxdt];
% 
% q3 = [r3;phi3;norm_dr3dx];dq3 = [dr3dt;omega3;norm_ddr3dxdt];
% qe = [q1;q2;q3];dqe = [dq1;dq2;dq3];
%%
% hold on;
% [Mass,Force] = CubicSpline_MassForce(...
% 	qe,dqe,g,BodyParameter);
% plot_CubicSplineBeam(qe,20,BodyParameter,'r-')
% hold off;
%%
PlotFigureObj = figure(1);
PlotFigureObj = axes(PlotFigureObj);
x0 = [qe;dqe];
opt=odeset('RelTol',0.01,'AbsTol',0.01,'MaxStep',1);
tspan = [0 5];
tic;
[t_set,x_set]=ode23tb(...
	@(t,x)VariableCrossSection_CubicSpline_ode_Test_func(...
	t,x,g,BodyElementParameter,PlotFigureObj), ...
	tspan,x0,opt);
SolvingTime = toc;
%%
% qe([7,14]) = [];
% dqe([7,14]) = [];
% xi = 1;
% [qc,dqc,Tc,dTcdt] = ...
% 	get_InternalNode_Coordination_CubicSplineBeam(...
% 	qe,dqe,xi,BodyParameter);
%%
% close all;
% plot(t_set,x_set(:,7*SegmentQuantity+[3,numel(qe)+3])-x_set(1,7*SegmentQuantity+[3,numel(qe)+3]));
save(['VariableCrossSection_CubicSpline_',num2str(SegmentQuantity),'.mat']);
end
%%
function dx = VariableCrossSection_CubicSpline_ode_Test_func(...
	t,x,g,BodyElementParameter,PlotFigureObj)
q = x(1:numel(x)/2);
dq = x(numel(x)/2+1:end);
Mass = zeros(numel(q));
Force = zeros(numel(q),1);
% qe(5) = -pi/2 * 1/2*(1-cos(t*2*pi/10));
% dqe(5) = -pi^2/20 * sin(t*2*pi/10);
SegmentQuantity = numel(q)/7-1;
for SegmentNr = 1:SegmentQuantity
	BodyParameter = BodyElementParameter{SegmentNr};
	qe = q(7*(SegmentNr-1)+[1:14]);
	dqe = dq(7*(SegmentNr-1)+[1:14]);
	Te = zeros(14,numel(q));
	Te(:,7*(SegmentNr-1)+[1:14]) = eye(14);
	
	[BodyMass,BodyForce] = VariableCrossSection_CubicSpline_MassForce(...
		qe,dqe,g,BodyParameter);
	
	Mass = Mass + Te'*BodyMass*Te;
	Force = Force + Te'*BodyForce;
end
%%
Mass(1:6,:) = 0;
Mass(1:6,1:6) = eye(6);
Force(1:6) = 0;
%
% Mass(1:3,:) = 0;
% Mass(1:3,1:3) = eye(3);
% Force(1:3) = 0;
%
ddq = -Mass\Force;
%%
dqdt = dq;
for SegmentNr = 0:SegmentQuantity
	dqdt(7*SegmentNr+[4:6]) = ...
		get_T(q(7*SegmentNr+[4:6])) \ dq(7*SegmentNr+[4:6]);
end

dx = [dqdt;ddq];
%%
fprintf('t = %d\n',t);
% hold off;
% for SegmentNr = 1:SegmentQuantity
% 	BodyParameter = BodyElementParameter{SegmentNr};
% 	qe = q(7*(SegmentNr-1)+[1:14]);
% 	if mod(SegmentNr,2) == 00
% 		plot_CubicSplineBeam(qe,5,BodyParameter, ...
% 			'r.-',PlotFigureObj);
% 	else
% 		plot_CubicSplineBeam(qe,5,BodyParameter, ...
% 			'b.-',PlotFigureObj);
% 	end
% 	hold on;
% end
% 
% axis([0,20,-10,10,-1,1]);
% view(0,0);%x-z
% drawnow;
end

function ra = VariableCrossSection_ParameterFunc(x)

ra = 0.15-floor(x/3)*0.03;

end

function plot_CubicSplineBeam(qe,InterpolationNr,BodyParameter, ...
	PlotStyle,FigureObj)
L = BodyParameter.L;
%%
q1 = qe(1:numel(qe)/2);
q2 = qe(numel(qe)/2+1:end);
%
r01        = q1(1:3);
phi1       = q1(4:6);
norm_dr1dx = q1(7);
r02        = q2(1:3);
phi2       = q2(4:6);
norm_dr2dx = q2(7);
%
R1 = get_R(phi1);
R2 = get_R(phi2);
gx = [1;0;0];
nx1 = R1 * gx;
nx2 = R2 * gx;
dr1dx = nx1 * norm_dr1dx;
dr2dx = nx2 * norm_dr2dx;
%%
r_set = zeros(3,InterpolationNr+1);
for NodeNr = 1:(InterpolationNr+1)
	xi = (NodeNr-1)/InterpolationNr;

	[N_1_0,N_1_1,N_2_0,N_2_1] = ...
		Hermite_Interpolation_Coefficient_N(xi*L,L);
	N = [N_1_0*eye(3),N_1_1*eye(3),N_2_0*eye(3),N_2_1*eye(3)];
	r = N * [r01;dr1dx;r02;dr2dx];
	
	r_set(:,NodeNr) = r;
end
%%
x = r_set(1,:);
y = r_set(2,:);
z = r_set(3,:);
%%
plot3(FigureObj,x,y,z,PlotStyle);
end
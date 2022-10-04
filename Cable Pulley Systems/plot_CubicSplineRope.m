function plot_CubicSplineRope(qe,InterpolationNr,BodyParameter, ...
	PlotStyle,FigureObj)
L = BodyParameter.L;
%%
q1 = qe(1:numel(qe)/2);
q2 = qe(numel(qe)/2+1:end);
%
r01   = q1(1:3);
dr1dx = q1(4:6);
r02   = q2(1:3);
dr2dx = q2(4:6);
%%
r_set = zeros(3,InterpolationNr+1);
for NodeNr = 1:(InterpolationNr+1)
	xi = (NodeNr-1)/InterpolationNr;
	%%
	[N_1_0,N_1_1,N_2_0,N_2_1] = ...
		Hermite_Interpolation_Coefficient_N(xi*L,L);
	
	N = [N_1_0*eye(3),N_1_1*eye(3),N_2_0*eye(3),N_2_1*eye(3)];
	%%
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
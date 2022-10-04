function plot_FreeCable(qe,InterpolationNr,BodyParameter,PlotStyle)
%%
FreeCableParameter = BodyParameter.FreeCableParameter;
L  = FreeCableParameter.L;
%%
x_set = 0:L/InterpolationNr:L;
r_set = zeros(3,InterpolationNr+1);
%%
for i = 1:InterpolationNr+1
	x = x_set(i);
	[N_1_0,N_1_1,N_2_0,N_2_1] = ...
		Hermite_Interpolation_Coefficient_N(x,L);	
	N = [N_1_0*eye(3),N_1_1*eye(3),N_2_0*eye(3),N_2_1*eye(3)];
	r = N * qe;
	r_set(:,i) = r;
end
%%
x = r_set(1,:);
y = r_set(2,:);
z = r_set(3,:);
%%
plot3(x,y,z,PlotStyle);
end
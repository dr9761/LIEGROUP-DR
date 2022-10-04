function [Mass,Force] = FreeCable_MassForce(qe,dqe,g,BodyParameter)
%%
L  = BodyParameter.L;
A  = BodyParameter.A;
E  = BodyParameter.E;
rho = BodyParameter.rho;
%
Stiffness = E*A;
%%
q1 = qe(1:numel(qe)/2);
q2 = qe(numel(qe)/2+1:end);

r01   = q1(1:3);
dr1dx = q1(4:6);
r02   = q2(1:3);
dr2dx = q2(4:6);
%%
Mtra = zeros(numel(qe));

Fint = zeros(numel(qe),1);
Fextg = zeros(numel(qe),1);
%%
gaussn = 5;
x_set = gaussx(0,L,gaussn);
w_set = gaussw(gaussn);

for i = 1:gaussn
	x = x_set(i);
	w = w_set(i);
	%%
	[N_1_0,N_1_1,N_2_0,N_2_1] = ...
		Hermite_Interpolation_Coefficient_N(x,L);
	[dN_1_0,dN_1_1,dN_2_0,dN_2_1] = ...
		Hermite_Interpolation_Coefficient_dN(x,L);
	
	N = [N_1_0*eye(3),N_1_1*eye(3),N_2_0*eye(3),N_2_1*eye(3)];
	dN = [dN_1_0*eye(3),dN_1_1*eye(3),dN_2_0*eye(3),dN_2_1*eye(3)];
	%%
	drdx = dN * [r01;dr1dx;r02;dr2dx];
	%%
	epsilon = norm(drdx) - 1;
	% only axial stress be considered
% 	if epsilon < 0
% 		epsilon = 0;
% 	end
	Tepsilon = 1/norm(drdx)*drdx'*dN;
	
	Strain = epsilon;
	Stress = Stiffness * Strain;
	TStrain = Tepsilon;
	
	Fint = Fint + TStrain' * Stress * w;
	%% 
	Mtra = Mtra + rho*A*N'*N*w;
	%%
	Fextg = Fextg - rho*A*N'*g*w;
end
%%
% only translation inertial power be considered
Mass = Mtra;
Force = Fextg + Fint;
% Force = Fextg;
end
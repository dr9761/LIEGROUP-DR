function M_B_end = get_TimoshenkoBeam_Simplified_Mass(RB)
%%
M_B_end = zeros(18);
%%
gx = [1;0;0];
J
A
L
%%
M_B_end_Part1 = zeros(6);
M_B_end_Part1 = ...
	[A*L*eye(3),			-A*L^2/2*RB*skew(gx);
	A*L^2/2*skew(gx)*RB',	-A*L^3/3*skew(gx)*skew(gx)+J*L];
%%
M_B_end_Part2 = zeros(6,12);
M_B_end_Part2 = [A*RB,zeros(6);zeros(6),J]*sN


end
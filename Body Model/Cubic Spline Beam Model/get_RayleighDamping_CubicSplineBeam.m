function RayleighDamping = ...
	get_RayleighDamping_CubicSplineBeam(...
	qe,Mass,BodyParameter)
%%
CubicSplineBeam_TangentStiffness_Func = ...
	BodyParameter.CubicSplineBeam_TangentStiffness_Func;
TangentStiffness = CubicSplineBeam_TangentStiffness_Func(...
	'qe',qe);
TangentStiffness = full(TangentStiffness.TangentStiffness);
%%
I = (Iy + Iz) / 2;
omega1 = 1.875104^2*sqrt(E*I/(rho*A*L^4));
omega2 = 4.694091^2*sqrt(E*I/(rho*A*L^4));
xi1 = 1;
xi2 = 1;
alpha = 2*omega1*omega2*(omega2*xi1-omega1*xi2)/ ...
	(omega2^2-omega1^2);
beta = 2*(omega2*xi2-omega1*xi1) / ...
	(omega2^2-omega1^2);
%%
RayleighDamping = alpha*Mass + beta*TangentStiffness;
end
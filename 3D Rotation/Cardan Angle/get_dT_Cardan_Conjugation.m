function dT_Cardan_Conjugation = get_dT_Cardan_Conjugation(Angle,dAngle)
%%
phi   = Angle(1);
psi   = Angle(2);
theta = Angle(3);
%%
dphi   = dAngle(1);
dpsi   = dAngle(2);
dtheta = dAngle(3);
%%
dT_Cardan_Conjugation = [...
	0,											-cos(psi)*dtheta,			0;
	-sin(phi)*dpsi+cos(phi)*cos(psi)*dtheta,	-sin(phi)*sin(psi)*dtheta,	0;
	-cos(phi)*dpsi-sin(phi)*cos(psi)*dtheta,	-cos(phi)*sin(psi)*dtheta,	0];

end
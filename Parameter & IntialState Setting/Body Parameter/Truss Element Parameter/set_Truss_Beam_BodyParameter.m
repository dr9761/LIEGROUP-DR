function Body_Parameter = set_Truss_Beam_BodyParameter(...
	L,Beamstyle,BodyParameterTableRaw,BodyNr)
%%
MainBeam = 1;
CrossSection = 2;
SubBeam = 3;
%%
SectionType = BodyParameterTableRaw{4,BodyNr+3};
switch SectionType
	case 'Round Tube'
		ra_set = str2num(BodyParameterTableRaw{10,BodyNr+3});
		ri_set = str2num(BodyParameterTableRaw{11,BodyNr+3});
		switch Beamstyle
			case 'MainBeam'
				ra = ra_set(MainBeam);
				ri = ri_set(MainBeam);
			case 'CrossSection'
				ra = ra_set(CrossSection);
				ri = ri_set(CrossSection);
			case 'SubBeam'
				ra = ra_set(SubBeam);
				ri = ri_set(SubBeam);
		end
		%%
		A  = pi*(ra^2-ri^2);
		Iy = pi*(2*ra)^4*(1-((ri/ra)^4))/64;
		Iz = pi*(2*ra)^4*(1-((ri/ra)^4))/64;
		%%
		Body_Parameter.ra = ra;
		Body_Parameter.ri = ri;
	case 'User defined'
		%%
end
%%
rho = BodyParameterTableRaw{6,BodyNr+3};
E   = BodyParameterTableRaw{7,BodyNr+3};
v   = BodyParameterTableRaw{8,BodyNr+3};
G    = E / (2*(1+v));
%% Adjustment
E = E/1;
G = G/1;
% rho = rho/1000;
%%
Stiffness = diag([E*A,G*A/4,G*A/4,G*(Iy+Iz)/4,E*Iz,E*Iy]);
%%
Body_Parameter.L  = L;
Body_Parameter.E  = E;
Body_Parameter.G  = G;
Body_Parameter.A  = A;
Body_Parameter.Iy = Iy;
Body_Parameter.Iz = Iz;
Body_Parameter.Stiffness = Stiffness;
Body_Parameter.rho = rho;
end
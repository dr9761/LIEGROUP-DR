function [BodyElementParameter,TotalCoordinateNr] = set_BodyParameter(...
	BodyParameterTableRaw,BodyNr,TotalCoordinateNr,BodyElementParameter)
%%
BodyType    = BodyParameterTableRaw{3,BodyNr+3};
DoF         = BodyParameterTableRaw{5,BodyNr+3};
%%
if strcmp(BodyType,'Super Truss Element')
	SectionType = BodyParameterTableRaw{4,BodyNr+3};
	%
	Truss_Parameter = set_Truss_Parameter(...
		BodyParameterTableRaw,BodyNr);
	%%
	BodyElementParameter{BodyNr}.SectionType = SectionType;
	BodyElementParameter{BodyNr}.Truss_Parameter = ...
		Truss_Parameter;
	BodyElementParameter{BodyNr}.ra = [];
else
	%%
	SectionType = BodyParameterTableRaw{4,BodyNr+3};
	switch SectionType
		case 'Custom defined'
			m = BodyParameterTableRaw{18,BodyNr+3};
			theta_B_0 = str2num(BodyParameterTableRaw{19,BodyNr+3});
			r_B_0C = str2num(BodyParameterTableRaw{20,BodyNr+3});
			%%
			BodyElementParameter{BodyNr}.SectionType = SectionType;
			BodyElementParameter{BodyNr}.ra = 0;
			BodyElementParameter{BodyNr}.m = m;
			BodyElementParameter{BodyNr}.r_B_0C = r_B_0C;
			BodyElementParameter{BodyNr}.theta_B_0 = theta_B_0;
			
		case 'Round Tube'
			%%
			rho = BodyParameterTableRaw{6,BodyNr+3};
			E   = BodyParameterTableRaw{7,BodyNr+3};
			v   = BodyParameterTableRaw{8,BodyNr+3};
			L   = BodyParameterTableRaw{9,BodyNr+3};
			%% cross section parameter
			ra  = BodyParameterTableRaw{10,BodyNr+3};
			ri  = BodyParameterTableRaw{11,BodyNr+3};
			%%
			A  = pi*(ra^2-ri^2);
			Iy = pi*(2*ra)^4*(1-((ri/ra)^4))/64;
			Iz = pi*(2*ra)^4*(1-((ri/ra)^4))/64;
			m = A * L * rho;
			theta_B_0 = ...
				[1/2*m*(ra^2-ri^2),		0,					0;
				0,						1/3*m*L^2,			0;
				0,						0,					1/3*m*L^2];
			r_B_0C = [L/2;0;0];
			%%
			G  = E / (2*(1+v));
			Stiffness = diag([E*A,G*A/4,G*A/4,G*(Iy+Iz)/4,E*Iz,E*Iy]);
			%%
			BodyElementParameter{BodyNr}.SectionType = SectionType;
			BodyElementParameter{BodyNr}.rho = rho;
			BodyElementParameter{BodyNr}.E = E;
			BodyElementParameter{BodyNr}.G = G;
			BodyElementParameter{BodyNr}.v = v;
			BodyElementParameter{BodyNr}.Stiffness = Stiffness;
			BodyElementParameter{BodyNr}.L = L;
			BodyElementParameter{BodyNr}.ra = ra;
			BodyElementParameter{BodyNr}.ri = ri;
			BodyElementParameter{BodyNr}.A = A;
			BodyElementParameter{BodyNr}.Iy = Iy;
			BodyElementParameter{BodyNr}.Iz = Iz;
			BodyElementParameter{BodyNr}.m = m;
			BodyElementParameter{BodyNr}.r_B_0C = r_B_0C;
			BodyElementParameter{BodyNr}.theta_B_0 = theta_B_0;
		case 'Frame'
			
	end
end
%%
BodyElementParameter{BodyNr}.BodyType = BodyType;
switch BodyType
	case 'Rigid Body'
		DoF = 6;
		
		Coordinate.r = TotalCoordinateNr + [1:3];
		Coordinate.phi = TotalCoordinateNr + [4:6];
		
		CoordinateBase.r = [];
		CoordinateBase.phi = [];
		
		GlobalCoordinate = [Coordinate.r,Coordinate.phi];
		
		TotalCoordinateNr = TotalCoordinateNr + DoF;
	case 'Timoshenko Beam'
		DoF = 12;
		
		Coordinate.r1 = TotalCoordinateNr + [1:3];
		Coordinate.phi1 = TotalCoordinateNr + [4:6];
		Coordinate.r2 = TotalCoordinateNr + [7:9];
		Coordinate.phi2 = TotalCoordinateNr + [10:12];
		
		CoordinateBase.r1 = [];
		CoordinateBase.phi1 = [];
		CoordinateBase.r2 = [];
		CoordinateBase.phi2 = [];
		
		GlobalCoordinate = [...
			Coordinate.r1,Coordinate.phi1, ...
			Coordinate.r2,Coordinate.phi2];
		
		TotalCoordinateNr = TotalCoordinateNr + DoF;
	case 'Super Truss Element'
		DoF = 12;
		
		Coordinate.r1 = TotalCoordinateNr + [1:3];
		Coordinate.phi1 = TotalCoordinateNr + [4:6];
		Coordinate.r2 = TotalCoordinateNr + [7:9];
		Coordinate.phi2 = TotalCoordinateNr + [10:12];
		
		CoordinateBase.r1 = [];
		CoordinateBase.phi1 = [];
		CoordinateBase.r2 = [];
		CoordinateBase.phi2 = [];
		
		GlobalCoordinate = [...
			Coordinate.r1,Coordinate.phi1, ...
			Coordinate.r2,Coordinate.phi2];
		
		TotalCoordinateNr = TotalCoordinateNr + DoF;
	case 'Strut Tie Model'
		DoF = 6;
		
		Coordinate.r1 = TotalCoordinateNr + [1:3];
		Coordinate.r2 = TotalCoordinateNr + [4:6];
		
		CoordinateBase.r1 = [];
		CoordinateBase.r2 = [];
		
		GlobalCoordinate = [Coordinate.r1,Coordinate.r2];
		
		TotalCoordinateNr = TotalCoordinateNr + DoF;
	case 'Strut Tie Rope Model'
		DoF = 6;
		
		Coordinate.r1 = TotalCoordinateNr + [1:3];
		Coordinate.r2 = TotalCoordinateNr + [4:6];
		
		CoordinateBase.r1 = [];
		CoordinateBase.r2 = [];
		
		GlobalCoordinate = [Coordinate.r1,Coordinate.r2];
		
		TotalCoordinateNr = TotalCoordinateNr + DoF;
	case 'Cubic Spline Beam'
		DoF = 14;
		
		Coordinate.r1 = TotalCoordinateNr + [1:3];
		Coordinate.phi1 = TotalCoordinateNr + [4:6];
		Coordinate.norm_drdx1 = TotalCoordinateNr + 7;
		Coordinate.r2 = TotalCoordinateNr + [8:10];
		Coordinate.phi2 = TotalCoordinateNr + [11:13];
		Coordinate.norm_drdx2 = TotalCoordinateNr + 14;
		
		CoordinateBase.r1 = [];
		CoordinateBase.phi1 = [];
		CoordinateBase.norm_drdx1 = [];
		CoordinateBase.r2 = [];
		CoordinateBase.phi2 = [];
		CoordinateBase.norm_drdx2 = [];
		
		GlobalCoordinate = [...
			Coordinate.r1,Coordinate.phi1,Coordinate.norm_drdx1, ...
			Coordinate.r2,Coordinate.phi2,Coordinate.norm_drdx2];
		
		TotalCoordinateNr = TotalCoordinateNr + DoF;
	case 'Cubic Spline Rope'
		DoF = 14;
		
		Coordinate.r1 = TotalCoordinateNr + [1:3];
		Coordinate.phi1 = TotalCoordinateNr + [4:6];
		Coordinate.norm_drdx1 = TotalCoordinateNr + 7;
		Coordinate.r2 = TotalCoordinateNr + [8:10];
		Coordinate.phi2 = TotalCoordinateNr + [11:13];
		Coordinate.norm_drdx2 = TotalCoordinateNr + 14;
		
		CoordinateBase.r1 = [];
		CoordinateBase.phi1 = [];
		CoordinateBase.norm_drdx1 = [];
		CoordinateBase.r2 = [];
		CoordinateBase.phi2 = [];
		CoordinateBase.norm_drdx2 = [];
		
		GlobalCoordinate = [...
			Coordinate.r1,Coordinate.phi1,Coordinate.norm_drdx1, ...
			Coordinate.r2,Coordinate.phi2,Coordinate.norm_drdx2];
		
		TotalCoordinateNr = TotalCoordinateNr + DoF;
	otherwise
	
end
BodyElementParameter{BodyNr}.Coordinate = Coordinate;
BodyElementParameter{BodyNr}.CoordinateBase = CoordinateBase;
BodyElementParameter{BodyNr}.GlobalCoordinate = GlobalCoordinate;
%%
% [BodyElementParameter,TotalCoordinateNr] = ...
% 	set_BodyParameter_Coordinate(...
% 	BodyType,TotalCoordinateNr,BodyElementParameter);

end
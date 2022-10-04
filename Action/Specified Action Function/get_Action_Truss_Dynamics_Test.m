function [Action,ActionTagSet] = get_Action_Truss_Dynamics_Test(...
	t,x,tspan,ModelParameter,TestType)
BodyElementParameter = ModelParameter.BodyElementParameter;
Truss_Parameter = BodyElementParameter{1}.Truss_Parameter;
MainBeamParameter = Truss_Parameter.MainBeamParameter;
MainBeamBodyParameter = MainBeamParameter.BodyParameter{1};

Action = [0;0;0;0;0;0];
ActionTagSet = {...
	'Force_x';'Force_y';'Force_z'; ...
	'Moment_x';'Moment_y';'Moment_z'};
if isempty(TestType)
	return;
end
switch TestType
	case 'Translation_x'
		L = Truss_Parameter.TrussLength;
		A = MainBeamBodyParameter.A;
		rho = MainBeamBodyParameter.rho;
		
		Action(1) = 4*rho*A*L;
	case 'Translation_y'
		L = Truss_Parameter.TrussLength;
		A = MainBeamBodyParameter.A;
		rho = MainBeamBodyParameter.rho;
		
		Action(2) = 4*rho*A*L;
	case 'Translation_z'
		L = Truss_Parameter.TrussLength;
		A = MainBeamBodyParameter.A;
		rho = MainBeamBodyParameter.rho;
		
		Action(3) = 4*rho*A*L;
	case 'Rotation_x'
		rho = MainBeamBodyParameter.rho;
		A  = MainBeamBodyParameter.A;
		Iy = MainBeamBodyParameter.Iy;
		Iz = MainBeamBodyParameter.Iz;
		CrossSection = ...
			Truss_Parameter.CrossSectionParameter.CrossSection{2};
		y = CrossSection.Point{1}(2);
		z = CrossSection.Point{1}(3);
		L = Truss_Parameter.TrussLength;
		
		Iyz = 4*(Iy + Iz + (y^2+z^2)*A);
		Action(4) = rho*Iyz*L;
		if Action(4) == 0
			CrossSection = ...
				Truss_Parameter.CrossSectionParameter.CrossSection{1};
			y = CrossSection.Point{1}(2);
			z = CrossSection.Point{1}(3);
			L = Truss_Parameter.TrussLength;
			
			Iyz = 4*(Iy + Iz + (y^2+z^2)*A);
			Action(4) = rho*Iyz*L;
		end
	case 'Rotation_y'
		rho = MainBeamBodyParameter.rho;
		A  = MainBeamBodyParameter.A;
		Iy = MainBeamBodyParameter.Iy;
		CrossSection = ...
			Truss_Parameter.CrossSectionParameter.CrossSection{2};
		y = CrossSection.Point{1}(2);
		L = Truss_Parameter.TrussLength;
		
		Iy = 4*(Iy + y^2*A);
		Action(5) = rho*Iy*L;
		if Action(5) == 0
			CrossSection = ...
				Truss_Parameter.CrossSectionParameter.CrossSection{1};
			y = CrossSection.Point{1}(2);
			L = Truss_Parameter.TrussLength;
			
			Iy = 4*(Iy + y^2*A);
			Action(5) = rho*Iy*L;
		end
	case 'Rotation_z'
		rho = MainBeamBodyParameter.rho;
		A  = MainBeamBodyParameter.A;
		Iz = MainBeamBodyParameter.Iz;
		CrossSection = ...
			Truss_Parameter.CrossSectionParameter.CrossSection{2};
		z = CrossSection.Point{1}(3);
		L = Truss_Parameter.TrussLength;
		
		Iz = 4*(Iz + z^2*A);
		Action(6) = rho*Iz*L;
		if Action(6) == 0
			CrossSection = ...
				Truss_Parameter.CrossSectionParameter.CrossSection{1};
			z = CrossSection.Point{1}(3);
			L = Truss_Parameter.TrussLength;
			
			Iz = 4*(Iz + z^2*A);
			Action(6) = rho*Iz*L;
		end
end
end
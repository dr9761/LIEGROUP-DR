function [Action,ActionTagSet] = get_Action_Truss_Statics_Test(...
	t,x,tspan,ModelParameter,TestType)
BodyElementParameter = ModelParameter.BodyElementParameter;
Truss_Parameter = BodyElementParameter{1}.Truss_Parameter;
MainBeamParameter = Truss_Parameter.MainBeamParameter;
MainBeamBodyParameter = MainBeamParameter.BodyParameter{1};

Action = [0;0;0;0];
ActionTagSet = ...
	{'Normal_Force';'Torsion';'Moment_y';'Moment_z'};
if isempty(TestType)
	return;
end
switch TestType
	case 'Axial Stretch'
		E = MainBeamBodyParameter.E;
		A = MainBeamBodyParameter.A;
		epsilon_max = 0.2;
		Fn_max = 4*E*A*epsilon_max;
		Action(1) = Fn_max/100*t;
	case 'Axial Compression'
		E = MainBeamBodyParameter.E;
		A = MainBeamBodyParameter.A;
		epsilon_max = 0.2;
		Fn_max = 4*E*A*epsilon_max;
		Action(1) = -Fn_max/100*t;
	case 'x-Axis Twist'
		E  = MainBeamBodyParameter.E;
		A  = MainBeamBodyParameter.A;
		Iy = MainBeamBodyParameter.Iy;
		Iz = MainBeamBodyParameter.Iz;
		CrossSection = ...
			Truss_Parameter.CrossSectionParameter.CrossSection{2};
		y = CrossSection.Point{1}(2);
		z = CrossSection.Point{1}(3);
		L = Truss_Parameter.TrussLength;
		
		Iyz = 4*(Iy + Iz + (y^2+z^2)*A);
		M_max = -E*Iyz*1/(L/(2*pi))*0.05;
		Action(2) = -M_max/100*t;
		if Action(2) == 0
			CrossSection = ...
				Truss_Parameter.CrossSectionParameter.CrossSection{1};
			y = CrossSection.Point{1}(2);
			z = CrossSection.Point{1}(3);
			L = Truss_Parameter.TrussLength;
			
			Iyz = 4*(Iy + Iz + (y^2+z^2)*A);
			M_max = -E*Iyz*1/(L/(2*pi))*0.05;
			Action(2) = -M_max/100*t;
		end
	case 'y-Axis Bending'
		E  = MainBeamBodyParameter.E;
		A  = MainBeamBodyParameter.A;
		Iy = MainBeamBodyParameter.Iy;
		CrossSection = ...
			Truss_Parameter.CrossSectionParameter.CrossSection{2};
		y = CrossSection.Point{1}(2);
		L = Truss_Parameter.TrussLength;
		
		Iy = 4*(Iy + y^2*A);
		M_max = -E*Iy*1/(L/(2*pi))*0.05;
		Action(3) = -M_max/100*t;
		if Action(3) == 0
			CrossSection = ...
				Truss_Parameter.CrossSectionParameter.CrossSection{1};
			y = CrossSection.Point{1}(2);
			L = Truss_Parameter.TrussLength;
			
			Iy = 4*(Iy + y^2*A);
			M_max = -E*Iy*1/(L/(2*pi))*0.05;
			Action(3) = -M_max/100*t;
		end
	case 'z-Axis Bending'
		E  = MainBeamBodyParameter.E;
		A  = MainBeamBodyParameter.A;
		Iz = MainBeamBodyParameter.Iz;
		CrossSection = ...
			Truss_Parameter.CrossSectionParameter.CrossSection{2};
		z = CrossSection.Point{1}(3);
		L = Truss_Parameter.TrussLength;
		
		Iz = 4*(Iz + z^2*A);
		M_max = -E*Iz*1/(L/(2*pi))*0.05;
		Action(4) = -M_max/100*t;
		if Action(4) == 0
			CrossSection = ...
				Truss_Parameter.CrossSectionParameter.CrossSection{1};
			z = CrossSection.Point{1}(3);
			L = Truss_Parameter.TrussLength;
			
			Iz = 4*(Iz + z^2*A);
			M_max = -E*Iz*1/(L/(2*pi))*0.05;
			Action(4) = -M_max/100*t;
		end
end
end
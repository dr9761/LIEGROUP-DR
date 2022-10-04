function [MainBeamParameter,PlaneParameter] = set_Truss_Plane_Parameter(...
	CrossSectionParameter,MainBeamParameter)
%% Plane Quantity
MainBeamQuantity = numel(MainBeamParameter.Beam);
PlaneQuantity = MainBeamQuantity;
for PlaneNr = 1:PlaneQuantity
	MainBeamNr1 = mod(PlaneNr-1,MainBeamQuantity)+1;
	MainBeamNr2 = mod(PlaneNr  ,MainBeamQuantity)+1;
	PlaneParameter.Plane{PlaneNr} = ...
		[MainBeamNr1,MainBeamNr2];
	%%
	MainBeam_1_UnitVector = MainBeamParameter.x_axis{MainBeamNr1};
	MainBeam_2_UnitVector = MainBeamParameter.x_axis{MainBeamNr2};
	%%
	if abs(MainBeam_1_UnitVector'*MainBeam_2_UnitVector) -1 > 1e-3
		z_axis = skew(MainBeam_1_UnitVector)*MainBeam_2_UnitVector;
		z_axis = z_axis/norm(z_axis);
	else
		MainBeam_1_PointNr_1 = MainBeamParameter.Beam{MainBeamNr1}(1);
		MainBeam_1_Point_1 = ...
			CrossSectionParameter.CrossSection{1}.Point{MainBeam_1_PointNr_1};
		
		MainBeam_2_PointNr_1 = MainBeamParameter.Beam{MainBeamNr2}(1);
		MainBeam_2_Point_1 = ...
			CrossSectionParameter.CrossSection{1}.Point{MainBeam_2_PointNr_1};
		
		CrossSectionBeam_UnitVector = ...
			(MainBeam_2_Point_1-MainBeam_1_Point_1)/norm(MainBeam_2_Point_1-MainBeam_1_Point_1);
		if sum(ismissing(CrossSectionBeam_UnitVector)) > 0
			MainBeam_1_PointNr_2 = MainBeamParameter.Beam{MainBeamNr1}(2);
			MainBeam_1_Point_2 = ...
				CrossSectionParameter.CrossSection{2}.Point{MainBeam_1_PointNr_2};
			
			MainBeam_2_PointNr_2 = MainBeamParameter.Beam{MainBeamNr2}(2);
			MainBeam_2_Point_2 = ...
				CrossSectionParameter.CrossSection{2}.Point{MainBeam_2_PointNr_2};
			
			CrossSectionBeam_UnitVector = ...
				(MainBeam_2_Point_2-MainBeam_1_Point_2)/norm(MainBeam_2_Point_2-MainBeam_1_Point_2);
		end
			
		z_axis = skew(CrossSectionBeam_UnitVector)*MainBeam_1_UnitVector;
		z_axis = z_axis/norm(z_axis);
		
		
	end
	PlaneParameter.z_axis{PlaneNr} = z_axis;
	%%
	MainBeamParameter.Plane{MainBeamNr1} = ...
		[MainBeamParameter.Plane{MainBeamNr1};PlaneNr];
	MainBeamParameter.Plane{MainBeamNr2} = ...
		[MainBeamParameter.Plane{MainBeamNr2};PlaneNr];
	%%
	MainBeamParameter.z_axis{MainBeamNr1,PlaneNr} = z_axis;
	MainBeam_1_RotationMatrix = ...
		[MainBeam_1_UnitVector,skew(z_axis)*MainBeam_1_UnitVector,z_axis];
	MainBeam_1_Rotation = get_Rotation_from_R(...
		MainBeam_1_RotationMatrix,zeros(3,1));
	MainBeamParameter.Rotation{MainBeamNr1,PlaneNr} = MainBeam_1_Rotation;
	%
	MainBeamParameter.z_axis{MainBeamNr2,PlaneNr} = z_axis;
	MainBeam_2_RotationMatrix = ...
		[MainBeam_2_UnitVector,skew(z_axis)*MainBeam_2_UnitVector,z_axis];
	MainBeam_2_Rotation = get_Rotation_from_R(...
		MainBeam_2_RotationMatrix,zeros(3,1));
	MainBeamParameter.Rotation{MainBeamNr2,PlaneNr} = MainBeam_2_Rotation;
end

end
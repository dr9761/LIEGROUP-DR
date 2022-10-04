function SubBeamParameter = set_Truss_SubBeam_Parameter_Type1(...
	TrussOrder,TrussLength,...
	MainBeamParameter,CrossSectionParameter,PlaneParameter, ...
	BodyParameterTableRaw,BodyNr)
%%
PlaneQuantity = numel(PlaneParameter.Plane);
SubBeamQuantity = TrussOrder;
MainBeamQuantity = numel(MainBeamParameter.Beam);
for PlaneNr = 1:PlaneQuantity
	for SubBeamNr = 1:SubBeamQuantity
		if mod(SubBeamNr,2) == 1
			MainBeamNr1 = PlaneParameter.Plane{PlaneNr}(1);
			MainBeamNr2 = PlaneParameter.Plane{PlaneNr}(2);
% 			MainBeam1 = mod(PlaneNr-1,MainBeamNr)+1;
% 			MainBeam2 = mod(PlaneNr  ,MainBeamNr)+1;
		elseif mod(SubBeamNr,2) == 0
			MainBeamNr1 = PlaneParameter.Plane{PlaneNr}(2);
			MainBeamNr2 = PlaneParameter.Plane{PlaneNr}(1);
% 			MainBeam1 = mod(PlaneNr  ,MainBeamNr)+1;
% 			MainBeam2 = mod(PlaneNr-1,MainBeamNr)+1;
		end
		PointNr1 = SubBeamNr;
		PointNr2 = SubBeamNr+1;
		SubBeamParameter.Beam{PlaneNr,SubBeamNr} = ...
			[MainBeamNr1,PointNr1,MainBeamNr2,PointNr2];
		%%
		r10 = CrossSectionParameter.CrossSection{1}.Point{MainBeamNr1};
		r1e = [TrussLength;0;0] + ...
			CrossSectionParameter.CrossSection{2}.Point{MainBeamNr1};
		r1 = (PointNr1-1)/TrussOrder * (r1e - r10) + r10;
		
		r20 = CrossSectionParameter.CrossSection{1}.Point{MainBeamNr2};
		r2e = [TrussLength;0;0] + ...
			CrossSectionParameter.CrossSection{2}.Point{MainBeamNr2};
		r2 = (PointNr2-1)/TrussOrder * (r2e - r20) + r20;
		
		deltar = r2 - r1;
		x_axis = deltar/norm(deltar);
		z_axis = PlaneParameter.z_axis{PlaneNr};
		y_axis = skew(z_axis)*x_axis;
		
		SubBeam_RotationMatrix = [x_axis,y_axis,z_axis];
		MainBeam_1_RotationMatrix = ...
			get_R(MainBeamParameter.Rotation{MainBeamNr1,PlaneNr});
		MainBeam_2_RotationMatrix = ...
			get_R(MainBeamParameter.Rotation{MainBeamNr2,PlaneNr});
		
		SubBeam_Relative_RotationMatrix_1 = ...
			MainBeam_1_RotationMatrix'*SubBeam_RotationMatrix;
% 		MainBeam_1_RotationMatrix*SubBeam_Relative_RotationMatrix_1 = ...
% 			SubBeam_RotationMatrix;
		SubBeam_Relative_RotationMatrix_2 = ...
			MainBeam_2_RotationMatrix'*SubBeam_RotationMatrix;
		% get_z_Rotation_from_Rz
		SubBeam_Relative_Rotation_1 = get_Rotation_from_R(...
			SubBeam_Relative_RotationMatrix_1,zeros(3,1));
		SubBeam_Relative_Rotation_2 = get_Rotation_from_R(...
			SubBeam_Relative_RotationMatrix_2,zeros(3,1));
		
% 		SubBeamParameter.x_axis{PlaneNr,SubBeamNr} = x_axis;
% 		deltar1 = r1e - r10;
% 		deltar2 = r2e - r20;
		
% 		if norm(skew(deltar1)*r20) ~= 0
% 			RotationAxis = skew(deltar1)*r20 / norm(skew(deltar1)*r20);
% 		elseif norm(skew(deltar1)*r2e) ~= 0
% 			RotationAxis = skew(deltar1)*r2e / norm(skew(deltar1)*r2e);
% 		end
		
		
% 		x1 = deltar1 / norm(deltar1);
% 		x2 = deltar2 / norm(deltar2);
% 		x  = deltar / norm(deltar);
% 		Rotation1 = get_Rotation_from_2_x_axis(x1,x);
% 		Rotation2 = get_Rotation_from_2_x_axis(x2,x);
		
% 		RotationAngle1 = acos(x1'*x);

% 		SubBeamParameter.Rotation{PlaneNr,SubBeamNr} = [Rotation1,Rotation2];
% 		MainBeamQuantity
		SubBeamParameter.Rotation{PlaneNr,SubBeamNr}.MainBeam = cell(MainBeamQuantity,1);
		SubBeamParameter.Rotation{PlaneNr,SubBeamNr}.MainBeam{MainBeamNr1} = ...
			SubBeam_Relative_Rotation_1;
		SubBeamParameter.Rotation{PlaneNr,SubBeamNr}.MainBeam{MainBeamNr2} = ...
			SubBeam_Relative_Rotation_2;
		%%
		BeamLength = norm(deltar);
		SubBeamParameter.BeamLength{PlaneNr,SubBeamNr} = BeamLength;
		%%
		SubBeamParameter.BodyParameter{PlaneNr,SubBeamNr} = ...
			set_Truss_Beam_BodyParameter(...
			BeamLength,'SubBeam',BodyParameterTableRaw,BodyNr);
	end
end

end
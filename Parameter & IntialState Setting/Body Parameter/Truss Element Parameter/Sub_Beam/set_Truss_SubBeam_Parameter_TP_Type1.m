function SubBeamParameter = set_Truss_SubBeam_Parameter_TP_Type1(...
	TrussOrder,TrussLength,...
	MainBeamParameter,CrossSectionParameter,PlaneParameter, ...
	BodyParameterTableRaw,BodyNr)
%%
PlaneQuantity = numel(PlaneParameter.Plane);
MaxSubBeamQuantity = TrussOrder;
MainBeamQuantity = numel(MainBeamParameter.Beam);
for PlaneNr = 1:PlaneQuantity
	if mod(PlaneNr,2) == 1
		SubBeamQuantity = MaxSubBeamQuantity;
	else
		SubBeamQuantity = MaxSubBeamQuantity - 1;
	end
	%%
	for SubBeamNr = 1:SubBeamQuantity
		if mod(SubBeamNr,2) == 1
			MainBeamNr1 = PlaneParameter.Plane{PlaneNr}(1);
			MainBeamNr2 = PlaneParameter.Plane{PlaneNr}(2);
		elseif mod(SubBeamNr,2) == 0
			MainBeamNr1 = PlaneParameter.Plane{PlaneNr}(2);
			MainBeamNr2 = PlaneParameter.Plane{PlaneNr}(1);
		end
		if mod(PlaneNr,2) == 1
			PointNr1 = SubBeamNr;
			PointNr2 = SubBeamNr+1;
		else
			PointNr1 = SubBeamNr+2;
			PointNr2 = SubBeamNr+1;
		end

		SubBeamParameter.Beam{PlaneNr,SubBeamNr} = ...
			[MainBeamNr1,PointNr1,MainBeamNr2,PointNr2];
		%%
		MainBeam_1_CrossSectionNodeNr_1 = ...
			MainBeamParameter.Beam{MainBeamNr1}(1);
		MainBeam_1_CrossSectionNodeNr_2 = ...
			MainBeamParameter.Beam{MainBeamNr1}(2);
		r10 = CrossSectionParameter.CrossSection{1}.Point{MainBeam_1_CrossSectionNodeNr_1};
		r1e = [TrussLength;0;0] + ...
			CrossSectionParameter.CrossSection{2}.Point{MainBeam_1_CrossSectionNodeNr_2};
		r1 = (PointNr1-1)/TrussOrder * (r1e - r10) + r10;
		
		MainBeam_2_CrossSectionNodeNr_1 = ...
			MainBeamParameter.Beam{MainBeamNr2}(1);
		MainBeam_2_CrossSectionNodeNr_2 = ...
			MainBeamParameter.Beam{MainBeamNr2}(2);
		r20 = CrossSectionParameter.CrossSection{1}.Point{MainBeam_2_CrossSectionNodeNr_1};
		r2e = [TrussLength;0;0] + ...
			CrossSectionParameter.CrossSection{2}.Point{MainBeam_2_CrossSectionNodeNr_2};
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
		SubBeam_Relative_RotationMatrix_2 = ...
			MainBeam_2_RotationMatrix'*SubBeam_RotationMatrix;

		SubBeam_Relative_Rotation_1 = get_Rotation_from_R(...
			SubBeam_Relative_RotationMatrix_1,zeros(3,1));
		SubBeam_Relative_Rotation_2 = get_Rotation_from_R(...
			SubBeam_Relative_RotationMatrix_2,zeros(3,1));

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
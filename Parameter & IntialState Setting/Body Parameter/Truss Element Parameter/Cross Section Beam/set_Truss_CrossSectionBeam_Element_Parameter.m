function CrossSectionBeam = set_Truss_CrossSectionBeam_Element_Parameter(...
	BeamNr,PointNr1,PointNr2,CrossSectionNr, ...
	CrossSectionParameter,CrossSectionBeam, ...
	BodyParameterTableRaw,BodyNr)
%%
r1 = CrossSectionParameter.CrossSection{CrossSectionNr}.Point{PointNr1};
r2 = CrossSectionParameter.CrossSection{CrossSectionNr}.Point{PointNr2};
deltar = r2 - r1;

x1 = [1;0;0];
x2 = deltar / norm(deltar);

Rotation = get_Rotation_from_2_x_axis(x1,x2);
BeamLength = norm(deltar);
%%
CrossSectionBeam.Beam{BeamNr} = [PointNr1,PointNr2];
CrossSectionBeam.Rotation{BeamNr} = Rotation;
CrossSectionBeam.BeamLength{BeamNr} = BeamLength;
%%
CrossSectionBeam.BodyParameter{BeamNr} = ...
	set_Truss_Beam_BodyParameter(...
	BeamLength,'CrossSection',BodyParameterTableRaw,BodyNr);
end
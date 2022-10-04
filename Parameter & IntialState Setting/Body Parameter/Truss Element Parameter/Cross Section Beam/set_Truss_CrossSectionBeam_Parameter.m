function CrossSectionBeamParameter = set_Truss_CrossSectionBeam_Parameter(...
	CrossSectionParameter,BodyParameterTableRaw,BodyNr)
%%
CrossSectionBeam = cell(2,1);
CrossSectionBeam{1} = struct;
CrossSectionBeam{2} = struct;
CrossSectionBeam_Quantity = zeros(2,1);
%
CrossSectionQuantity = 2;
%
CrossSection_BeamNodeDefinitionSet{1} = ...
	str2num(BodyParameterTableRaw{30,BodyNr+3});
CrossSection_BeamNodeDefinitionSet{2} = ...
	str2num(BodyParameterTableRaw{31,BodyNr+3});
%
CrossSectionBeam_Quantity(1) = ...
	size(CrossSection_BeamNodeDefinitionSet{1},1);
CrossSectionBeam_Quantity(2) = ...
	size(CrossSection_BeamNodeDefinitionSet{2},1);
%%
for CrossSectionNr = 1:CrossSectionQuantity
	CrossSectionBeam{CrossSectionNr}.Beam = cell(0);
	for CrossSectionBeamNr = 1:CrossSectionBeam_Quantity(CrossSectionNr)
		PointNr1 = ...
			CrossSection_BeamNodeDefinitionSet{CrossSectionNr}(CrossSectionBeamNr,1);
		PointNr2 = ...
			CrossSection_BeamNodeDefinitionSet{CrossSectionNr}(CrossSectionBeamNr,2);
		
		CrossSectionBeam{CrossSectionNr} = ...
			set_Truss_CrossSectionBeam_Element_Parameter(...
			CrossSectionBeamNr,PointNr1,PointNr2,CrossSectionNr, ...
			CrossSectionParameter,CrossSectionBeam{CrossSectionNr}, ...
			BodyParameterTableRaw,BodyNr);
		
		
	end	
end
%%
CrossSectionBeamParameter.CrossSectionBeam = CrossSectionBeam;

end


function [CrossSectionMass,CrossSectionForce] = add_CrossSectionBeam_Mass_Force(...
	CrossSectionBeamParameter, ...
	CrossSectionNode,dqe,g)
%%
CrossSectionMass = zeros(12,12);
CrossSectionForce = zeros(12,1);
%%
for CrossSectionNr = 1:2
	for BeamNr = 1:numel(CrossSectionBeamParameter.CrossSectionBeam{CrossSectionNr}.Beam)
		Point1Nr = CrossSectionBeamParameter.CrossSectionBeam{CrossSectionNr}.Beam{BeamNr}(1);
		Point2Nr = CrossSectionBeamParameter.CrossSectionBeam{CrossSectionNr}.Beam{BeamNr}(2);
		%%
		Body_Parameter = ...
			CrossSectionBeamParameter.CrossSectionBeam{CrossSectionNr}.BodyParameter{BeamNr};
		
% 		Body_Parameter = set_Truss_Beam_BodyParameter(CrossSectionBeamLength,...
% 			'CrossSection');
		%%
		[CrossSectionBeam_Mass,CrossSectionBeam_Force] = ...
			get_CrossSectionBeam_Mass_Force(...
			CrossSectionNr,BeamNr,Point1Nr,Point2Nr,Body_Parameter, ...
			CrossSectionBeamParameter,CrossSectionNode,dqe,g);
		%%
		CrossSectionMass = CrossSectionMass + CrossSectionBeam_Mass;
		CrossSectionForce = CrossSectionForce + CrossSectionBeam_Force;
	end
end

end
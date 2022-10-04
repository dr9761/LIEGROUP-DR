function plot_CrossSectionBeam(CrossSectionBeamParameter, ...
	CrossSectionNode, ...
	InterpolationNr,CrossSectionBeamPlotStyle,FigureObj)
%%
for CrossSectionNr = 1:2
	for BeamNr = 1:numel(CrossSectionBeamParameter.CrossSectionBeam{CrossSectionNr}.Beam)
		Point1Nr = CrossSectionBeamParameter.CrossSectionBeam{CrossSectionNr}.Beam{BeamNr}(1);
		Point2Nr = CrossSectionBeamParameter.CrossSectionBeam{CrossSectionNr}.Beam{BeamNr}(2);
		%%
		Body_Parameter = ...
			CrossSectionBeamParameter.CrossSectionBeam{CrossSectionNr}.BodyParameter{BeamNr};
		%%
		%%
		phib = ...
			CrossSectionBeamParameter.CrossSectionBeam{CrossSectionNr}.Rotation{BeamNr};
		Rb = get_R(phib);
		%%
		q1 = CrossSectionNode.CrossSection{CrossSectionNr}.qs{Point1Nr};
		q2 = CrossSectionNode.CrossSection{CrossSectionNr}.qs{Point2Nr};
		
		R1 = get_R(q1(4:6));
		R2 = get_R(q2(4:6));
		
		qb1 = zeros(6,1);
		qb1(1:3) = q1(1:3);
% 		qb1(4:6) = q1(4:6) + R1 * phib;
% 		x1 = [1;0;0];
% 		x2 = R1*Rb*[1;0;0];
		qb1(4:6) = get_Rotation_from_R(R1*Rb,q1(4:6));
		
		
		qb2 = zeros(6,1);
		qb2(1:3) = q2(1:3);
% 		qb2(4:6) = q2(4:6) + R2 * phib;
% 		x1 = [1;0;0];
% 		x2 = R2*Rb*[1;0;0];
		qb2(4:6) = get_Rotation_from_R(R2*Rb,qb1(4:6));
		
		qb = [qb1;qb2];
		%%
		plot_TimoshenkoBeam(...
			qb,InterpolationNr,Body_Parameter,CrossSectionBeamPlotStyle,FigureObj);
	end
end

end
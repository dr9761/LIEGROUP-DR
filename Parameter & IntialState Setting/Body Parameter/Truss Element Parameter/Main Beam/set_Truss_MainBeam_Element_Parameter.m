function MainBeamParameter = set_Truss_MainBeam_Element_Parameter(...
	MainBeamNr,Point1Nr,Point2Nr, ...
	TrussLength,CrossSectionParameter,MainBeamParameter, ...
	BodyParameterTableRaw,BodyNr)

%%
MainBeamParameter.Beam{MainBeamNr} = [Point1Nr,Point2Nr];
%%
Point1 = CrossSectionParameter.CrossSection{1}.Point{Point1Nr};
Point2 = [TrussLength;0;0] + ...
	CrossSectionParameter.CrossSection{2}.Point{Point2Nr};
%% x-axis
MainBeamParameter.x_axis{MainBeamNr} = (Point2 - Point1) / norm(Point2 - Point1);
%%
% x1 = [1;0;0];
% x2 = (Point2 - Point1) / norm(Point2 - Point1);
% Rotation = get_Rotation_from_2_x_axis(x1,x2);
% MainBeamParameter.Rotation{MainBeamNr} = Rotation;
%%
BeamLength = norm(Point2 - Point1);
MainBeamParameter.BeamLength{MainBeamNr} = BeamLength;
%%
MainBeamParameter.BodyParameter{MainBeamNr} = ...
	set_Truss_Beam_BodyParameter(BeamLength,'MainBeam', ...
	BodyParameterTableRaw,BodyNr);
%%
MainBeamParameter.Plane{MainBeamNr} = [];
end
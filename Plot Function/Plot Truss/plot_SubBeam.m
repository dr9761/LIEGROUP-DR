function plot_SubBeam(SubBeamParameter,PlaneParameter,InternalNode, ...
	InterpolationNr,SubBeamPlotStyle,FigureObj)
%%
PlaneQuantity = numel(PlaneParameter.Plane);
for PlaneNr = 1:PlaneQuantity
	for SubBeamNr = 1:size(SubBeamParameter.Beam,2)
		if ~isempty(SubBeamParameter.Beam{PlaneNr,SubBeamNr})
		MainBeamNr1  = SubBeamParameter.Beam{PlaneNr,SubBeamNr}(1);
		InternalNodeNr1 = SubBeamParameter.Beam{PlaneNr,SubBeamNr}(2);
		MainBeamNr2  = SubBeamParameter.Beam{PlaneNr,SubBeamNr}(3);
		InternalNodeNr2 = SubBeamParameter.Beam{PlaneNr,SubBeamNr}(4);
		%%
		Body_Parameter = ...
			SubBeamParameter.BodyParameter{PlaneNr,SubBeamNr};
		%%
		phib1 = SubBeamParameter.Rotation{PlaneNr,SubBeamNr}.MainBeam{MainBeamNr1};
		phib2 = SubBeamParameter.Rotation{PlaneNr,SubBeamNr}.MainBeam{MainBeamNr2};
		
		Rb1 = get_R(phib1);
		Rb2 = get_R(phib2);
		%%
		r01 = InternalNode.Plane{PlaneNr}.r0i{MainBeamNr1,InternalNodeNr1};
		r02 = InternalNode.Plane{PlaneNr}.r0i{MainBeamNr2,InternalNodeNr2};
		
		R1 = InternalNode.Plane{PlaneNr}.Ri{MainBeamNr1,InternalNodeNr1};
		R2 = InternalNode.Plane{PlaneNr}.Ri{MainBeamNr2,InternalNodeNr2};
		
% 		R1 = get_R(q1(4:6));
% 		R2 = get_R(q2(4:6));
		
		qb1 = zeros(6,1);
		qb1(1:3) = r01;
% 		qb1(4:6) = q1(4:6) + R1*phib1;
% 		x1 = [1;0;0];
% 		x2 = R1*Rb1*[1;0;0];
		qb1(4:6) = get_Rotation_from_R(R1*Rb1,zeros(3,1));
% 		qb1(4:6) = get_Rotation_from_R(R1,q1(4:6));
		
		qb2 = zeros(6,1);
		qb2(1:3) = r02;
% 		qb2(4:6) = q2(4:6) + R2*phib2;
% 		x1 = [1;0;0];
% 		x2 = R2*Rb2*[1;0;0];
		qb2(4:6) = get_Rotation_from_R(R2*Rb2,zeros(3,1));
% 		qb2(4:6) = get_Rotation_from_R(R2,qb1(4:6));
		
% 		if max(qb1(4:6)-qb2(4:6)) > max(qb1(4:6)+qb2(4:6))
% 			qb2(4:6) = -qb2(4:6);
% 		end
			
		qb = [qb1;qb2];
		%%
		plot_TimoshenkoBeam(...
			qb,InterpolationNr,Body_Parameter,SubBeamPlotStyle,FigureObj);
		end
	end
end

end
function plot_MainBeam(InternalNode,MainBeamParameter,PlaneParameter, ...
	TrussOrder, ...
	InterpolationNr,MainBeamPlotStyle,FigureObj)
%%
MainBeamQuantity = numel(MainBeamParameter.Beam);
for MainBeamNr = 1:MainBeamQuantity
	PlaneNr = MainBeamParameter.Plane{MainBeamNr}(1);
	L = MainBeamParameter.BeamLength{MainBeamNr};
	Li = L / TrussOrder;

	MainBeamNr1 = MainBeamNr;
	MainBeamNr2 = MainBeamNr;
	%%
	for InternalNodeNr = 1:TrussOrder
		InternalNodeNr1 = InternalNodeNr;
		InternalNodeNr2 = InternalNodeNr + 1;
		%%
		Body_Parameter = MainBeamParameter.BodyParameter{MainBeamNr};
		Body_Parameter.L = Li;
		%%
% 		q1 = InternalNode.Plane{PlaneNr}.qi{MainBeamNr1,InternalNodeNr1};
% 		q2 = InternalNode.Plane{PlaneNr}.qi{MainBeamNr2,InternalNodeNr2};
		
		r01 = InternalNode.Plane{PlaneNr}.r0i{MainBeamNr1,InternalNodeNr1};
		r02 = InternalNode.Plane{PlaneNr}.r0i{MainBeamNr2,InternalNodeNr2};
		
		R1 = InternalNode.Plane{PlaneNr}.Ri{MainBeamNr1,InternalNodeNr1};
		R2 = InternalNode.Plane{PlaneNr}.Ri{MainBeamNr2,InternalNodeNr2};
		qb1 = zeros(6,1);
		qb1(1:3) = r01;
		qb1(4:6) = get_Rotation_from_R(R1,zeros(3,1));
		
		qb2 = zeros(6,1);
		qb2(1:3) = r02;
		qb2(4:6) = get_Rotation_from_R(R2,zeros(3,1));
		
		qb = [qb1;qb2];
		%%
		plot_TimoshenkoBeam(...
			qb,InterpolationNr,Body_Parameter,MainBeamPlotStyle,FigureObj);
	end
end

end
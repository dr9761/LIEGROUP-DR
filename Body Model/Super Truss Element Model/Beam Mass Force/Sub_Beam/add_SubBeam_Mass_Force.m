function [SubBeamMass,SubBeamForce] = add_SubBeam_Mass_Force(...
	InternalNode,SubBeamParameter,dqe,g)

SubBeamMass = zeros(12);
SubBeamForce = zeros(12,1);
PlaneQuantity = size(SubBeamParameter.Beam,1);
SubBeamQuantityOnPlane = size(SubBeamParameter.Beam,2);
for PlaneNr = 1:PlaneQuantity
	for SubBeamNr = 1:SubBeamQuantityOnPlane
		if ~isempty(SubBeamParameter.Beam{PlaneNr,SubBeamNr})
		MainBeamNr1  = SubBeamParameter.Beam{PlaneNr,SubBeamNr}(1);
		InternalNodeNr1 = SubBeamParameter.Beam{PlaneNr,SubBeamNr}(2);
		MainBeamNr2  = SubBeamParameter.Beam{PlaneNr,SubBeamNr}(3);
		InternalNodeNr2 = SubBeamParameter.Beam{PlaneNr,SubBeamNr}(4);
		%%
		Body_Parameter = ...
			SubBeamParameter.BodyParameter{PlaneNr,SubBeamNr};
		%%
		phib1 = ...
			SubBeamParameter.Rotation{PlaneNr,SubBeamNr}.MainBeam{MainBeamNr1};
		phib2 = ...
			SubBeamParameter.Rotation{PlaneNr,SubBeamNr}.MainBeam{MainBeamNr2};
		%
		[SubBeamElementMass,SubBeamElementForce] = ...
			get_SubBeam_Mass_Force(...
			InternalNode,Body_Parameter, ...
			PlaneNr,MainBeamNr1,InternalNodeNr1,MainBeamNr2,InternalNodeNr2, ...
			phib1,phib2,dqe,g);
		%%
		SubBeamMass = SubBeamMass + SubBeamElementMass;
		SubBeamForce = SubBeamForce + SubBeamElementForce;
		end
	end
end

end
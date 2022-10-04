function [MainBeamMass,MainBeamForce] = add_MainBeam_Mass_Force(...
	InternalNode,MainBeamParameter,dqe,g)
%%
MainBeamMass  = zeros(12,12);
MainBeamForce = zeros(12,1);
%%
TrussOrder = size(InternalNode.Plane{1}.r0i,2)-1;
%%
MainBeamQuantity = numel(MainBeamParameter.Beam);
MainBeamLengthSet = MainBeamParameter.BeamLength;
MainBeamBodyParameterSet = MainBeamParameter.BodyParameter;
for MainBeamNr = 1:MainBeamQuantity
	L = MainBeamLengthSet{MainBeamNr};
	Li = L / TrussOrder;
	%%
	Body_Parameter = MainBeamBodyParameterSet{MainBeamNr};
	Body_Parameter.L = Li;
	%%
	[MainBeamMass,MainBeamForce] = ...
		get_MainBeam_MassForce_of_one_MainBeam(...
		dqe,g,TrussOrder,MainBeamNr, ...
		InternalNode,MainBeamParameter,Body_Parameter, ...
		MainBeamMass,MainBeamForce);
end

end
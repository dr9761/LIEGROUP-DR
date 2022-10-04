function [MainBeamMass,MainBeamForce] = ...
	get_MainBeam_MassForce_of_one_MainBeam(...
	dqe,g,TrussOrder,MainBeamNr, ...
	InternalNode,MainBeamParameter,Body_Parameter, ...
	MainBeamMass,MainBeamForce)
%%
for InternalNodeNr = 1:TrussOrder
		InternalNodeNr1 = InternalNodeNr;
		InternalNodeNr2 = InternalNodeNr + 1;
		%%
		[MainBeamElementMass,MainBeamElementForce] = ...
			get_MainBeam_Mass_Force(...
			InternalNode,MainBeamParameter,Body_Parameter, ...
			MainBeamNr,InternalNodeNr1,InternalNodeNr2, ...
			dqe,g);
		%%
		MainBeamMass = MainBeamMass + MainBeamElementMass;
		MainBeamForce = MainBeamForce + MainBeamElementForce;
end
	
end
function [Mass,Force] = Super_Truss_Element_MassForce(...
	qe,dqe,g,BodyParameter)
%%
Truss_Parameter = BodyParameter.Truss_Parameter;

TrussOrder = Truss_Parameter.TrussOrder;
% TrussLength = Truss_Parameter.TrussLength;
CrossSectionParameter = Truss_Parameter.CrossSectionParameter;
MainBeamParameter = Truss_Parameter.MainBeamParameter;
CrossSectionBeamParameter = Truss_Parameter.CrossSectionBeamParameter;
SubBeamParameter = Truss_Parameter.SubBeamParameter;
PlaneParameter = Truss_Parameter.PlaneParameter;
%% Node Definition
% CrossSection Node
[CrossSectionNode] = set_CrossSection_Node(...
	qe,dqe,CrossSectionParameter);
% Internal Node
[InternalNode] = set_InternalNode(TrussOrder, ...
	MainBeamParameter,CrossSectionNode,PlaneParameter);
%% Beam Definition
% MainBeam
[MainBeamMass,MainBeamForce] = add_MainBeam_Mass_Force(...
	InternalNode,MainBeamParameter,dqe,g);
% CrossSection Beam
[CrossSectionMass,CrossSectionForce] = add_CrossSectionBeam_Mass_Force(...
	CrossSectionBeamParameter, ... 
	CrossSectionNode,dqe,g);
% SubBeam
[SubBeamMass,SubBeamForce] = add_SubBeam_Mass_Force(...
	InternalNode,SubBeamParameter,dqe,g);
%% Total Mass & Force
Mass  = MainBeamMass  + CrossSectionMass  + SubBeamMass;
Force = MainBeamForce + CrossSectionForce + SubBeamForce;
%
% Mass  = MainBeamMass  + SubBeamMass;
% Force = MainBeamForce + SubBeamForce;
%
% Mass  = MainBeamMass  + CrossSectionMass;
% Force = MainBeamForce + CrossSectionForce;
end
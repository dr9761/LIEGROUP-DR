function [CrossSection] = ...
	get_CrossSectionNode_of_one_Section_Symbolic(...
	CrossSectionNr,qe,dqe,CrossSectionParameter)
%%
CrossSectionNodeQuantity = ...
	numel(CrossSectionParameter.CrossSection{CrossSectionNr}.Point);
for CrossSectionNodeNr = 1:CrossSectionNodeQuantity
	
	[qs,dqs,Ts,dTs] = get_CrossSecion_Node_Symbolic(...
		qe,dqe,CrossSectionParameter,CrossSectionNr,CrossSectionNodeNr);
	
	CrossSection.qs{CrossSectionNodeNr}  = qs;
	CrossSection.dqs{CrossSectionNodeNr} = dqs;
	CrossSection.Ts{CrossSectionNodeNr}  = Ts;
	CrossSection.dTs{CrossSectionNodeNr} = dTs;
end
% CrossSection_set = CrossSection;
end
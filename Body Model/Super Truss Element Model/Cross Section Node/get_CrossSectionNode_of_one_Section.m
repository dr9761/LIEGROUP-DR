function [CrossSection] = get_CrossSectionNode_of_one_Section(...
	CrossSectionNr,qe,dqe,CrossSectionParameter)
%%
CrossSectionNodeQuantity = ...
	numel(CrossSectionParameter.CrossSection{CrossSectionNr}.Point);
%%
qs  = cell(CrossSectionNodeQuantity,1);
dqs = cell(CrossSectionNodeQuantity,1);
Ts  = cell(CrossSectionNodeQuantity,1);
dTs = cell(CrossSectionNodeQuantity,1);
%
for CrossSectionNodeNr = 1:CrossSectionNodeQuantity
	
	[qsi,dqsi,Tsi,dTsi] = get_CrossSecion_Node(...
		qe,dqe, ...
		CrossSectionParameter,CrossSectionNr,CrossSectionNodeNr);
	
	qs{CrossSectionNodeNr}  = qsi;
	dqs{CrossSectionNodeNr} = dqsi;
	Ts{CrossSectionNodeNr}  = Tsi;
	dTs{CrossSectionNodeNr} = dTsi;
end
CrossSection.qs  = qs;
CrossSection.dqs = dqs;
CrossSection.Ts  = Ts;
CrossSection.dTs = dTs;
end
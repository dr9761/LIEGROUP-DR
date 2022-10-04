function [CrossSectionNode] = set_CrossSection_Node(...
	qe,dqe,CrossSectionParameter)
%%
CrossSection = cell(2,1);
for CrossSectionNr = 1:2
	CrossSection{CrossSectionNr} = ...
		get_CrossSectionNode_of_one_Section(...
		CrossSectionNr,qe,dqe,CrossSectionParameter);
end
CrossSectionNode.CrossSection = CrossSection;
end
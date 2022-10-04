function [CrossSectionNode] = set_CrossSection_Node_Symbolic(...
	qe,dqe,CrossSectionParameter)
%%
for CrossSectionNr = 1:2
% CrossSectionNr = 1;
CrossSectionNode.CrossSection{CrossSectionNr} = ...
	get_CrossSectionNode_of_one_Section_Symbolic(...
	CrossSectionNr,qe,dqe,CrossSectionParameter);
end
%%
% CrossSectionNr = 2;
% [CrossSection2] = get_CrossSectionNode_of_one_Section(...
% 	CrossSectionNr,qe,dqe,CrossSectionParameter);
% %%
% CrossSectionNode.CrossSection{1} = CrossSection1;
% CrossSectionNode.CrossSection{2} = CrossSection2;
end
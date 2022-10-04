function CrossSectionParameter = set_Truss_CrossSection_Parameter(...
	BodyParameterTableRaw,BodyNr)
%%
if isnumeric(BodyParameterTableRaw{22,BodyNr+3})
	CrossSection_1_NodeSet_x = BodyParameterTableRaw{22,BodyNr+3};
else
	CrossSection_1_NodeSet_x = ...
		str2num(BodyParameterTableRaw{22,BodyNr+3});
end
if isnumeric(BodyParameterTableRaw{23,BodyNr+3})
	CrossSection_1_NodeSet_y = BodyParameterTableRaw{23,BodyNr+3};
else
	CrossSection_1_NodeSet_y = ...
		str2num(BodyParameterTableRaw{23,BodyNr+3});
end
if isnumeric(BodyParameterTableRaw{24,BodyNr+3})
	CrossSection_1_NodeSet_z = BodyParameterTableRaw{24,BodyNr+3};
else
	CrossSection_1_NodeSet_z = ...
		str2num(BodyParameterTableRaw{24,BodyNr+3});
end
%
CrossSection_1_NodeQuantity = min([...
	numel(CrossSection_1_NodeSet_x), ...
	numel(CrossSection_1_NodeSet_y), ...
	numel(CrossSection_1_NodeSet_z)]);
%
CrossSection1.Point = cell(CrossSection_1_NodeQuantity,1);
for CrossSection_1_NodeNr = 1:CrossSection_1_NodeQuantity
	CrossSection1.Point{CrossSection_1_NodeNr} = [...
		CrossSection_1_NodeSet_x(CrossSection_1_NodeNr);
		CrossSection_1_NodeSet_y(CrossSection_1_NodeNr);
		CrossSection_1_NodeSet_z(CrossSection_1_NodeNr)];
end
%%
CrossSection_2_NodeSet_x = ...
	str2num(BodyParameterTableRaw{25,BodyNr+3});
CrossSection_2_NodeSet_y = ...
	str2num(BodyParameterTableRaw{26,BodyNr+3});
CrossSection_2_NodeSet_z = ...
	str2num(BodyParameterTableRaw{27,BodyNr+3});
%
CrossSection_2_NodeQuantity = min([...
	numel(CrossSection_2_NodeSet_x), ...
	numel(CrossSection_2_NodeSet_y), ...
	numel(CrossSection_2_NodeSet_z)]);
%
CrossSection2.Point = cell(CrossSection_2_NodeQuantity,1);
for CrossSection_2_NodeNr = 1:CrossSection_2_NodeQuantity
	CrossSection2.Point{CrossSection_2_NodeNr} = [...
		CrossSection_2_NodeSet_x(CrossSection_2_NodeNr);
		CrossSection_2_NodeSet_y(CrossSection_2_NodeNr);
		CrossSection_2_NodeSet_z(CrossSection_2_NodeNr)];
end
%%
CrossSectionParameter.CrossSection = cell(2,1);
CrossSectionParameter.CrossSection{1} = CrossSection1;
CrossSectionParameter.CrossSection{2} = CrossSection2;

end
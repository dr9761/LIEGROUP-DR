function Truss_Parameter = set_Truss_Parameter(...
		BodyParameterTableRaw,BodyNr)
%%
TrussOrder = BodyParameterTableRaw{21,BodyNr+3};
TrussLength = BodyParameterTableRaw{9,BodyNr+3};
SubBeamType = BodyParameterTableRaw{32,BodyNr+3};
%% Definition of Cross Section Node
CrossSectionParameter = set_Truss_CrossSection_Parameter(...
	BodyParameterTableRaw,BodyNr);
%% Definition of Beam
% 定义主梁的构成结构，确定主梁的x轴
MainBeamParameter = set_Truss_MainBeam_Parameter(...
	TrussLength,CrossSectionParameter,BodyParameterTableRaw,BodyNr);
% 通过主梁定义腹杆平面，确定腹杆平面的z轴
[MainBeamParameter,PlaneParameter] = set_Truss_Plane_Parameter(...
	CrossSectionParameter,MainBeamParameter);
% 通过腹杆平面定义主梁旋转
% MainBeamParameter = set_Truss_MainBeam_Rotation_Parameter(...
% 	MainBeamParameter,PlaneParameter);
CrossSectionBeamParameter = set_Truss_CrossSectionBeam_Parameter(...
	CrossSectionParameter,BodyParameterTableRaw,BodyNr);
% 通过主梁参数，端面节点参数以及腹杆形式确定腹杆的参数
SubBeamParameter = set_Truss_SubBeam_Parameter(SubBeamType,TrussOrder,TrussLength,...
	MainBeamParameter,CrossSectionParameter,PlaneParameter,BodyParameterTableRaw,BodyNr);
%%
useEquivalentModel = BodyParameterTableRaw{34,BodyNr+3};
if ismissing(useEquivalentModel)
	useEquivalentModel = false;
end
if useEquivalentModel
	EquivalentParameterNr = BodyParameterTableRaw{35,BodyNr+3};
	TrussEquivalentDynamicParameter = ...
		load('TrussEquivalentDynamicParameter.mat', ...
		'TrussParameter');
	TrussEquivalentDynamicParameter = ...
		TrussEquivalentDynamicParameter.TrussParameter;
	TrussEquivalentStaticParameter = ...
		load('TrussEquivalentStaticParameter.mat', ...
		'TrussParameter');
	TrussEquivalentStaticParameter = ...
		TrussEquivalentStaticParameter.TrussParameter;
	
	TrussEquivalentParameter.Dynamic = ...
		TrussEquivalentDynamicParameter{EquivalentParameterNr};
	TrussEquivalentParameter.Static = ...
		TrussEquivalentStaticParameter{EquivalentParameterNr};
else
	TrussEquivalentParameter = [];
end
%%
Truss_Parameter.TrussOrder = TrussOrder;
Truss_Parameter.TrussLength = TrussLength;
% Truss_Parameter.SubBeamType = SubBeamType;
Truss_Parameter.CrossSectionParameter = CrossSectionParameter;
Truss_Parameter.MainBeamParameter = MainBeamParameter;
Truss_Parameter.CrossSectionBeamParameter = CrossSectionBeamParameter;
Truss_Parameter.SubBeamParameter = SubBeamParameter;
Truss_Parameter.PlaneParameter = PlaneParameter;
%
Truss_Parameter.useEquivalentModel = useEquivalentModel;
Truss_Parameter.EquivalentParameter = TrussEquivalentParameter;
end
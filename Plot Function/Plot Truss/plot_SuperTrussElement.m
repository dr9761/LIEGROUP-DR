function plot_SuperTrussElement(qe, ...
	InterpolationNr,Truss_Parameter,PlotStyle,FigureObj)
%%
dqe = zeros(12,1);
PlotStyle = strsplit(PlotStyle,',');
MainBeamPlotStyle = PlotStyle{1};
CrossSectionBeamPlotStyle = PlotStyle{2};
SubBeamPlotStyle = PlotStyle{3};
%%
TrussOrder = Truss_Parameter.TrussOrder;
CrossSectionParameter = Truss_Parameter.CrossSectionParameter;
MainBeamParameter = Truss_Parameter.MainBeamParameter;
CrossSectionBeamParameter = Truss_Parameter.CrossSectionBeamParameter;
SubBeamParameter = Truss_Parameter.SubBeamParameter;
PlaneParameter = Truss_Parameter.PlaneParameter;
%% Node
% CrossSection Node
[CrossSectionNode] = set_CrossSection_Node(...
	qe,dqe,CrossSectionParameter);
% Internal Node
[InternalNode] = set_InternalNode(TrussOrder, ...
	MainBeamParameter,CrossSectionNode,PlaneParameter);
%% MainBeam
plot_MainBeam(InternalNode,MainBeamParameter,PlaneParameter, ...
	TrussOrder, ...
	InterpolationNr,MainBeamPlotStyle,FigureObj);
%% CrossSectionBeam
plot_CrossSectionBeam(CrossSectionBeamParameter, ...
	CrossSectionNode, ...
	InterpolationNr,CrossSectionBeamPlotStyle,FigureObj);
%% SubBeam
plot_SubBeam(SubBeamParameter,PlaneParameter,InternalNode, ...
	InterpolationNr,SubBeamPlotStyle,FigureObj);

end
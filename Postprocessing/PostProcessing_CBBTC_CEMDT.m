%% ========== PostProcessing_CBBTC_CEMDT ===========
%% PostProcessing
%% Cantilever Beam Bending to Circle(CBBTC)
%% Constant End Moment Drive Test(CEMDT)
%% =================================================
clear;close all;clc;
%%
ResultParentFolderName = ...
	['Result\Cantilever Beam Static Bending to Circle\'];
% 	['Result\Cantilever Beam Bending to Circle\'];
%%
% Timoshenko Cantilever Beam Static Bending - 1 Segments
FlexibleBodyTypeFolderName_set{1,1} = ...
	'Timoshenko Cantilever Beam Static Bending - 1 Segments';
% Timoshenko Cantilever Beam Static Bending - 3 Segments
FlexibleBodyTypeFolderName_set{1,2} = ...
	'Timoshenko Cantilever Beam Static Bending - 3 Segments';
% Timoshenko Cantilever Beam Static Bending - 5 Segments
FlexibleBodyTypeFolderName_set{1,3} = ...
	'Timoshenko Cantilever Beam Static Bending - 5 Segments';
% Timoshenko Cantilever Beam Static Bending - 10 Segments
FlexibleBodyTypeFolderName_set{1,4} = ...
	'Timoshenko Cantilever Beam Static Bending - 10 Segments';
% Cubic Spline Cantilever Beam Static Bending - 1 Segments
FlexibleBodyTypeFolderName_set{2,1} = ...
	'Cubic Spline Cantilever Beam Static Bending - 1 Segments';
% Cubic Spline Cantilever Beam Static Bending - 3 Segments
FlexibleBodyTypeFolderName_set{2,2} = ...
	'Cubic Spline Cantilever Beam Static Bending - 3 Segments';
% Cubic Spline Cantilever Beam Static Bending - 5 Segments
FlexibleBodyTypeFolderName_set{2,3} = ...
	'Cubic Spline Cantilever Beam Static Bending - 5 Segments';
% Cubic Spline Cantilever Beam Static Bending - 10 Segments
FlexibleBodyTypeFolderName_set{2,4} = ...
	'Cubic Spline Cantilever Beam Static Bending - 10 Segments';
%%
figure('Name','Figure_FBS_CFDT');
SubFigure_CBBTC_CEMDT = cell(2,4);
SubFigure_CBBTC_CEMDT{1,1} = subplot(2,4,1);
SubFigure_CBBTC_CEMDT{1,2} = subplot(2,4,2);
SubFigure_CBBTC_CEMDT{1,3} = subplot(2,4,3);
SubFigure_CBBTC_CEMDT{1,4} = subplot(2,4,4);

SubFigure_CBBTC_CEMDT{2,1} = subplot(2,4,5);
SubFigure_CBBTC_CEMDT{2,2} = subplot(2,4,6);
SubFigure_CBBTC_CEMDT{2,3} = subplot(2,4,7);
SubFigure_CBBTC_CEMDT{2,4} = subplot(2,4,8);
%
SubFigureTitle{1,1} = 'T-Beam 1-Seg';
SubFigureTitle{1,2} = 'T-Beam 3-Seg';
SubFigureTitle{1,3} = 'T-Beam 5-Seg';
SubFigureTitle{1,4} = 'T-Beam 10-Seg';

SubFigureTitle{2,1} = 'C-Beam 1-Seg';
SubFigureTitle{2,2} = 'C-Beam 3-Seg';
SubFigureTitle{2,3} = 'C-Beam 5-Seg';
SubFigureTitle{2,4} = 'C-Beam 10-Seg';
%
% for SubFigureNr = 1:numel(SubFigure_CBBTC_CEMDT)
% 	hold(SubFigure_CBBTC_CEMDT{SubFigureNr},'on');
% end
%%
for BeamTypeNr = 1:2
	% 	if BeamTypeNr == 1
	% 		SegmentSetQuantity = 4;
	% 	else
	% 		SegmentSetQuantity = 3;
	% 	end
	SegmentSetQuantity = 4;
	for SegmentSetNr = 1:SegmentSetQuantity
		FlexibleBodyTypeFolderName = ...
			FlexibleBodyTypeFolderName_set{BeamTypeNr,SegmentSetNr};
		
		SubFigureObj = SubFigure_CBBTC_CEMDT{BeamTypeNr,SegmentSetNr};
		
		PostProcessing_CBBTC_CEMDT_PlotFunc(...
			ResultParentFolderName,FlexibleBodyTypeFolderName, ...
			BeamTypeNr,SegmentSetNr,SubFigureObj,SubFigureTitle);
	end
end
%%
% for SubFigureNr = 1:numel(SubFigure_CBBTC_CEMDT)
% 	hold(SubFigure_CBBTC_CEMDT{SubFigureNr},'off');
% 	title(SubFigure_CBBTC_CEMDT{SubFigureNr},SubFigureTitle{SubFigureNr});
% end
%%
function PostProcessing_CBBTC_CEMDT_PlotFunc(...
	ResultParentFolderName,FlexibleBodyTypeFolderName, ...
	BeamTypeNr,SegmentSetNr,SubFigureObj,SubFigureTitle)
ResultFileName = ...
	[ResultParentFolderName, ...
	FlexibleBodyTypeFolderName, ...
	'\Parameter.mat'];
ExperimentData = load(ResultFileName);

ModelParameter = ExperimentData.ModelParameter;
x_set = ExperimentData.x_set;
t_set = ExperimentData.t_set;

t_end = t_set(end);
MomentInterval = 10;
AppliedMomentQuantity = floor(min(t_end,100)/MomentInterval);

SubPlotNr = 4*(BeamTypeNr-1) + SegmentSetNr;
subplot(2,4,SubPlotNr);
hold on;
for AppliedMomentNr = 0:AppliedMomentQuantity
	t_target = AppliedMomentNr * MomentInterval;
	[~,t_Nr] = min(abs(t_set-t_target));
	
	x_target = x_set(t_Nr,:);
	q_target = x_target(1:numel(x_target)/2);
	q_target = q_target';
	
	plot_Mechanism_CBBTC_CEMDT(q_target,ModelParameter,SubFigureObj);
end
title([SubFigureTitle{BeamTypeNr,SegmentSetNr}, ...
	' K=',num2str(AppliedMomentQuantity/10*100),'%']);
hold off;
end
%%
function plot_Mechanism_CBBTC_CEMDT(q,ModelParameter,SubFigureObj)
%%
BodyElementParameter = ModelParameter.BodyElementParameter;
Joint_Parameter = ModelParameter.Joint_Parameter;
PlotParameter = ModelParameter.PlotParameter;

BodyQuantity = numel(BodyElementParameter);
%%
for BodyNr = 1:BodyQuantity
	
	m = BodyElementParameter{BodyNr}.Coordinate;
	if ~isnumeric(m)
		m = BodyElementParameter{BodyNr}.GlobalCoordinate;
	end
	qe = q(m);
	dqe = zeros(numel(qe),1);
	PlotStyle = PlotParameter{BodyNr}.PlotStyle;
	switch BodyElementParameter{BodyNr}.BodyType
		case 'Rigid Body'
			Joint = set_Joint(...
				qe,dqe,BodyElementParameter,BodyNr,Joint_Parameter);
			PlotSequence = PlotParameter{BodyNr}.PlotSequence;
			
			plot_RigidBody(Joint,PlotSequence,PlotStyle,SubFigureObj);
		case 'Timoshenko Beam'
			InterpolationNr = PlotParameter{BodyNr}.InterpolationNr;
			BodyParameter = PlotParameter{BodyNr}.BodyParameter;
			
			plot_TimoshenkoBeam(qe, ...
				InterpolationNr,BodyParameter,PlotStyle,SubFigureObj);
		case 'Strut Tie Model'
			plot_StrutTieModel(qe,PlotStyle,SubFigureObj);
		case 'Strut Tie Rope Model'
			plot_StrutTieModel(qe,PlotStyle,SubFigureObj);
		case 'Super Truss Element'
			InterpolationNr = PlotParameter{BodyNr}.InterpolationNr;
			Truss_Parameter = PlotParameter{BodyNr}.Truss_Parameter;
			
			plot_SuperTrussElement(qe, ...
				InterpolationNr,Truss_Parameter,PlotStyle,SubFigureObj);
		case 'Cubic Spline Beam'
			InterpolationNr = PlotParameter{BodyNr}.InterpolationNr;
			BodyParameter = PlotParameter{BodyNr}.BodyParameter;
			
			plot_CubicSplineBeam(qe, ...
				InterpolationNr,BodyParameter,PlotStyle,SubFigureObj);
		case 'Cubic Spline Rope'
			InterpolationNr = PlotParameter{BodyNr}.InterpolationNr;
			BodyParameter = PlotParameter{BodyNr}.BodyParameter;
			
			plot_CubicSplineBeam(qe, ...
				InterpolationNr,BodyParameter,PlotStyle,SubFigureObj);
	end
end
%%
axis([-5,20,-12.5,12.5,-5,20]);
view(0,0);%x-z
grid on;
end
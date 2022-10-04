%% ========== PostProcessing_FBS_CFDT ===========
%% PostProcessing
%% Folding Boom System(FBS)
%% Constant Force Drive Test(CFDT)
%% ==============================================
clear;close all;clc;
num_Result = 0;
%%
% ResultParentFolderName = ...
% 	['Result\Folding Boom System\Constant Force Drive\', ...
% 	'RelTol=0.01 AbsTol=0.01\'];
ResultParentFolderName = ...
	['Result\Folding Boom System\Constant Force Drive\', ...
	'RelTol=0.0001 AbsTol=0.0001\'];
%%
% Rigid
num_Result = num_Result + 1;
FlexibleBodyTypeFolderNameBase_set{num_Result} = ...
	'Rigid';
% Timoshenko - 1 Segments
num_Result = num_Result + 1;
FlexibleBodyTypeFolderNameBase_set{num_Result} = ...
	'Timoshenko - 1 Segments';
% Timoshenko - 3 Segments
num_Result = num_Result + 1;
FlexibleBodyTypeFolderNameBase_set{num_Result} = ...
	'Timoshenko - 3 Segments';
% Timoshenko - 5 Segments
num_Result = num_Result + 1;
FlexibleBodyTypeFolderNameBase_set{num_Result} = ...
	'Timoshenko - 5 Segments';
% Cubic Spline - 1 Segments
num_Result = num_Result + 1;
FlexibleBodyTypeFolderNameBase_set{num_Result} = ...
	'Cubic Spline - 1 Segments';
% Cubic Spline - 3 Segments
num_Result = num_Result + 1;
FlexibleBodyTypeFolderNameBase_set{num_Result} = ...
	'Cubic Spline - 3 Segments';
% Cubic Spline - 3 Segments
num_Result = num_Result + 1;
FlexibleBodyTypeFolderNameBase_set{num_Result} = ...
	'Cubic Spline - 5 Segments';
%%
Figure_FBS_CFDT = figure('Name','Figure_FBS_CFDT');
SubFigure_FBS_CFDT = cell(2,3);
SubFigure_FBS_CFDT{1,1} = subplot(2,3,1);
SubFigure_FBS_CFDT{1,2} = subplot(2,3,2);
SubFigure_FBS_CFDT{1,3} = subplot(2,3,3);
SubFigure_FBS_CFDT{2,1} = subplot(2,3,4);
SubFigure_FBS_CFDT{2,2} = subplot(2,3,5);
SubFigure_FBS_CFDT{2,3} = subplot(2,3,6);
%
SubFigureTitle{1,1} = 'X';
SubFigureTitle{1,2} = 'Y';
SubFigureTitle{1,3} = 'Z';

SubFigureTitle{2,1} = 'dXdt';
SubFigureTitle{2,2} = 'dYdt';
SubFigureTitle{2,3} = 'dZdt';
%
for SubFigureNr = 1:numel(SubFigure_FBS_CFDT)
	hold(SubFigure_FBS_CFDT{SubFigureNr},'on');
end
%%
PlotStyleSet = cell(num_Result,1);
PlotStyleSet{1} = 'k-';
PlotStyleSet{2} = 'b-';
PlotStyleSet{3} = 'b--';
PlotStyleSet{4} = 'b:';
PlotStyleSet{5} = 'r-';
PlotStyleSet{6} = 'r--';
PlotStyleSet{7} = 'r:';
%%
for ResultFolderNr = 1:num_Result
	FlexibleBodyTypeFolderNameBase = ...
		FlexibleBodyTypeFolderNameBase_set{ResultFolderNr};
	PlotStyle = PlotStyleSet{ResultFolderNr};
	PostProcessing_FBS_CFDT_PlotFunc(...
		ResultParentFolderName,FlexibleBodyTypeFolderNameBase, ...
		SubFigure_FBS_CFDT,PlotStyle);
end
%%
for SubFigureNr = 1:numel(SubFigure_FBS_CFDT)
	hold(SubFigure_FBS_CFDT{SubFigureNr},'off');
	legend(SubFigure_FBS_CFDT{SubFigureNr}, ...
		FlexibleBodyTypeFolderNameBase_set, ...
		'Location','best');
	title(SubFigure_FBS_CFDT{SubFigureNr},SubFigureTitle{SubFigureNr});
end
%%
function PostProcessing_FBS_CFDT_PlotFunc(...
	ResultParentFolderName,FlexibleBodyTypeFolderNameBase, ...
	SubFigure_FBS_CFDT,PlotStyle)
ResultFileName = ...
	[ResultParentFolderName, ...
	'Folding Boom - ', ...
	FlexibleBodyTypeFolderNameBase, ...
	'\Parameter.mat'];
ExperimentData = load(ResultFileName);


x_set = ExperimentData.x_set;
t_set = ExperimentData.t_set;
ModelParameter = ExperimentData.ModelParameter;
BodyElementParameter = ModelParameter.BodyElementParameter;
Joint_Parameter = ModelParameter.Joint_Parameter;
g = ModelParameter.g;
%%
r_set = zeros(3,numel(t_set));
drdt_set = zeros(3,numel(t_set));
%%
if contains(FlexibleBodyTypeFolderNameBase,'3 Segments')
	BodyNr = 17;
elseif contains(FlexibleBodyTypeFolderNameBase,'5 Segments')
	BodyNr = 23;
else
	BodyNr = 7;
end
%%
for TimeNr = 1:numel(t_set)
	x = x_set(TimeNr,:)';
	q = x(1:numel(x)/2);
	dq = x(numel(x)/2+1:end);
	%%
	BodyCoordinate = BodyElementParameter{BodyNr}.Coordinate;
	
	qe  = q(BodyCoordinate);
	dqe = dq(BodyCoordinate);
	%%
	Joint = set_Joint(...
		qe,dqe,BodyElementParameter,BodyNr,Joint_Parameter);
	%%
	r_set(:,TimeNr) = Joint{2}.r;
	drdt_set(:,TimeNr) = Joint{2}.dr;
end
%%
plot_x = r_set(1,:);
plot_y = r_set(2,:);
plot_z = r_set(3,:);

plot_dxdt = drdt_set(1,:);
plot_dydt = drdt_set(2,:);
plot_dzdt = drdt_set(3,:);
%%
plot(SubFigure_FBS_CFDT{1,1},t_set,plot_x,PlotStyle);
plot(SubFigure_FBS_CFDT{1,2},t_set,plot_y,PlotStyle);
plot(SubFigure_FBS_CFDT{1,3},t_set,plot_z,PlotStyle);

plot(SubFigure_FBS_CFDT{2,1},t_set,plot_dxdt,PlotStyle);
plot(SubFigure_FBS_CFDT{2,2},t_set,plot_dydt,PlotStyle);
plot(SubFigure_FBS_CFDT{2,3},t_set,plot_dzdt,PlotStyle);
end


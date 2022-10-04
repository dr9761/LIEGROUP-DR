%% =========== PostProcessing_SLBT_VSG ===========
%% PostProcessing
%% Single Long Beam Test(SLBT)
%% Viberation under Self-Gravity(VSG)
%% ===============================================
clear;close all;clc;
%%
ResultParentFolderName = ...
	['Result\', ...
	'Flexible Cantilever Beam Self Gravity Vibration\'];
%%
PostProcessing_SLBCT_NCAD_PlotFunc(ResultParentFolderName);
%%
function PostProcessing_SLBCT_NCAD_PlotFunc(...
	ResultParentFolderName)
ResultFolderNameSet = cell(8,1);
%
ResultFolderNameSet{1} = ...
	'Timoshenko Beam - 1 Segments';
ResultFolderNameSet{2} = ...
	'Timoshenko Beam - 3 Segments';
ResultFolderNameSet{3} = ...
	'Timoshenko Beam - 5 Segments';
ResultFolderNameSet{4} = ...
	'Timoshenko Beam - 10 Segments';
%
ResultFolderNameSet{5} = ...
	'Cubic Spline Beam - 1 Segments';
ResultFolderNameSet{6} = ...
	'Cubic Spline Beam - 3 Segments';
ResultFolderNameSet{7} = ...
	'Cubic Spline Beam - 5 Segments';
ResultFolderNameSet{8} = ...
	'Cubic Spline Beam - 10 Segments';
%%
PlotFormat = cell(8,1);
%
PlotFormat{1} = 'r-';
PlotFormat{2} = 'r:';
PlotFormat{3} = 'r-.';
PlotFormat{4} = 'r--';
%
PlotFormat{5} = 'b-';
PlotFormat{6} = 'b:';
PlotFormat{7} = 'b-.';
PlotFormat{8} = 'b--';
%%
FigureObj = figure('Name','Viberation under Self-Gravity');
AxisObj = axes(FigureObj);
title(AxisObj,'z_{end}');
hold(AxisObj,'on');
%%
ResultData = cell(numel(ResultFolderNameSet),1);
for ResultFolderNr = 1:numel(ResultFolderNameSet)
	ResultFolderName = [ResultParentFolderName, ...
		ResultFolderNameSet{ResultFolderNr}];
	
	ResultData{ResultFolderNr} = load(...
		[ResultFolderName,'\Result.mat'],'x_set','t_set');
	x_set = ResultData{ResultFolderNr}.x_set;
	t_set = ResultData{ResultFolderNr}.t_set;
	x_set = x_set(t_set<5,:);
	t_set = t_set(t_set<5);
	q_set = x_set(:,1:size(x_set,2)/2);
	if ResultFolderNr <= 4
		z_end_set = q_set(:,end-3);
	else
		z_end_set = q_set(:,end-4);
	end

	plot(AxisObj,t_set,z_end_set,PlotFormat{ResultFolderNr});
	
end
legend(AxisObj, ...
	'T-Beam 1 Seg','T-Beam 3 Seg','T-Beam 5 Seg','T-Beam 10Seg', ...
	'S-Beam 1 Seg','S-Beam 3 Seg','S-Beam 5 Seg','S-Beam 10Seg', ...
	'Location','eastoutside');
hold(AxisObj,'off');
xlabel(AxisObj,'Time');
grid(AxisObj,'on');
grid(AxisObj,'MINOR');
ylabel(AxisObj,'z_{end}');
end
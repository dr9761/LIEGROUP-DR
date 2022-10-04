%% ========== PostProcessing_SLBCT_3SAD ==========
%% PostProcessing
%% Single Long Beam Controlled Test(SLBCT)
%% 3 Stage Angle Drive(3SAD)
%% ===============================================
clear;close all;clc;
%%
ResultParentFolderName{1} = ...
	['Result\', ...
	'Single Long Beam Controlled Pendulum Test\', ...
	'3-Stage Angle Drive\', ...
	'RelTol=0.01 AbsTol=0.01\'];
ResultParentFolderName{2} = ...
	['Result\', ...
	'Single Long Beam Controlled Pendulum Test\', ...
	'3-Stage Angle Drive\', ...
	'RelTol=0.0001 AbsTol=0.0001\'];
FigureName{1} = 'RelTol=0.01 AbsTol=0.01';
FigureName{2} = 'RelTol=0.0001 AbsTol=0.0001';
%%
for FigureNr = 1:2
	PostProcessing_SLBCT_3SAD_PlotFunc(...
		ResultParentFolderName{FigureNr}, ...
		FigureName{FigureNr});
end
%%
function PostProcessing_SLBCT_3SAD_PlotFunc(...
	ResultParentFolderName,FigureName)
ResultFolderNameSet{1} = ...
	'Rigid Beam Pendulum Angle Drive';
%
ResultFolderNameSet{2} = ...
	'Timoshenko Beam Pendulum Angle Drive - 1 Segments';
ResultFolderNameSet{3} = ...
	'Timoshenko Beam Pendulum Angle Drive - 3 Segments';
ResultFolderNameSet{4} = ...
	'Timoshenko Beam Pendulum Angle Drive - 5 Segments';
ResultFolderNameSet{5} = ...
	'Timoshenko Beam Pendulum Angle Drive - 10 Segments';
%
ResultFolderNameSet{6} = ...
	'Cubic Spline Beam Pendulum Angle Drive - 1 Segments';
ResultFolderNameSet{7} = ...
	'Cubic Spline Beam Pendulum Angle Drive - 3 Segments';
ResultFolderNameSet{8} = ...
	'Cubic Spline Beam Pendulum Angle Drive - 5 Segments';
ResultFolderNameSet{9} = ...
	'Cubic Spline Beam Pendulum Angle Drive - 10 Segments';
%%
PlotFormat{1} = 'k-';
%
PlotFormat{2} = 'r-';
PlotFormat{3} = 'r:';
PlotFormat{4} = 'r-.';
PlotFormat{5} = 'r--';
%
PlotFormat{6} = 'b-';
PlotFormat{7} = 'b:';
PlotFormat{8} = 'b-.';
PlotFormat{9} = 'b--';
%%
FigureObj = figure('Name',FigureName);
AxisObj{1,1} = subplot(2,1,1);title(AxisObj{1,1},'x_{end}');
AxisObj{1,2} = subplot(2,1,2);title(AxisObj{1,2},'z_{end}');
%%
ResultData1 = cell(numel(ResultFolderNameSet),1);
for AxisNr = 1:numel(AxisObj)
	hold(AxisObj{AxisNr},'on');
end
for ResultFolderNr = 1:numel(ResultFolderNameSet)
	ResultFolderName = [ResultParentFolderName, ...
		ResultFolderNameSet{ResultFolderNr}];
	
	ResultData1{ResultFolderNr} = load(...
		[ResultFolderName,'\Result.mat']);
	x_set = ResultData1{ResultFolderNr}.x_set;
	t_set = ResultData1{ResultFolderNr}.t_set;
	q_set = x_set(:,1:size(x_set,2)/2);
	if ResultFolderNr == 1
		x_end = [];z_end = [];
		for tNr = 1:numel(t_set)
			r_0 = q_set(tNr,1:3)';
			phi = q_set(tNr,4:6)';
			r_end = r_0 + get_R(phi)*[15;0;0];
			
			x_end = [x_end,r_end(1)];
			z_end = [z_end,r_end(3)];
		end
	elseif ResultFolderNr < 6
		x_end = q_set(:,end-5);
		z_end = q_set(:,end-3);
	else
		x_end = q_set(:,end-6);
		z_end = q_set(:,end-4);
	end
	plot(AxisObj{1,1},t_set,x_end,PlotFormat{ResultFolderNr});
	plot(AxisObj{1,2},t_set,z_end,PlotFormat{ResultFolderNr});
end
for AxisNr = 1:numel(AxisObj)
	legend(AxisObj{AxisNr},...
		'Rigid', ...
		'T-Beam 1 Seg','T-Beam 3 Seg','T-Beam 5 Seg','T-Beam 10Seg', ...
		'S-Beam 1 Seg','S-Beam 3 Seg','S-Beam 5 Seg','S-Beam 10Seg', ...
		'Location','eastoutside');
	hold(AxisObj{AxisNr},'off');
	xlabel(AxisObj{AxisNr},'Time');
	grid(AxisObj{AxisNr},'on');
	grid(AxisObj{AxisNr},'MINOR');
end
ylabel(AxisObj{1},'x_{end}');
ylabel(AxisObj{2},'z_{end}');
end
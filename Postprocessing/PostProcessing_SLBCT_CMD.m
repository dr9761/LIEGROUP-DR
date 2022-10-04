%% ========== PostProcessing_SLBCT_CMD ==========
%% PostProcessing
%% Single Long Beam Controlled Test(SLBCT)
%% Constant Moment Drive(CMD)
%% ==============================================
clear;close all;clc;
%%
ResultParentFolderName{1} = ...
	['Result\', ...
	'Single Long Beam Controlled Pendulum Test\', ...
	'Constant Moment Drive\', ...
	'RelTol=0.01 AbsTol=0.01\'];
ResultParentFolderName{2} = ...
	['Result\', ...
	'Single Long Beam Controlled Pendulum Test\', ...
	'Constant Moment Drive\', ...
	'RelTol=0.0001 AbsTol=0.0001\'];
FigureNr{1} = 1;
FigureNr{2} = 2;
%%
PostProcessing_SLBCT_CMD_PlotFunc(...
	ResultParentFolderName{1},FigureNr{1});
PostProcessing_SLBCT_CMD_PlotFunc(...
	ResultParentFolderName{2},FigureNr{2});
%%
function PostProcessing_SLBCT_CMD_PlotFunc(...
	ResultParentFolderName,FigureNr)
ResultFolderNameSet2{1} = ...
	'Rigid Beam Pendulum Axis Drive';
%
ResultFolderNameSet2{2} = ...
	'Timoshenko Beam Pendulum Axis Drive - 1 Segments';
ResultFolderNameSet2{3} = ...
	'Timoshenko Beam Pendulum Axis Drive - 3 Segments';
ResultFolderNameSet2{4} = ...
	'Timoshenko Beam Pendulum Axis Drive - 5 Segments';
ResultFolderNameSet2{5} = ...
	'Timoshenko Beam Pendulum Axis Drive - 10 Segments';
%
ResultFolderNameSet2{6} = ...
	'Cubic Spline Beam Pendulum Axis Drive - 1 Segments';
ResultFolderNameSet2{7} = ...
	'Cubic Spline Beam Pendulum Axis Drive - 3 Segments';
ResultFolderNameSet2{8} = ...
	'Cubic Spline Beam Pendulum Axis Drive - 5 Segments';
ResultFolderNameSet2{9} = ...
	'Cubic Spline Beam Pendulum Axis Drive - 10 Segments';
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
FigureObj = figure(FigureNr);
AxisObj{1,1} = subplot(2,1,1,'Parent',FigureObj);title(AxisObj{1,1},'x_{end}');
AxisObj{1,2} = subplot(2,1,2,'Parent',FigureObj);title(AxisObj{1,2},'z_{end}');
% AxisObj{2,1} = subplot(2,2,3,'Parent',FigureObj);title(AxisObj{2,1},'phiy_0');
% AxisObj{2,2} = subplot(2,2,4,'Parent',FigureObj);title(AxisObj{2,2},'phiy_end');
%%
ResultData2 = cell(numel(ResultFolderNameSet2),1);
for AxisNr = 1:numel(AxisObj)
	hold(AxisObj{AxisNr},'on');
end
for ResultFolderNr = 1:numel(ResultFolderNameSet2)
	ResultFolderName = [ResultParentFolderName, ...
		ResultFolderNameSet2{ResultFolderNr}];
	
	ResultData2{ResultFolderNr} = load(...
		[ResultFolderName,'\Result.mat']);
	x_set = ResultData2{ResultFolderNr}.x_set;
	t_set = ResultData2{ResultFolderNr}.t_set;
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
		phiy_0 = q_set(:,end-1);
		phiy_end = phiy_0;
	elseif ResultFolderNr < 6
		x_end = q_set(:,end-5);
		z_end = q_set(:,end-3);
		phiy_0 = q_set(:,5);
		phiy_end = q_set(:,end-1);
	else
		x_end = q_set(:,end-6);
		z_end = q_set(:,end-4);
		phiy_0 = q_set(:,5);
		phiy_end = q_set(:,end-2);
	end
	plot(AxisObj{1,1}, ...
		t_set,x_end,PlotFormat{ResultFolderNr});
	plot(AxisObj{1,2}, ...
		t_set,z_end,PlotFormat{ResultFolderNr});
% 	plot(AxisObj{2,1}, ...
% 		t_set,phiy_0,PlotFormat{ResultFolderNr});
% 	plot(AxisObj{2,2}, ...
% 		t_set,phiy_end,PlotFormat{ResultFolderNr});
end
for AxisNr = 1:2%numel(AxisObj)
	legend(AxisObj{AxisNr},...
		'Rigid', ...
		'T-Beam1','T-Beam3','T-Beam5','T-Beam10', ...
		'S-Beam1','S-Beam3','S-Beam5','S-Beam10', ...
		'Location','eastoutside');
	hold(AxisObj{AxisNr},'off');
	xlabel(AxisObj{AxisNr},'Time');
	grid(AxisObj{AxisNr},'on');
	grid(AxisObj{AxisNr},'MINOR');
end
ylabel(AxisObj{1},'x_{end}');
ylabel(AxisObj{2},'z_{end}');
end
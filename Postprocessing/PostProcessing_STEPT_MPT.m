%% ========== PostProcessing_STEPT_MPT =============
%% PostProcessing
%% Super Truss Element Parameter Test(STEPT)
%% Mass Parameter Test(MPT)
%% =================================================
clear;clc;close all;
% ExperimentNameSet = {...
% 	'Translation_x';'Translation_y';'Translation_z';
% 	'Rotation_x';'Rotation_y';'Rotation_z'};
% ResultNameSet = {...
% 	'Force_x';'Force_y';'Force_z';
% 	'Moment_x';'Moment_y';'Moment_z'};
% ValidTestRatioSet = [...
% 	1.0,	0.02,	0.2,	0.1,	0.1,	0.1;
% 	1.0,	0.2,	0.7,	1.0,	1.0,	0.1;
% 	1.0,	0.1,	1.0,	1.0,	1.0,	0.1;
% 	1.0,	0.3,	0.8,	0.3,	1.0,	0.1;
% 	1.0,	0.05,	0.7,	1.0,	1.0,	0.1];
%
ExperimentNameSet = {...
	'Translation_x';
	'Rotation_x';'Rotation_y';'Rotation_z'};
ResultNameSet = {...
	'Force_x';
	'Moment_x';'Moment_y';'Moment_z'};
ResultParentFolderName = 'Result\Truss Dynamic Test\';
ValidTestRatioSet = [...
	1.0,	0.01,	0.1,	0.1;
	1.0,	1.0,	0.3,	0.25;
	1.0,	0.02,	0.2,	0.3;
	1.0,	0.1,	0.2,	0.3;
	1.0,	1.0,	0.4,	0.4;
	1.0,	1.0,	1.0,	1.0];
TrussTypeQuantity = 6;
%%
TrussParameter = cell(TrussTypeQuantity,1);
TrussFigure = cell(TrussTypeQuantity,1);
%%
for TrussTypeNr = 1:TrussTypeQuantity
% for TrussTypeNr = 2:2
	TrussTypeName = ['Type ',num2str(TrussTypeNr)];
	%
	TrussFigure{TrussTypeNr}.FigureObj = figure('Name',TrussTypeName);
	%
	TrussFigure{TrussTypeNr}.Translation_x = ...
		subplot(2,2,1,'Parent',TrussFigure{TrussTypeNr}.FigureObj);
% 	TrussFigure{TrussTypeNr}.Translation_y = ...
% 		subplot(2,3,2,'Parent',TrussFigure{TrussTypeNr}.FigureObj);
% 	TrussFigure{TrussTypeNr}.Translation_z = ...
% 		subplot(2,3,3,'Parent',TrussFigure{TrussTypeNr}.FigureObj);
	%
	TrussFigure{TrussTypeNr}.Rotation_x = ...
		subplot(2,2,2,'Parent',TrussFigure{TrussTypeNr}.FigureObj);
	TrussFigure{TrussTypeNr}.Rotation_y = ...
		subplot(2,2,3,'Parent',TrussFigure{TrussTypeNr}.FigureObj);
	TrussFigure{TrussTypeNr}.Rotation_z = ...
		subplot(2,2,4,'Parent',TrussFigure{TrussTypeNr}.FigureObj);
	%%
	ExcelFileName = ...
		['Lattice ',TrussTypeName,' Mass'];
	ExcelFileDir = [...
		'Parameter File', ...
		'\Lattice boom crane model\Lattice Parameterization'];
	[ModelParameter,SolverParameter] = ...
		Set_AllParameter_from_ExcelFile(ExcelFileName,ExcelFileDir);
	for ExperimentNr = 1:numel(ExperimentNameSet)
		%%
		ExperimentName = ExperimentNameSet{ExperimentNr};
		SolverParameter.ActionFunction = ...
			@(t,x,tspan,ModelParameter)get_Action_Truss_Dynamics_Test(...
			t,x,tspan,ModelParameter,ExperimentName);
		x0 = ModelParameter.InitialState.x0;
		tspan = [0;1];
		Action = get_Action_Truss_Dynamics_Test(...
			0,x0,tspan,ModelParameter,ExperimentName);
		dx = Multi_Body_Dynamics_func(...
			0,x0,tspan,ModelParameter,SolverParameter,[]);
		
		ResultName = ResultNameSet{ExperimentNr};
		ResultFolderName = ...
			[ResultParentFolderName,TrussTypeName,'\',ResultName,'\'];
		ResultData = load([ResultFolderName,'Result.mat']);
		t_set = ResultData.t_set;
		
		%%
		switch ExperimentName
			case 'Translation_x'
				ValidTestRatio = ...
					ValidTestRatioSet(TrussTypeNr,ExperimentNr);
				ValidTestNr = floor(ValidTestRatio*numel(t_set));
				t_set = t_set(1:ValidTestNr);
				x_set = ResultData.x_set(1:ValidTestNr,:);
				
				drx1_set = x_set(:,13);
				drx2_set = x_set(:,19);
				
				plot(TrussFigure{TrussTypeNr}.Translation_x, ...
					t_set,[drx1_set,drx2_set]);
				title(TrussFigure{TrussTypeNr}.Translation_x, ...
					'Translation-x');
				xlabel(TrussFigure{TrussTypeNr}.Translation_x, ...
					'Time');
				ylabel(TrussFigure{TrussTypeNr}.Translation_x, ...
					'v_x');
				
				Acceleration_x = ...
					polyfit(t_set,1/2*(drx1_set+drx2_set),1);
				Acceleration_x = Acceleration_x(1);
% 				Acceleration_x = sum(dx([13,19]))/2;
				m_tot_x = Action(1) / Acceleration_x;
				L = x_set(1,7)-x_set(1,1);
				k = dx(13) / dx(19);
				a = 4/(L^2)*(k-1)/(k+1)*m_tot_x;
				b = -1/L*(k-3)/(k+1)*m_tot_x;
				lambda_x_polyfunc = [a,b];
% 			case 'Translation_y'
% 				ValidTestRatio = ...
% 					ValidTestRatioSet(TrussTypeNr,ExperimentNr);
% 				ValidTestNr = floor(ValidTestRatio*numel(t_set));
% 				t_set = t_set(1:ValidTestNr);
% 				x_set = ResultData.x_set(1:ValidTestNr,:);
% 				
% 				dry1_set = x_set(:,14);
% 				dry2_set = x_set(:,20);
% 				plot(TrussFigure{TrussTypeNr}.Translation_y, ...
% 					t_set,[dry1_set,dry2_set]);
% 				Acceleration_x = ...
% 					polyfit(t_set,1/2*(drx1_set+drx2_set),1);
% 				Acceleration_x = Acceleration_x(1);
% % 				Acceleration_y = sum(dx([14,20]))/2;
% 				k = dx(14) / dx(20);
% 				
% 				m_tot_y = Action(2) / Acceleration_y;
% 				L = x_set(1,7)-x_set(1,1);
% 				a = 4/(L^2)*(k-1)/(k+1)*m_tot_y;
% 				b = -1/L*(k-3)/(k+1)*m_tot_y;
% 				lambda_y_polyfunc = [a,b];
% 			case 'Translation_z'
% 				Acceleration_z = sum(dx([15,21]))/2;
% 				k = dx(15) / dx(21);
% 				
% 				m_tot_z = Action(3) / Acceleration_z;
% 				L = x_set(1,7)-x_set(1,1);
% 				a = 4/(L^2)*(k-1)/(k+1)*m_tot_z;
% 				b = -1/L*(k-3)/(k+1)*m_tot_z;
% 				lambda_z_polyfunc = [a,b];
			case 'Rotation_x'
				ValidTestRatio = ...
					ValidTestRatioSet(TrussTypeNr,ExperimentNr);
				ValidTestNr = floor(ValidTestRatio*numel(t_set));
				t_set = t_set(1:ValidTestNr);
				x_set = ResultData.x_set(1:ValidTestNr,:);
				
				omega1_x_set = x_set(:,16);
				omega2_x_set = x_set(:,22);
				
				plot(TrussFigure{TrussTypeNr}.Rotation_x, ...
					t_set,[omega1_x_set,omega2_x_set]);
				title(TrussFigure{TrussTypeNr}.Rotation_x, ...
					'Rotation-x');
				xlabel(TrussFigure{TrussTypeNr}.Rotation_x, ...
					'Time');
				ylabel(TrussFigure{TrussTypeNr}.Rotation_x, ...
					'\omega_x');
				
				AnggularAcceleration_x = ...
					polyfit(t_set,1/2*(omega1_x_set+omega2_x_set),1);
				AnggularAcceleration_x = AnggularAcceleration_x(1);
				
% 				AnggularAcceleration_x = sum(dx([16,22]))/2;
				k = sqrt(dx(16) / dx(22));
				rhoJ_tot_x = Action(4) / AnggularAcceleration_x;
				L = x_set(1,7)-x_set(1,1);
				a = 4/(L^2)*(k-1)/(k+1)*rhoJ_tot_x;
				b = -1/L*(k-3)/(k+1)*rhoJ_tot_x;
				rhoJ_x_polyfunc = [a,b];
			case 'Rotation_y'
				ValidTestRatio = ...
					ValidTestRatioSet(TrussTypeNr,ExperimentNr);
				ValidTestNr = floor(ValidTestRatio*numel(t_set));
				t_set = t_set(1:ValidTestNr);
				x_set = ResultData.x_set(1:ValidTestNr,:);
				
				omega1_y_set = x_set(:,17);
				omega2_y_set = x_set(:,23);
				
				plot(TrussFigure{TrussTypeNr}.Rotation_y, ...
					t_set,[omega1_y_set,omega2_y_set]);
				title(TrussFigure{TrussTypeNr}.Rotation_y, ...
					'Rotation-y');
				xlabel(TrussFigure{TrussTypeNr}.Rotation_y, ...
					'Time');
				ylabel(TrussFigure{TrussTypeNr}.Rotation_y, ...
					'\omega_y');
				
				AnggularAcceleration_y = ...
					polyfit(t_set,1/2*(omega1_y_set+omega2_y_set),1);
				AnggularAcceleration_y = AnggularAcceleration_y(1);
% 				AnggularAcceleration_y = sum(dx([17,23]))/2;

				k = sqrt(dx(17) / dx(23));
				rhoJ_tot_y = Action(5) / AnggularAcceleration_y;
				L = x_set(1,7)-x_set(1,1);
				a = 4/(L^2)*(k-1)/(k+1)*rhoJ_tot_y;
				b = -1/L*(k-3)/(k+1)*rhoJ_tot_y;
				rhoJ_y_polyfunc = [a,b];
			case 'Rotation_z'
				ValidTestRatio = ...
					ValidTestRatioSet(TrussTypeNr,ExperimentNr);
				ValidTestNr = floor(ValidTestRatio*numel(t_set));
				t_set = t_set(1:ValidTestNr);
				x_set = ResultData.x_set(1:ValidTestNr,:);
				
				omega1_z_set = x_set(:,18);
				omega2_z_set = x_set(:,24);
				
				plot(TrussFigure{TrussTypeNr}.Rotation_z, ...
					t_set,[omega1_z_set,omega2_z_set]);
				title(TrussFigure{TrussTypeNr}.Rotation_z, ...
					'Rotation-z');
				xlabel(TrussFigure{TrussTypeNr}.Rotation_z, ...
					'Time');
				ylabel(TrussFigure{TrussTypeNr}.Rotation_z, ...
					'\omega_z');
				
				AnggularAcceleration_z = ...
					polyfit(t_set,1/2*(omega1_z_set+omega2_z_set),1);
				AnggularAcceleration_z = AnggularAcceleration_z(1);
% 				AnggularAcceleration_z = sum(dx([18,24]))/2;

				k = sqrt(dx(18) / dx(24));
				rhoJ_tot_z = Action(6) / AnggularAcceleration_z;
				L = x_set(1,7)-x_set(1,1);
				a = 4/(L^2)*(k-1)/(k+1)*rhoJ_tot_z;
				b = -1/L*(k-3)/(k+1)*rhoJ_tot_z;
				rhoJ_z_polyfunc = [a,b];
			otherwise
				error('No Experiment exist!\n');
		end
	end
	TrussParameter{TrussTypeNr}.lambda_x_polyfunc = lambda_x_polyfunc;
% 	TrussParameter{TrussTypeNr}.lambda_y_polyfunc = lambda_y_polyfunc;
% 	TrussParameter{TrussTypeNr}.lambda_z_polyfunc = lambda_z_polyfunc;
	TrussParameter{TrussTypeNr}.rhoJ_x_polyfunc = rhoJ_x_polyfunc;
	TrussParameter{TrussTypeNr}.rhoJ_y_polyfunc = rhoJ_y_polyfunc;
	TrussParameter{TrussTypeNr}.rhoJ_z_polyfunc = rhoJ_z_polyfunc;
	% 	close all;
	% 	[EA_Stretch,EA_Compression,GIyIz,EIy,EIz]
end
save('TrussEquivalentDynamicParameter.mat','TrussParameter');
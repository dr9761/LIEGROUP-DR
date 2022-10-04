%% ========== PostProcessing_STEPT_SPT =============
%% PostProcessing
%% Super Truss Element Parameter Test(STEPT)
%% Stiffness Parameter Test(SPT)
%% =================================================
clear;clc;close all;
ExperimentNameSet = {...
	'Axial Stretch';
	'Axial Compression';
	'x-Axis Twist';
	'y-Axis Bending';
	'z-Axis Bending'};
ResultParentFolderName = 'Result\Truss Parameter Test\';
ValidTestRatioSet = [...
	1.0,	0.9,	0.2,	0.8,	1.0;
	1.0,	0.2,	0.7,	1.0,	1.0;
	1.0,	0.1,	1.0,	1.0,	1.0;
	1.0,	0.3,	0.8,	0.3,	1.0;
	1.0,	0.05,	0.7,	1.0,	1.0;
	1.0,	0.005,	1.0,	1.0,	1.0;];
TrussTypeQuantity = 6;
%%
TrussParameter = cell(TrussTypeQuantity,1);
TrussFigure = cell(TrussTypeQuantity,1);
%%
% for TrussTypeNr = 1:TrussTypeQuantity
for TrussTypeNr = 2:2
	TrussTypeName = ['Type ',num2str(TrussTypeNr)];
	%
	TrussFigure{TrussTypeNr}.FigureObj = figure('Name',TrussTypeName);
	TrussFigure{TrussTypeNr}.AxesObj_AxialStretch = ...
		subplot(3,2,1,'Parent',TrussFigure{TrussTypeNr}.FigureObj);
	TrussFigure{TrussTypeNr}.AxesObj_AxialCompression = ...
		subplot(3,2,2,'Parent',TrussFigure{TrussTypeNr}.FigureObj);
	TrussFigure{TrussTypeNr}.AxesObj_xAxisTwist = ...
		subplot(3,2,3,'Parent',TrussFigure{TrussTypeNr}.FigureObj);
	TrussFigure{TrussTypeNr}.AxesObj_xAxisTwist2 = ...
		subplot(3,2,4,'Parent',TrussFigure{TrussTypeNr}.FigureObj);
	TrussFigure{TrussTypeNr}.AxesObj_yAxisBending = ...
		subplot(3,2,5,'Parent',TrussFigure{TrussTypeNr}.FigureObj);
	TrussFigure{TrussTypeNr}.AxesObj_zAxisBending = ...
		subplot(3,2,6,'Parent',TrussFigure{TrussTypeNr}.FigureObj);
	%
	TrussStateFigure{TrussTypeNr}.FigureObj = figure('Name',[TrussTypeName,' Final State']);
	TrussStateFigure{TrussTypeNr}.AxesObj_AxialStretch = ...
		subplot(3,2,1,'Parent',TrussStateFigure{TrussTypeNr}.FigureObj);
	TrussStateFigure{TrussTypeNr}.AxesObj_AxialCompression = ...
		subplot(3,2,2,'Parent',TrussStateFigure{TrussTypeNr}.FigureObj);
	TrussStateFigure{TrussTypeNr}.AxesObj_xAxisTwist = ...
		subplot(3,2,3,'Parent',TrussStateFigure{TrussTypeNr}.FigureObj);
	TrussStateFigure{TrussTypeNr}.AxesObj_xAxisTwist2 = ...
		subplot(3,2,4,'Parent',TrussStateFigure{TrussTypeNr}.FigureObj);
	TrussStateFigure{TrussTypeNr}.AxesObj_yAxisBending = ...
		subplot(3,2,5,'Parent',TrussStateFigure{TrussTypeNr}.FigureObj);
	TrussStateFigure{TrussTypeNr}.AxesObj_zAxisBending = ...
		subplot(3,2,6,'Parent',TrussStateFigure{TrussTypeNr}.FigureObj);
	%%
	ExcelFileName = ...
		['Lattice ',TrussTypeName,' Stiffness'];
	ExcelFileDir = [...
		'Parameter File', ...
		'\Lattice boom crane model\Lattice Parameterization'];
	[ModelParameter,SolverParameter] = ...
		Set_AllParameter_from_ExcelFile(ExcelFileName,ExcelFileDir);
	for ExperimentNr = 1:numel(ExperimentNameSet)
		%% EA
		ExperimentName = ExperimentNameSet{ExperimentNr};
		ResultFolderName = ...
			[ResultParentFolderName,TrussTypeName,'\',ExperimentName,'\'];
		ResultData = load([ResultFolderName,'Result.mat']);
		t_set = ResultData.t_set;
		
		%%
		switch ExperimentName
			case 'Axial Stretch'
				ValidTestRatio = ...
					ValidTestRatioSet(TrussTypeNr,ExperimentNr);
				ValidTestNr = floor(ValidTestRatio*numel(t_set));
				t_set = t_set(1:ValidTestNr);
				x_set = ResultData.x_set(1:ValidTestNr,:);
				%
				Fn_set = zeros(size(t_set));
				for t_Nr = 1:numel(t_set)
					[Action,~] = get_Action_Truss_Statics_Test(...
						t_set(t_Nr),[],[],ModelParameter,ExperimentName);
					Fn_set(t_Nr) = Action(1);
				end
				rx_set = x_set(:,7);
				epsilon_set = (rx_set - rx_set(1)) / rx_set(1);
				
				plot(TrussFigure{TrussTypeNr}.AxesObj_AxialStretch, ...
					epsilon_set,Fn_set);
				title(TrussFigure{TrussTypeNr}.AxesObj_AxialStretch, ...
					'Axial Stretch');
				xlabel(TrussFigure{TrussTypeNr}.AxesObj_AxialStretch, ...
					'\epsilon');
				ylabel(TrussFigure{TrussTypeNr}.AxesObj_AxialStretch, ...
					'F_n');
				EA_Stretch = polyfit(epsilon_set,Fn_set,1);
				EA_Stretch = EA_Stretch(1);
				
				q = x_set(end,1:12)';
				plot_Mechanism(q,ModelParameter,SolverParameter, ...
					TrussStateFigure{TrussTypeNr}.AxesObj_AxialStretch);
			case 'Axial Compression'
				ValidTestRatio = ...
					ValidTestRatioSet(TrussTypeNr,ExperimentNr);
				ValidTestNr = floor(ValidTestRatio*numel(t_set));
				t_set = t_set(1:ValidTestNr);
				x_set = ResultData.x_set(1:ValidTestNr,:);
				%
				Fn_set = zeros(size(t_set));
				for t_Nr = 1:numel(t_set)
					[Action,ActionTagSet] = get_Action_Truss_Statics_Test(...
						t_set(t_Nr),[],[],ModelParameter,ExperimentName);
					Fn_set(t_Nr) = -Action(1);
				end
				rx_set = x_set(:,7);
				epsilon_set = -(rx_set - rx_set(1)) / rx_set(1);
				
				plot(TrussFigure{TrussTypeNr}.AxesObj_AxialCompression, ...
					epsilon_set,Fn_set);
				title(TrussFigure{TrussTypeNr}.AxesObj_AxialCompression, ...
					'Axial Compression');
				xlabel(TrussFigure{TrussTypeNr}.AxesObj_AxialCompression, ...
					'\epsilon');
				ylabel(TrussFigure{TrussTypeNr}.AxesObj_AxialCompression, ...
					'F_n');
				
				EA_Compression = polyfit(epsilon_set,Fn_set,1);
				EA_Compression = EA_Compression(1);
				
				q = x_set(end,1:12)';
				plot_Mechanism(q,ModelParameter,SolverParameter, ...
					TrussStateFigure{TrussTypeNr}.AxesObj_AxialCompression);
			case 'x-Axis Twist'
				ValidTestRatio = ...
					ValidTestRatioSet(TrussTypeNr,ExperimentNr);
				ValidTestNr = floor(ValidTestRatio*numel(t_set));
				t_set = t_set(1:ValidTestNr);
				x_set = ResultData.x_set(1:ValidTestNr,:);
				%
				Fn_set = zeros(size(t_set));
				Mx_set = zeros(size(t_set));
				for t_Nr = 1:numel(t_set)
					[Action,ActionTagSet] = get_Action_Truss_Statics_Test(...
						t_set(t_Nr),[],[],ModelParameter,ExperimentName);
					Mx_set(t_Nr) = Action(2);
				end
				rx_set = x_set(:,7);
				epsilon_set = -(rx_set - rx_set(1)) / rx_set(1);
				
				phix_set = x_set(:,10);
				kappax_set = x_set(:,10) / x_set(1,7);
				
				plot(TrussFigure{TrussTypeNr}.AxesObj_xAxisTwist, ...
					kappax_set,Mx_set);
				title(TrussFigure{TrussTypeNr}.AxesObj_xAxisTwist, ...
					'x-Axis Twist');
				xlabel(TrussFigure{TrussTypeNr}.AxesObj_xAxisTwist, ...
					'\kappa_x');
				ylabel(TrussFigure{TrussTypeNr}.AxesObj_xAxisTwist, ...
					'T_x');
				
				plot(TrussFigure{TrussTypeNr}.AxesObj_xAxisTwist2, ...
					epsilon_set,Mx_set);
				title(TrussFigure{TrussTypeNr}.AxesObj_xAxisTwist2, ...
					'x-Axis Twist');
				xlabel(TrussFigure{TrussTypeNr}.AxesObj_xAxisTwist2, ...
					'\epsilon_x');
				ylabel(TrussFigure{TrussTypeNr}.AxesObj_xAxisTwist2, ...
					'T_x');
				
				GIyIz = polyfit(kappax_set,Mx_set,1);
				GIyIz = GIyIz(1);
				
				q = x_set(end,1:12)';
				plot_Mechanism(q,ModelParameter,SolverParameter, ...
					TrussStateFigure{TrussTypeNr}.AxesObj_xAxisTwist);
			case 'y-Axis Bending'
				ValidTestRatio = ...
					ValidTestRatioSet(TrussTypeNr,ExperimentNr);
				ValidTestNr = floor(ValidTestRatio*numel(t_set));
				t_set = t_set(1:ValidTestNr);
				x_set = ResultData.x_set(1:ValidTestNr,:);
				%
				My_set = zeros(size(t_set));
				for t_Nr = 1:numel(t_set)
					[Action,ActionTagSet] = get_Action_Truss_Statics_Test(...
						t_set(t_Nr),[],[],ModelParameter,ExperimentName);
					My_set(t_Nr) = Action(3);
				end
				phiy_set = x_set(:,11);
				kappay_set = phiy_set / x_set(1,7);
				
				plot(TrussFigure{TrussTypeNr}.AxesObj_yAxisBending, ...
					kappay_set,My_set);
				title(TrussFigure{TrussTypeNr}.AxesObj_yAxisBending, ...
					'y-Axis Bending');
				xlabel(TrussFigure{TrussTypeNr}.AxesObj_yAxisBending, ...
					'\kappa_y');
				ylabel(TrussFigure{TrussTypeNr}.AxesObj_yAxisBending, ...
					'M_y');
				
				EIy = polyfit(kappay_set,My_set,1);
				EIy = EIy(1);
				
				q = x_set(end,1:12)';
				plot_Mechanism(q,ModelParameter,SolverParameter, ...
					TrussStateFigure{TrussTypeNr}.AxesObj_yAxisBending);
			case 'z-Axis Bending'
				ValidTestRatio = ...
					ValidTestRatioSet(TrussTypeNr,ExperimentNr);
				ValidTestNr = floor(ValidTestRatio*numel(t_set));
				t_set = t_set(1:ValidTestNr);
				x_set = ResultData.x_set(1:ValidTestNr,:);
				%
				Mz_set = zeros(size(t_set));
				for t_Nr = 1:numel(t_set)
					[Action,ActionTagSet] = get_Action_Truss_Statics_Test(...
						t_set(t_Nr),[],[],ModelParameter,ExperimentName);
					Mz_set(t_Nr) = Action(4);
				end
				phiz_set = x_set(:,12);
				kappaz_set = phiz_set / x_set(1,7);
				
				plot(TrussFigure{TrussTypeNr}.AxesObj_zAxisBending, ...
					kappaz_set,Mz_set);
				title(TrussFigure{TrussTypeNr}.AxesObj_zAxisBending, ...
					'z-Axis Bending');
				xlabel(TrussFigure{TrussTypeNr}.AxesObj_zAxisBending, ...
					'\kappa_z');
				ylabel(TrussFigure{TrussTypeNr}.AxesObj_zAxisBending, ...
					'M_z');
				
				EIz = polyfit(kappaz_set,Mz_set,1);
				EIz = EIz(1);
				
				q = x_set(end,1:12)';
				plot_Mechanism(q,ModelParameter,SolverParameter, ...
					TrussStateFigure{TrussTypeNr}.AxesObj_zAxisBending);
			otherwise
				error('No Experiment exist!\n');
		end
	end
	TrussParameter{TrussTypeNr}.EA_Stretch = EA_Stretch;
	TrussParameter{TrussTypeNr}.EA_Compression = EA_Compression;
	TrussParameter{TrussTypeNr}.GIyIz = GIyIz;
	TrussParameter{TrussTypeNr}.EIy = EIy;
	TrussParameter{TrussTypeNr}.EIz = EIz;
% 	close all;
% 	[EA_Stretch,EA_Compression,GIyIz,EIy,EIz]
	
end
% save('TrussEquivalentStaticParameter.mat','TrussParameter');
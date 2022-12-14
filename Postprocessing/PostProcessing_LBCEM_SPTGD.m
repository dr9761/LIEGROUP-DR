%% ========= PostProcessing_LBCEM_SPTGD ============
%% PostProcessing
%% Lattice Boom Crane Equivalent Model(LBCEM)
%% Static Position Through Gloabal Damping(SPTGD)
%% =================================================
clc;clear;close all;
LoadMass = 50:50:400;
ResultParentFolderName = ...
	['Result\Lattice Boom Crane\Cargo in Air', ...
	'\Equivalent Model', ...
	'\Static HighPrecisionExcel Damping-0 Tol=1e-2\'];

PositionFigure = figure('Name','Position');
RelativePositionFigure = figure('Name','Relative Position');
VelocityFigure = figure('Name','Velocity');

PositionAxes = cell(numel(LoadMass),1);
RelativePositionAxes = cell(numel(LoadMass),1);
VelocityAxes = cell(numel(LoadMass),1);

for LoadMassNr = 1:numel(LoadMass)
	ResultFileName = ...
		[ResultParentFolderName, ...
		num2str(LoadMass(LoadMassNr)),'t\'];
	load([ResultFileName,'Result.mat']);
	%
	PositionAxes{LoadMassNr} = ...
		subplot(2,4,LoadMassNr, ...
		'Parent',PositionFigure);
	plot(PositionAxes{LoadMassNr}, ...
		t_set,x_set(:,1:120));
	%
	RelativePositionAxes{LoadMassNr} = ...
		subplot(2,4,LoadMassNr, ...
		'Parent',RelativePositionFigure);
	plot(RelativePositionAxes{LoadMassNr}, ...
		t_set,x_set(:,1:120)-x_set(1,1:120));
	%
	VelocityAxes{LoadMassNr} = ...
		subplot(2,4,LoadMassNr, ...
		'Parent',VelocityFigure);
	plot(VelocityAxes{LoadMassNr}, ...
		t_set,x_set(:,121:end));
	%
	title(PositionAxes{LoadMassNr}, ...
		[num2str(LoadMass(LoadMassNr)),'t']);
	title(RelativePositionAxes{LoadMassNr}, ...
		[num2str(LoadMass(LoadMassNr)),'t']);
	title(VelocityAxes{LoadMassNr}, ...
		[num2str(LoadMass(LoadMassNr)),'t']);
	%
	axis(RelativePositionAxes{LoadMassNr}, ...
		[0,20,-0.4,0.1]);
	%
	fprintf('Solving Time = %d\n',SolvingTime/60);
end

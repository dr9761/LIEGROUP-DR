% create_SuperTrussElement_DataBase
%%
clc;clear;close all;
ExcelFileName = ...
	'Super Truss Element Pendulum Test';
ExcelFileDir = [...
	'Parameter File\', ...
	'Super Truss Element Model Recognition'];
[ModelParameter,SolverParameter] = ...
	Set_AllParameter_from_ExcelFile(ExcelFileName,ExcelFileDir);
%%
do_plot_current_state = false;
gaussn = 5;
%%
if do_plot_current_state
	StateFigure = figure('Name','State Figure');
	StateAxes = axes(StateFigure);
end
%%
BodyParameter = ModelParameter.BodyElementParameter{1};
L = BodyParameter.Truss_Parameter.TrussLength;
MainBeamBodyParameter = ...
	BodyParameter.Truss_Parameter.MainBeamParameter.BodyParameter{1};
BodyParameter.rho = MainBeamBodyParameter.rho;
BodyParameter.L = L;
g = ModelParameter.g;
gx = [1;0;0];
%%
r01 = [0;0;0];
phi1 = [0;0;0];
R1 = get_R(phi1);
q1 = [r01;phi1];

r02_ideal = r01 + R1*gx*L;
phi2_ideal = phi1;
%%
Mass_set = [];
Force_set = [];
CubicSpline_Mass_Function_Library_set = [];
CubicSpline_Force_Function_Library_set = [];
DataQuantity = 100;
DataBase = cell(DataQuantity,1);
fprintf('Start to create DataBase ...\n');
for DataNr = 1:DataQuantity
	%%
	u1 = 2*0.1*L*(rand(3,1)-0.5);
	RotationAxis1 = rand(3,1);
	RotationAxis1 = RotationAxis1 / norm(RotationAxis1);
	RotationAngle1 = deg2rad(2*0.5*(rand(1)-0.5));
	psi1 = RotationAngle1 * RotationAxis1;
	
	r01 = r01 + u1;
	R1 = R1 * get_R(psi1);
	phi1 = get_Rotation_from_R(R1,zeros(3,1));
	q1 = [r01;phi1];
	%
	u2 = 2*0.01*L*(rand(3,1)-0.5);
	RotationAxis2 = rand(3,1);
	RotationAxis2 = RotationAxis2 / norm(RotationAxis2);
	RotationAngle2 = deg2rad(2*0.5*(rand(1)-0.5));
	psi2 = RotationAngle2 * RotationAxis2;
	
	r02 = r02_ideal + u2;
	R2 = R1 * get_R(psi2);
	phi2 = get_Rotation_from_R(R2,zeros(3,1));
	q2 = [r02;phi2];
	
	qe = [q1;q2];
	%
	dqe = 1*2*10*(rand(12,1)-0.5);
	%%
	if do_plot_current_state
		plot_Mechanism(...
			qe,ModelParameter,SolverParameter,StateAxes);
		drawnow;
		pause(0.01);
	end
	%%
	% 	[Mass,Force] = Super_Truss_Element_MassForce(...
	% 		qe,dqe,g,BodyParameter);
	x = [qe;dqe];
	
	x1 = x;x2 = x;
	x1_set = [];
	x2_set = [];
	qe1_set = [];
	qe2_set = [];
	dqe1_set = [];
	dqe2_set = [];
	ddqe1_set = [];
	ddqe2_set = [];
	for k = 1:100
		qe1 = x1(1:numel(x1)/2);
		dqe1 = x1(numel(x1)/2+1:end);
		
		qe2 = x2(1:numel(x2)/2);
		dqe2 = x2(numel(x2)/2+1:end);
		
		[Mass1,Force1] = CubicSpline_12DoF_MassForce(...
			qe1,dqe1,g,MainBeamBodyParameter);
		ddqe1 = -Mass1\Force1;
		dqe1dt = zeros(12,1);
		dqe1dt(1:3) = dqe1(1:3);
		dqe1dt(4:6) = get_T(qe1(4:6))\dqe1(4:6);
		dqe1dt(7:9) = dqe1(7:9);
		dqe1dt(10:12) = get_T(qe1(10:12))\dqe1(10:12);
		
		[Mass2,Force2] = TimoshenkoBeam_MassForce(...
			qe2,dqe2,g,MainBeamBodyParameter);
		ddqe2 = -Mass2\Force2;
		dqe2dt = zeros(12,1);
		dqe2dt(1:3) = dqe2(1:3);
		dqe2dt(4:6) = get_T(qe2(4:6))\dqe2(4:6);
		dqe2dt(7:9) = dqe2(7:9);
		dqe2dt(10:12) = get_T(qe2(10:12))\dqe2(10:12);
		
		dx1 = [dqe1dt;ddqe1];
		dx2 = [dqe2dt;ddqe2];
		
		x1 = x1 + dx1*0.00001;
		x2 = x2 + dx2*0.00001;
		
		x1_set = [x1_set,x1];
		x2_set = [x2_set,x2];
		
		qe1_set = [qe1_set,qe1];
		qe2_set = [qe2_set,qe2];
		dqe1_set = [dqe1_set,dqe1];
		dqe2_set = [dqe2_set,dqe2];
		ddqe1_set = [ddqe1_set,ddqe1];
		ddqe2_set = [ddqe2_set,ddqe2];
	end
	figure(1);
	subplot(3,2,1);plot(1:100,qe1_set-qe1_set(:,1));
	subplot(3,2,2);plot(1:100,qe2_set-qe2_set(:,1));
	subplot(3,2,3);plot(1:100,dqe1_set-dqe1_set(:,1));
	subplot(3,2,4);plot(1:100,dqe2_set-dqe2_set(:,1));
	subplot(3,2,5);plot(1:100,ddqe1_set-ddqe1_set(:,1));
	subplot(3,2,6);plot(1:100,ddqe2_set-ddqe2_set(:,1));
	figure(2);plot(1:100,x2_set-x);
	
	figure(3);plot(1:100,ddqe1_set - ddqe1_set(:,1));
	figure(4);plot(1:100,ddqe2_set - ddqe2_set(:,1));
	
	Mass_set = [Mass_set;Mass];
	Force_set = [Force_set;Force];
	%%
	[CubicSpline_Mass_Function_Library,CubicSpline_Force_Function_Library] = ...
		CubicSpline_MassForce_FunctionLibrary(...
		qe,dqe,g,BodyParameter,gaussn);
	CubicSpline_Mass_Function_Library_set = ...
		[CubicSpline_Mass_Function_Library_set;CubicSpline_Mass_Function_Library];
	CubicSpline_Force_Function_Library_set = ...
		[CubicSpline_Force_Function_Library_set;CubicSpline_Force_Function_Library];
	%%
	DataBase{DataNr}.Mass = Mass;
	DataBase{DataNr}.Force = Force;
	DataBase{DataNr}.CubicSpline_Mass_Function_Library = ...
		CubicSpline_Mass_Function_Library;
	DataBase{DataNr}.CubicSpline_Force_Function_Library = ...
		CubicSpline_Force_Function_Library;
	fprintf('\t%6.6f / %6.6f Data has been created.\n',DataNr,DataQuantity);
end
fprintf('DataBase created!\n');
%% Mass
DataQuantity = numel(DataBase);
FunctionOutput = zeros(DataQuantity,1);

MatrixNr = 1;
for DataNr = 1:DataQuantity
	Mass = DataBase{DataNr}.Mass;
	CubicSpline_Mass_Function_Library = ...
		DataBase{DataNr}.CubicSpline_Mass_Function_Library;
	%
	FunctionOutput(DataNr) = Mass(MatrixNr);
	FunctionLibraryUnitQuantity = ...
		size(CubicSpline_Mass_Function_Library,2) / 12;
	%
	FunctionLibrary = zeros(DataQuantity,FunctionLibraryUnitQuantity);
	for FunctionLibraryUnitNr = 1:FunctionLibraryUnitQuantity
		FunctionLibraryUnit = ...
			CubicSpline_Mass_Function_Library(:,12*(FunctionLibraryUnitNr-1)+[1:12]);
		FunctionLibrary(DataNr,FunctionLibraryUnitNr) = FunctionLibraryUnit(MatrixNr);
	end
end

FunctionOutput = Mass_set;
FunctionLibrary = CubicSpline_Mass_Function_Library_set;

StateDimension = size(FunctionOutput,2);
lambda = 1e-16;

Xi = sparsifyDynamics(FunctionLibrary,FunctionOutput,lambda,StateDimension);
%
FunctionOutput_Predictive = FunctionLibrary*Xi;
%
Predictive_Error = FunctionOutput_Predictive - FunctionOutput;
Predictive_AbsError = abs(Predictive_Error);
if size(FunctionOutput,2) == 1
	Predictive_SumAbsError = sum(Predictive_AbsError);
	Predictive_AverageAbsError = ...
		Predictive_SumAbsError / numel(FunctionOutput_Predictive);
	Predictive_SumRelError = sum(Predictive_AbsError ./ (abs(FunctionOutput)+eps));
	Predictive_AverageRelError = Predictive_SumRelError / numel(FunctionOutput_Predictive);
else
	Predictive_SumAbsError = sum(sum(Predictive_AbsError));
	Predictive_AverageAbsError = ...
		Predictive_SumAbsError / numel(FunctionOutput_Predictive);
	Predictive_SumRelError = sum(sum(Predictive_AbsError ./ (abs(FunctionOutput)+eps)));
	Predictive_AverageRelError = Predictive_SumRelError / numel(FunctionOutput_Predictive);
end
Predictive_AverageAbsError
Predictive_AverageRelError
%% Force
StateDimension = 1;
lambda = 1e-16;
FunctionOutput = Force_set;
FunctionLibrary = CubicSpline_Force_Function_Library_set;
Xi = sparsifyDynamics(FunctionLibrary,FunctionOutput,lambda,StateDimension);
%
FunctionOutput_Predictive = FunctionLibrary*Xi;
%
Predictive_Error = FunctionOutput_Predictive - FunctionOutput;
Predictive_AbsError = abs(Predictive_Error);
if size(FunctionOutput,2) == 1
	Predictive_SumAbsError = sum(Predictive_AbsError);
	Predictive_AverageAbsError = ...
		Predictive_SumAbsError / numel(FunctionOutput_Predictive);
	Predictive_SumRelError = sum(Predictive_AbsError ./ abs(FunctionOutput));
	Predictive_AverageRelError = Predictive_SumRelError / numel(FunctionOutput_Predictive);
else
	Predictive_SumAbsError = sum(sum(Predictive_AbsError));
	Predictive_AverageAbsError = ...
		Predictive_SumAbsError / numel(FunctionOutput_Predictive);
	Predictive_SumRelError = sum(sum(Predictive_AbsError ./ abs(FunctionOutput)));
	Predictive_AverageRelError = Predictive_SumRelError / numel(FunctionOutput_Predictive);
end
Predictive_AverageAbsError
Predictive_AverageRelError
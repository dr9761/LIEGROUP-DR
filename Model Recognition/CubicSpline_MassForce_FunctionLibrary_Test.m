% CubicSpline_MassForce_FunctionLibrary_Test
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
qe = ModelParameter.InitialState.q0;
dqe = ModelParameter.InitialState.dq0;
g = ModelParameter.g;
BodyParameter = ModelParameter.BodyElementParameter{1};
[Mass,Force] = Super_Truss_Element_MassForce(...
	qe,dqe,g,BodyParameter);
%%
BodyParameter.L = BodyParameter.Truss_Parameter.TrussLength;
gaussn = 5;
[CubicSpline_Mass_Function_Library,CubicSpline_Force_Function_Library] = ...
	CubicSpline_MassForce_FunctionLibrary(...
	qe,dqe,g,BodyParameter,gaussn);
%% Mass
StateDimension = numel(qe);
lambda = 1e-6;
FunctionOutput = Mass;
FunctionLibrary = CubicSpline_Mass_Function_Library;
Xi = sparsifyDynamics(FunctionLibrary,FunctionOutput,lambda,StateDimension);
%
FunctionOutput_Predictive = FunctionLibrary*Xi;
if size(FunctionOutput,2) == 1
	Predictive_Error = sum(abs(FunctionOutput_Predictive - FunctionOutput));
else
	Predictive_Error = sum(sum(abs(FunctionOutput_Predictive - FunctionOutput)));
end
%% Force
StateDimension = 1;
lambda = 1e-6;
FunctionOutput = Force;
FunctionLibrary = CubicSpline_Force_Function_Library;
Xi = sparsifyDynamics(FunctionLibrary,FunctionOutput,lambda,StateDimension);
%
FunctionOutput_Predictive = FunctionLibrary*Xi;
if size(FunctionOutput,2) == 1
	Predictive_Error = sum(abs(FunctionOutput_Predictive - FunctionOutput));
else
	Predictive_Error = sum(sum(abs(FunctionOutput_Predictive - FunctionOutput)));
end
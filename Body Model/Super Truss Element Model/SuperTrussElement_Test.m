clc;clear;
close all;
%%
ExcelFileName = ...
	'Super Truss Element Pendulum Test';
ExcelFileDir = [...
	'Parameter File\Pendulum Test', ...
	'\Super Truss Element Pendulum Test'];

[ModelParameter,SolverParameter] = ...
	Set_AllParameter_from_ExcelFile(ExcelFileName,ExcelFileDir);
%%
qe = ModelParameter.InitialState.q0;
dqe = ModelParameter.InitialState.dq0;
g = ModelParameter.g;
BodyParameter = ModelParameter.BodyElementParameter{1};
%%
[Mass,Force] = Super_Truss_Element_MassForce(...
	qe,dqe,g,BodyParameter);


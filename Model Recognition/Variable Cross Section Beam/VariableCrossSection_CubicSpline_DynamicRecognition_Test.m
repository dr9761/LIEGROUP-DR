% VariableCrossSection_CubicSpline_DynamicRecognition_Test
%%
clc;clear;close all;
ExcelFileName = ...
	'Cubic Spline Beam - 5 Segments';
ExcelFileDir = [...
	'Parameter File', ...
	'\Variable cross-section continuous beam'];
[ModelParameter,SolverParameter] = ...
	Set_AllParameter_from_ExcelFile(ExcelFileName,ExcelFileDir);
SolverParameter.ActionFunction = get_ActionFunction('None');
L = 0;
for BodyNr = 1:numel(ModelParameter.BodyElementParameter)
	L = L + ModelParameter.BodyElementParameter{BodyNr}.L;
end
%%
qe = ModelParameter.InitialState.q0;
dqe = ModelParameter.InitialState.dq0;
DataBaseSize = 20;
Mass_set = [];
Force_set = [];
Mass_Function_Library_set = [];
Force_Function_Library_set = [];
for DataNr = 1:DataBaseSize
qe = qe + 2*(rand(size(qe))-0.5);
dqe = dqe + 2*(rand(size(dqe))-0.5);
%%
t = 0;
x = [qe;dqe];
tspan = [0;1];
g = ModelParameter.g;
BodyParameter = ModelParameter.BodyElementParameter{1};
% [Mass,Force] = Super_Truss_Element_MassForce(...
% 	qe,dqe,g,BodyParameter);
CalcPlotFigure = [];
useConstraint = false;

% dx = Multi_Body_Dynamics_func(t,x,tspan, ...
% 	ModelParameter,SolverParameter, ...
% 	CalcPlotFigure);
[SystemMass,SystemForce] = ...
	Multi_Body_Dynamics_MassForce(t,x,tspan, ...
	ModelParameter,SolverParameter, ...
	useConstraint);
SystemForce = -SystemForce;
ddq = SystemMass \ SystemForce;

SystemMass_1_1 = SystemMass(1:7,1:7);
SystemMass_1_r = SystemMass(1:7,8:end-7);
SystemMass_1_2 = SystemMass(1:7,end-6:end);

SystemMass_r_1 = SystemMass(8:end-7,1:7);
SystemMass_r_r = SystemMass(8:end-7,8:end-7);
SystemMass_r_2 = SystemMass(8:end-7,end-6:end);

SystemMass_2_1 = SystemMass(end-6:end,1:7);
SystemMass_2_r = SystemMass(end-6:end,8:end-7);
SystemMass_2_2 = SystemMass(end-6:end,end-6:end);

SystemForce_1 = SystemForce(1:7);
SystemForce_r = SystemForce(8:end-7);
SystemForce_2 = SystemForce(end-6:end);

ddq_1 = ddq(1:7);
ddq_r = ddq(8:end-7);
ddq_2 = ddq(end-6:end);

Mass = [...
	SystemMass_1_1,	SystemMass_1_2; ...
	SystemMass_2_1,	SystemMass_2_2];
Force = [SystemForce_1;SystemForce_2] - ...
	[SystemMass_1_r;SystemMass_2_r] * ddq_r;
Mass_set = [Mass_set;Mass];
Force_set = [Force_set;Force];
% [[ddq_1;ddq_2],Mass\Force]
%%
gaussn = 11;
qs = [qe(1:7);qe(end-6:end)];
dqs = [dqe(1:7);dqe(end-6:end)];
[Mass_Function_Library,Force_Function_Library] = ...
	CubicSpline_14DoF_MassForce_FunctionLibrary(...
	qs,dqs,g,L,gaussn);
Mass_Function_Library_set = [Mass_Function_Library_set;
	Mass_Function_Library];
Force_Function_Library_set = [Force_Function_Library_set;
	Force_Function_Library];
%%
fprintf('%d / %d Data has been finished!\n',DataNr,DataBaseSize);
end
%% Mass
StateDimension = numel(qs);
lambda = 1e-16;
FunctionOutput = Mass_set;
FunctionLibrary = Mass_Function_Library_set;
Xi = sparsifyDynamics(FunctionLibrary,FunctionOutput,lambda,StateDimension);
%
FunctionOutput_Predictive = FunctionLibrary*Xi;
IdentificationError = get_Identification_Error(...
	FunctionOutput,FunctionOutput_Predictive)
% if size(FunctionOutput,2) == 1
% 	Predictive_Error = sum(abs(FunctionOutput_Predictive - FunctionOutput));
% else
% 	Predictive_Error = sum(sum(abs(FunctionOutput_Predictive - FunctionOutput)));
% end
% Predictive_Error
%% Force
StateDimension = 1;
lambda = 1e-16;
FunctionOutput = Force_set;
FunctionLibrary = Force_Function_Library_set;
Xi = sparsifyDynamics(FunctionLibrary,FunctionOutput,lambda,StateDimension);
%
FunctionOutput_Predictive = FunctionLibrary*Xi;
IdentificationError = get_Identification_Error(...
	FunctionOutput,FunctionOutput_Predictive)
% if size(FunctionOutput,2) == 1
% 	Predictive_Error = sum(abs(FunctionOutput_Predictive - FunctionOutput));
% else
% 	Predictive_Error = sum(sum(abs(FunctionOutput_Predictive - FunctionOutput)));
% end
% Predictive_Error
function [ModelParameter,SolverParameter] = ...
	Set_AllParameter_from_ExcelFile(ExcelFileName,ExcelFileDir, ...
	do_Reduce_DoF)
%%
if nargin == 2
	do_Reduce_DoF = true;
end
%%
fprintf('Following Parameter File has been chosen!\n\n');
ExcelFilePath = [ExcelFileDir,'\',ExcelFileName,'.xlsx'];
fprintf(['Name:\n\t',ExcelFileName,'\n']);
fprintf(['Location:\n\t',strrep(ExcelFileDir,'\','\\'),'\n\n']);
%%
fprintf('Start to Load Parameter from Excel File!\n');
%% Solver Parameter
SolverParameter = set_SolverParameter(ExcelFilePath);
%%
BodyElementParameter = ...
	set_AllBodyParameter(ExcelFilePath);
[Frame_Joint_Parameter,Joint_Parameter] = ...
	set_Joint_Parameter(ExcelFilePath);
ConstraintParameter = ...
	set_ConstraintParameter(ExcelFilePath);
PlotParameter = ...
	set_PlotParameter(ExcelFilePath);
[NodalForceParameter,NodalForceDriveParameter] = ...
	set_NodalForceParameter(ExcelFilePath);
fprintf('All Parameters have been loaded!\n');
%% Set Initial State
fprintf('\n');
fprintf('Start to Load Inertial State!\n');
[q0,dq0] = ...
	set_Initial_State(BodyElementParameter,ExcelFilePath);
fprintf('Inertial State has been setted!\n');
%%
if do_Reduce_DoF
	fprintf('\n');
	fprintf('Freedom reduction process starts...\n')
	[q0,dq0,BodyElementParameter,ConstraintParameter] = ...
		Reduce_DegreeOfFreedom(...
		q0,dq0,BodyElementParameter,ConstraintParameter);
end
%
x0 = [q0;dq0];
%% Set Gravity
g = Gravity_Configuration(ExcelFilePath);
%% Set Drive Parameter
DriveParameter.NodalForceDriveParameter = NodalForceDriveParameter;
%%
ModelParameter.BodyElementParameter = BodyElementParameter;

ModelParameter.Frame_Joint_Parameter = Frame_Joint_Parameter;
ModelParameter.Joint_Parameter = Joint_Parameter;

ModelParameter.ConstraintParameter = ConstraintParameter;

ModelParameter.PlotParameter = PlotParameter;

ModelParameter.NodalForceParameter = NodalForceParameter;
ModelParameter.DriveParameter = DriveParameter;

ModelParameter.InitialState.q0 = q0;
ModelParameter.InitialState.dq0 = dq0;
ModelParameter.InitialState.x0 = x0;

ModelParameter.g = g;
%% get Jacobian Matrix
if SolverParameter.JacobianCalculation.Calculate
	fprintf('Apply Casadi Symbolic Module ...\n');
	[ModelParameter.MassForce_StateVariable_JacobianFunc, ...
		ModelParameter.State_JacobianFunc]= ...
		get_MassForce_JacobianFunc_Multi_Body_Dynamic_Symbolic(...
		ModelParameter);
end
end
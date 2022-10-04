%%计算全局坐标系下HA，HB
%%进而计算the relative configuration vector d
%%根据d与d0求解当前应变
%%根据动力学方程利用ODE（此处需采用广义alpha法）求解局部坐标下的vA，vB
%%根据局部坐标系下的v更新全局坐标系下的H(附录B。2/B。6)


clc;clear;
close all;
%% Change Working Dictionary
Welcome_to_Programm;
% Configure Working Directory
FullPathOfProject = Configure_WorkingDirectory;
%% Load Sub-Module
Load_SubModule(FullPathOfProject);
%% Load Parameter
ExcelFileName = ...
	'Timoshenko Beam Pendulum test';
ExcelFileDir = [...
	'Parameter File\Pendulum Test'];
[ModelParameter,SolverParameter] = ...
	Set_AllParameter_from_ExcelFile(ExcelFileName,ExcelFileDir);

BodyElementParameter = ModelParameter.BodyElementParameter;
Frame_Joint_Parameter = ModelParameter.Frame_Joint_Parameter;
Joint_Parameter = ModelParameter.Joint_Parameter;
ConstraintParameter = ModelParameter.ConstraintParameter;
NodalForceParameter = ModelParameter.NodalForceParameter;
DriveParameter = ModelParameter.DriveParameter;

BodyQuantity = numel(BodyElementParameter);



%% time span for dynamic ODE
t_start = SolverParameter.ODE_Solver.t_start;
t_end = SolverParameter.ODE_Solver.t_end;
tspan = [t_start;t_end];

%% Action Function
SolverParameter.ActionFunction = get_ActionFunction('None');
%% Load Existing Initial State
exist_InitialState = false;
InitialStateFileName = [...
	'Result\Lattice Boom Crane\Super Truss Element\', ...
	'Lattice Boom Crane Static Tol=0.01 MaxStep=0.02\Result.mat'];
ModelParameter.InitialState = ...
	Load_Existing_InitialState(exist_InitialState, ...
	InitialStateFileName,ModelParameter)
%% plot Initial State
do_plot_InitialState = true;
InitalStateAxes = plot_InitialState(do_plot_InitialState, ...
	ModelParameter,SolverParameter);


tic;
%calculate statics
do_Statics_Calculation = false;
% if do_Statics_Calculation
% 	q0 = ModelParameter.InitialState.q0;
% 	[MassMtx,SystemForceFcn] = @(HA,HB)Multi_Body_Dynamics_Force(HA,HB,tspan, ...
% 		ModelParameter,SolverParameter);
% else 
%     [MassMtx,SystemForceFcn] = Multi_Body_Dynamics_Force(HA,HB,tspan, ...
% 		ModelParameter,SolverParameter);
% end
%     [SystemForceFcn] = Multi_Body_Dynamics_Force(HA,HB,epsilon,d,tspan, ...
% 		ModelParameter,SolverParameter);
%     [MassMtx] = Multi_Body_Dynamics_Mass(HA,HB,epsilon,d,tspan, ...
% 		ModelParameter,SolverParameter);
%%Dynamic Function
%%ODE set
opt = set_ODESolver_Option(ModelParameter,SolverParameter);
%% ODE23 Solver
x0 = ModelParameter.InitialState.x0;
y0 = dealIn(x0);
[t_set,y_set] = Dynamics_ODE_Solver(...
	tspan,x0,y0,opt,ModelParameter,SolverParameter);
SolvingTime = toc;

do_save_Result = true;
save_Result(do_save_Result, ...
	ExcelFileDir,ExcelFileName, ...
	ModelParameter,SolverParameter, ...
	opt,tspan,y_set,t_set,SolvingTime);

fprintf('Finished!\n');







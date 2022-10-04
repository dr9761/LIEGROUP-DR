clc;clear;
close all;
%%
doTraining = true;
usePretrainedAgent = false;
ExcelFileName = ...
	'Folding Boom - Rigid 3DoF Hydraulic';
ExcelFileDir = [...
	'Parameter File', ...
	'\Folding Boom System\Controllable System'];
PretrainedAgentDir = ...
	['Result\Reinforcement Learning\', ...
	'20201122_0628Single Rigid Cart Pole'];
%% Load Sub-Module
Load_SubModule;
%% Load Parameter from Excel File
[ModelParameter,SolverParameter] = ...
	Set_AllParameter_from_ExcelFile(ExcelFileName,ExcelFileDir);
%%
ExcelFilePath = 'Parameter File\Hydraulic System Test\Hydraulic System Test - 2.xlsx';

[HydraulicOilParameter,HydraulicElementParameter,HydraulicCoordinateQuantity] = ...
	create_HydraulicElement(ExcelFilePath);
HydraulicConnectionParameter = create_HydraulicConnection(ExcelFilePath);

HydraulicSymbolicStateSolution = create_HydraulicCalculationEquation(...
	HydraulicOilParameter,HydraulicElementParameter, ...
	HydraulicConnectionParameter);
%
HydraulicParameter.HydraulicElementParameter = HydraulicElementParameter;
HydraulicParameter.HydraulicOilParameter = HydraulicOilParameter;
HydraulicParameter.HydraulicConnectionParameter = HydraulicConnectionParameter;
HydraulicParameter.HydraulicCoordinateQuantity = HydraulicCoordinateQuantity;

HydraulicParameter.HydraulicSymbolicStateSolution = HydraulicSymbolicStateSolution;
HydraulicParameter.HydraulicSymbolicStateSolutionHandle = ...
	matlabFunction(HydraulicSymbolicStateSolution.SymbolicCalculatedHydraulicElementState);

HydraulicParameter.HydraulicNumericalEquationHandle = ...
	@(HydraulicState)create_HydraulicCalculationEquation_Numerical(HydraulicState,x,u, ...
	HydraulicOilParameter,HydraulicElementParameter, ...
	HydraulicConnectionParameter);
%%
%%
dpsi = 0;dphi1 = deg2rad(0);dphi2 = deg2rad(0);
q = [dpsi;dphi1;dphi2];
%
ddpsidt = 0;ddphi1dt = 0;ddphi2dt = 0;
dq = [ddpsidt;ddphi1dt;ddphi2dt];
%
pL1 = 10;pL2 = 1;pU1 = 10;pU2 = 1;
p = [pL1;pL2;pU1;pU2];
%
ut = 0;u1 = 0;u2 = 0;
u = [ut;u1;u2];
%
x = [q;dq;p];
%%
p0 = 1e1*[1;0.1;1;0.1];
SystemForceFcn = @(p)FoldingBoom_3DoF_ValveControlHydraulic_Dynamic_func(...
	0,[zeros(6,1);p],zeros(3,1),zeros(3,1),[0,1], ...
	ModelParameter,HydraulicParameter,SolverParameter,[]);
%
opt = optimoptions('fsolve', ...
	'Algorithm','trust-region', ...
	'StepTolerance',1e-15, ...
	'FunctionTolerance',1e-15, ...
	'SpecifyObjectiveGradient',false, ...
	'Display','iter', ...
	'MaxIterations',40000, ...
	'MaxFunctionEvaluations',2000000, ...
	'PlotFcn',[]);
[p_Static,Force_Static,StaticFlag,output,jacobian] = ...
	fsolve(SystemForceFcn,p0,opt);
StaticError = SystemForceFcn(p_Static);
MaxAbsStaticError=max(abs(StaticError));

x0 = [q;dq;p_Static];
u0 = u;
%% Observations
% Only continuous Observations for Dynamic System
% numObservations = numel(ModelParameter.InitialState.x0);
numObservations = 10;
ObservationInfo = rlNumericSpec([numObservations 1]);
ObservationInfo.Name = ExcelFileName;
%% Actions
% Action Space can be continuous or discrete
ActionsType = 'continuous';% 'discrete''continuous'
% DriveParameter = ModelParameter.DriveParameter;
% NodalForceDriveParameter = DriveParameter.NodalForceDriveParameter;
% numActions = ...
% 	NodalForceDriveParameter.Drive_Action_Map.length;
numActions = 2;
switch ActionsType
	case 'continuous'
		ActionInfo = rlNumericSpec([numActions 1]);
		
		ActionsLowerLimit = -0*1e0*ones(numActions,1);%《-----------------------------[-1;0]
		ActionsUpperLimit =  1e0*ones(numActions,1);%《-----------------------------[1;2]
		
		ActionInfo.LowerLimit = ActionsLowerLimit;
		ActionInfo.UpperLimit = ActionsUpperLimit;
	case 'discrete'
		ActionState = {[0,0],[0,1],[1,0],[1,1]};
		ActionInfo = rlFiniteSetSpec(ActionState);
end
ActionInfo.Name = 'xv';
%% Simulation Time Tf and Sample Time Ts
Ts = 1;%《-----------------------------
Tf = 100;%《-----------------------------
%% Reset Function and Step Function
TrainingFigure = figure('Name','Training');
MechanismFigure = subplot(1,2,1,'Parent',TrainingFigure);
% ActionFigure = figure('Name','Action');
ActionFigure = subplot(1,2,2,'Parent',TrainingFigure);
% x0 = ModelParameter.InitialState.x0;
ResetHandle = ...
    @()ResetFunction_ValveControl_FoldingBoom(x0,u0);
StepHandle = ...
    @(Action,LoggedSignals)StepFunction_ValveControl_FoldingBoom(Action,LoggedSignals, ...
	ModelParameter,HydraulicParameter,SolverParameter,Ts,Tf, ...
	MechanismFigure,ActionFigure);
%% Environment
env = rlFunctionEnv(...
    ObservationInfo,ActionInfo,StepHandle,ResetHandle);
%% Set Agent
% usePretrainedAgent = false;
% PretrainedAgentDir = ...
% 	['Result\Reinforcement Learning\', ...
% 	'20201122_0628Single Rigid Cart Pole'];
if usePretrainedAgent
	%% Laod Pretrained Agent
	load([PretrainedAgentDir,'\TrainResult.mat'],'agent');
	load([PretrainedAgentDir,'\TrainResult.mat'],'trainingStats');
else
	%% Create new Agent
	AgentName = 'DDPG';
	RandomSeed = 0;
	useGPU =  false;
% 	agent = rlDQNAgent(ObservationInfo,ActionInfo);
	agent = get_DDPG_Agent(ObservationInfo,numObservations, ...
		ActionInfo,numActions, ...
		RandomSeed,useGPU,Ts,AgentName);
	fprintf('%s-Agent has been created.\n',AgentName);
end
%% Training Options
maxepisodes = 2000;
maxsteps = ceil(Tf/Ts);
SaveAgentDir = ['Result\Reinforcement Learning\', ...
	datestr(now,'yyyymmdd_HHMM'),ExcelFileName];
trainingOptions = rlTrainingOptions(...
    'MaxEpisodes',maxepisodes,...
    'MaxStepsPerEpisode',maxsteps,...
    'ScoreAveragingWindowLength',5,...
    'Verbose',false,...
    'Plots','training-progress',...
    'StopTrainingCriteria','EpisodeCount',...
    'StopTrainingValue',maxepisodes,...
    'SaveAgentCriteria','AverageReward',...
    'SaveAgentValue',10000000,...
	'SaveAgentDirectory',SaveAgentDir);
trainingOptions.UseParallel = false;

agentOptions.SaveExperienceBufferWithAgent = true;
%% Training
% doTraining = true;
if doTraining
	tic;
    trainingStats = train(agent,env,trainingOptions);
	TrainingTime = toc;
	mkdir(SaveAgentDir);
	save([SaveAgentDir,'\TrainResult']);
end
%% Simulation
simOptions = rlSimulationOptions('MaxSteps',Tf/Ts);
figure('Name','Simulation');
experience = sim(env,agent,simOptions);
figure('Name','Training Process');
hold on;
plot(trainingStats.EpisodeIndex,trainingStats.EpisodeReward,'bo-');
plot(trainingStats.EpisodeIndex,trainingStats.AverageReward,'ro-');
plot(trainingStats.EpisodeIndex,trainingStats.EpisodeQ0,'yx-');
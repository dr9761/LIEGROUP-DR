clc;clear;
close all;
%%
doTraining = true;
usePretrainedAgent = false;
ExcelFileName = ...
	'Folding Boom - Rigid 3DoF';
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
%% Observations
% Only continuous Observations for Dynamic System
% numObservations = numel(ModelParameter.InitialState.x0);
numObservations = 6;
ObservationInfo = rlNumericSpec([numObservations 1]);
ObservationInfo.Name = ExcelFileName;
%% Actions
% Action Space can be continuous or discrete
ActionsType = 'continuous';% 'discrete'
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
		ActionState = {[-10],[10]};
		ActionInfo = rlFiniteSetSpec(ActionState);
end
ActionInfo.Name = 'Force';
%% Simulation Time Tf and Sample Time Ts
Ts = 0.05;%《-----------------------------
Tf = 5;%《-----------------------------
%% Reset Function and Step Function
TrainingFigure = figure('Name','Training');
MechanismFigure = subplot(1,2,1,'Parent',TrainingFigure);
% ActionFigure = figure('Name','Action');
ActionFigure = subplot(1,2,2,'Parent',TrainingFigure);
% x0 = ModelParameter.InitialState.x0;
x0 = zeros(6,1);
x0(2) = deg2rad(5);
x0(3) = deg2rad(10);%《-----------------------------
ResetHandle = ...
    @()ResetFunction_DynamicModel(x0);
StepHandle = ...
    @(Action,LoggedSignals)StepFunction_DynamicModel(...
    Action,LoggedSignals,ModelParameter,SolverParameter,Ts,Tf, ...
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
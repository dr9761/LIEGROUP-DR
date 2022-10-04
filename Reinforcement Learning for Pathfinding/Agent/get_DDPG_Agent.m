function agent = get_DDPG_Agent(ObservationInfo,numObservations, ...
	ActionInfo,numActions, ...
	RandomSeed,useGPU,Ts,AgentName)
%% RandomSeed
rng(RandomSeed);
%% Critic Network
StatePath = [...
    featureInputLayer(numObservations,'Normalization','none','Name','observation');
    fullyConnectedLayer(128,'Name','CriticStateFC1');
    reluLayer('Name','CriticRelu1');
    fullyConnectedLayer(200,'Name','CriticStateFC2')];
ActionPath = [...
    featureInputLayer(numActions,'Normalization','none','Name','action');
    fullyConnectedLayer(200,'Name','CriticActionFC1','BiasLearnRateFactor',0)];
CommomPath = [...
    additionLayer(2,'Name','add');
    reluLayer('Name','CriticCommonRelu');
    fullyConnectedLayer(1,'Name','CriticOutput')];

CriticNetwork = layerGraph(StatePath);
CriticNetwork = addLayers(CriticNetwork,ActionPath);
CriticNetwork = addLayers(CriticNetwork,CommomPath);

CriticNetwork = connectLayers(CriticNetwork,'CriticStateFC2','add/in1');
CriticNetwork = connectLayers(CriticNetwork,'CriticActionFC1','add/in2');
%% Critic
criticOptions = rlRepresentationOptions(...
	'LearnRate',1e-03,'GradientThreshold',1);
if useGPU
    criticOptions.UseDevice = "gpu";
end
critic = rlQValueRepresentation(...
	CriticNetwork,ObservationInfo,ActionInfo, ...
    'Observation',{'observation'},'Action',{'action'}, ...
	criticOptions);
%% Actor Network
switch class(ActionInfo)
	case 'rl.util.rlNumericSpec'
		actorNetwork = [
			featureInputLayer(numObservations,'Normalization','none','Name','observation')
			fullyConnectedLayer(128,'Name','ActorFC1')
			reluLayer('Name','ActorRelu1')
			fullyConnectedLayer(200,'Name','ActorFC2')
			reluLayer('Name','ActorRelu2')
			fullyConnectedLayer(numActions,'Name','ActorFC3')
			tanhLayer('Name','ActorTanh1')
			scalingLayer('Name','ActorScaling','Scale',max(ActionInfo.UpperLimit))];
	case 'rl.util.rlFiniteSetSpec'
		actorNetwork = [
			featureInputLayer(numObservations,'Normalization','none','Name','observation')
			fullyConnectedLayer(128,'Name','ActorFC1')
			reluLayer('Name','ActorRelu1')
			fullyConnectedLayer(200,'Name','ActorFC2')
			reluLayer('Name','ActorRelu2')
			fullyConnectedLayer(numActions,'Name','ActorFC3')
			tanhLayer('Name','ActorScaling')];
end
%% Actor
actorOptions = rlRepresentationOptions(...
	'LearnRate',5e-04,'GradientThreshold',1);
if useGPU
    actorOptions.UseDevice = 'gpu';
end
actor = rlDeterministicActorRepresentation(...
	actorNetwork,ObservationInfo,ActionInfo,...
    'Observation',{'observation'},'Action',{'ActorScaling'}, ...
	actorOptions);
%% DDPG Agent
agentOptions = rlDDPGAgentOptions(...
    'SampleTime',Ts,...
    'TargetSmoothFactor',1e-3,...
    'ExperienceBufferLength',1e6,...
    'MiniBatchSize',128);
agentOptions.NoiseOptions.Variance = 0.4;
agentOptions.NoiseOptions.VarianceDecayRate = 1e-5;

agent = rlDDPGAgent(actor,critic,agentOptions);
%% Plot Agent
figure('Name',AgentName);
%
subplot(1,2,1);
plot(layerGraph(actorNetwork));
title('Actor');
%
subplot(1,2,2);
plot(CriticNetwork);
title('Critic');
pause(0.01);
end
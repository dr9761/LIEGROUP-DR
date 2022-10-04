function [dydt] = Multi_Body_Dynamics_func(t,y,x0,tspan,ModelParameter,SolverParameter,CalcPlotFigure)
%%

g = ModelParameter.g;
BodyElementParameter = ModelParameter.BodyElementParameter;
Frame_Joint_Parameter = ModelParameter.Frame_Joint_Parameter;
Joint_Parameter = ModelParameter.Joint_Parameter;
ConstraintParameter = ModelParameter.ConstraintParameter;
NodalForceParameter = ModelParameter.NodalForceParameter;
DriveParameter = ModelParameter.DriveParameter;
L = BodyElementParameter{1}.L; %% nur ein Body
BodyQuantity = numel(BodyElementParameter);

dydt = zeros(36,1);
RA = (y(1:9));
xA = (y(10:12));
RB = (y(13:21));
xB = (y(22:24));
vA = (y(24:30));
vB = (y(31:36));

HA = [RA(1:3)' xA(1);RA(4:6)' xA(2);RA(7:9)' xA(3);0 0 0 1];
HB = [RB(1:3)' xB(1);RB(4:6)' xB(2);RB(7:9)' xB(3);0 0 0 1];
RskewA = Rskew(RA);
RskewB = Rskew(RB);


% get d and epsilon
d =logSE3(HA,HB)/L;
d0 = [L 0 0 0 0 0]'/L;
epsilon = (d - d0)/L;

%% pre-processing
PreProcessingMethode = 'None';
[q0,dq0,x0,ModelParameter] = ModelPreProcessing(PreProcessingMethode,t,x0,tspan,ModelParameter);
%% get q and dq from x0
q = x0(1:numel(x0)/2);
dq = x0(numel(x0)/2+1:end);
%% Display Time
if SolverParameter.ComputingDisplay.DisplayTime
	fprintf('t = %16.14f\n',t);
end
%% Mechanisum Plot
persistent IterationNr;
if SolverParameter.ComputingDisplay.PlotMechanisum
	IterationNr = plot_Mechanisum_by_Computing(...
		q,t,ModelParameter,SolverParameter, ...
		CalcPlotFigure,IterationNr,tspan);
end


%% Set Frame
Frame.Joint = set_Frame_Joint(q0,dq0,Frame_Joint_Parameter);
Frame.T_qe_q = zeros(6,numel(q));
Frame.BodyType = 'Rigid Body';

%%
Body = cell(BodyQuantity,1);
for BodyNr = 1:BodyQuantity
    Body{BodyNr}.BodyType = ...
		BodyElementParameter{BodyNr}.BodyType;

   	BodyCoordinate = ...
		BodyElementParameter{BodyNr}.GlobalCoordinate;
    
    qe  = q(BodyCoordinate);
	dqe = dq(BodyCoordinate);
	T_qe_q = zeros(numel(BodyCoordinate),numel(q));
	T_qe_q(:,BodyCoordinate) = eye(numel(BodyCoordinate));
	
	Body{BodyNr}.T_qe_q = T_qe_q;
	%%
	[Body{BodyNr}.Mass,Body{BodyNr}.Force] = get_Element_MassForce(g,d,epsilon,BodyElementParameter{BodyNr});
    
	Body{BodyNr}.Joint = set_Joint(...
		qe,dqe,BodyElementParameter,BodyNr,Joint_Parameter);
end
% get Mass and Force
[SystemForceFcn] = Multi_Body_Dynamics_Force(x0,epsilon,d,tspan, ...
		ModelParameter,SolverParameter);
[MassMtx] = Multi_Body_Dynamics_Mass(x0,epsilon,d,tspan, ...
		ModelParameter,SolverParameter);

%% add Constraint
[Phi,B,dPhi,Tau] = add_Constraint(q,dq,Frame,Body, ...
	BodyElementParameter,ConstraintParameter);
%% Baumgartner Stability Method
[ddq,~] = Baumgartner_Stability_Method(MassMtx,SystemForceFcn, ...
	Phi,dPhi,B,Tau);

%%
vAomega = vA(4:6);
vAu = vA(1:3);
vBomega = vB(4:6);
vBu = vB(1:3);
RAo = [RA(1:3)';RA(4:6)';RA(7:9)'];
RBo = [RB(1:3)';RB(4:6)';RB(7:9)'];

dydt(1:9) = zeros(9,1);
dydt(1:9) = RskewA*vAomega;
dydt(10:12) = zeros(3,1);
dydt(10:12) = RAo*vAu;
dydt(13:21)= zeros(9,1);
dydt(13:21) = RskewB*vBomega;
dydt(22:24) = zeros(3,1);
dydt(22:24) = RBo*vBu;
dydt(25:36) = ddq;

end
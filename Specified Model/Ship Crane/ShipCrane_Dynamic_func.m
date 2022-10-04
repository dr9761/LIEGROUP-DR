function dx = ShipCrane_Dynamic_func(t,x, ...
	DesignedTrajectoryFuncCell_ShipCrane,ModelParameter,ComputingAxes)
ddr3dtdt_FitFunc_Cell = DesignedTrajectoryFuncCell_ShipCrane.ddr3dtdt_FitFunc_Cell;
dr3dt_FitFunc_Cell = DesignedTrajectoryFuncCell_ShipCrane.dr3dt_FitFunc_Cell;
r3_FitFunc_Cell = DesignedTrajectoryFuncCell_ShipCrane.r3_FitFunc_Cell;
if t<0 || t>20-0.1
	ddr3dtdt = zeros(3,1);
else
	ddr3dtdt = nan(3,1);
	ddr3dtdt(1) = ddr3dtdt_FitFunc_Cell{1}(t);
	ddr3dtdt(2) = ddr3dtdt_FitFunc_Cell{2}(t);
	ddr3dtdt(3) = ddr3dtdt_FitFunc_Cell{3}(t);
end
if t<0
	dr3dt_ideal = zeros(3,1);
	r3_ideal = zeros(3,1);
elseif t>20
	dr3dt_ideal = nan(3,1);
	dr3dt_ideal(1) = dr3dt_FitFunc_Cell{1}(20);
	dr3dt_ideal(2) = dr3dt_FitFunc_Cell{2}(20);
	dr3dt_ideal(3) = dr3dt_FitFunc_Cell{3}(20);
	
	r3_ideal = nan(3,1);
	r3_ideal(1) = r3_FitFunc_Cell{1}(20);
	r3_ideal(2) = r3_FitFunc_Cell{2}(20);
	r3_ideal(3) = r3_FitFunc_Cell{3}(20);
else	
	dr3dt_ideal = nan(3,1);
	dr3dt_ideal(1) = dr3dt_FitFunc_Cell{1}(t);
	dr3dt_ideal(2) = dr3dt_FitFunc_Cell{2}(t);
	dr3dt_ideal(3) = dr3dt_FitFunc_Cell{3}(t);
	
	r3_ideal = nan(3,1);
	r3_ideal(1) = r3_FitFunc_Cell{1}(t);
	r3_ideal(2) = r3_FitFunc_Cell{2}(t);
	r3_ideal(3) = r3_FitFunc_Cell{3}(t);
end
%%
q = x(1:numel(x)/2);
dq = x(numel(x)/2+1:end);
s = zeros(6,1);
%%
u = ShipCrane_InverseDynamic(q,dq,s,ddr3dtdt,ModelParameter);

%
[r0n,~,dqn,~,~,~] = ShipCrane_ForwardKinematics(...
	q,dq,zeros(size(dq)),ModelParameter);
r3 = r0n{3};
dr3dt = dqn{3}(1:3);
%
delta_r3 = r3_ideal - r3;
delta_dr3dt = dr3dt_ideal - dr3dt;
Kv = 10^3*diag([1,1,1]);
Kp = 0*diag([1,1,1]);
u = 0 * u + Kv * delta_dr3dt + Kp * delta_r3;
%
[ddq,~,~,~,~] = ...
	ShipCrane_ForwardDynamic(q,dq,s,u,ModelParameter);
%
dqdt = dq;
dqdt(4:6) = get_T(q(4:6)) \ dq(4:6);
dx = [dqdt;ddq];
%%
if true && ~isempty(ComputingAxes)
% 	[r0n,~,~,~,~,~] = ShipCrane_ForwardKinematics(...
% 		q,dq,ddq,ModelParameter);
	position_set = [q(1:3),r0n{1},r0n{2},r0n{3}];
	plot3(ComputingAxes,position_set(1,:),position_set(2,:),position_set(3,:),'r.-');
	axis(ComputingAxes,[-6,6,-6,6,-2,10]);
	grid(ComputingAxes,'on');grid(ComputingAxes,'MINOR');
	drawnow;
	fprintf('t = %16.14f\n',t);
end
end
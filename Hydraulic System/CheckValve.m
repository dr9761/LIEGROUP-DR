function [Q,FlowDirection] = CheckValve(...
	p1,p2,ValveParameter,HydraulicOilParameter)
%% p1 > p2 -> Q > 0
%% p1 < p2 -> Q = 0
%% tanh instead step function
OpeningPressure = ValveParameter.pmin;
ClosingPressure = max(ValveParameter.pmax,1.01*OpeningPressure);
PressureSpan = [OpeningPressure;ClosingPressure];
xv = tanh_Substitute(p2,PressureSpan,[0;1],0.995);
%%
[Q,FlowDirection] = HydraulicValve_Flow_Function(xv,p1,p2, ...
	ValveParameter,HydraulicOilParameter);
end
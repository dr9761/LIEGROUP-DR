function [Q,FlowDirection] = BackPressureValve(...
	p1,p2,ValveParameter,HydraulicOilParameter)
%% p_out = back pressure
% p1 = ValveState.p_in;
% p2 = ValveState.p_out;
%% tanh instead step function
BackPressure = ValveParameter.pmin;
FullOpenPressure = ValveParameter.pmax;
PressureSpan = [BackPressure;FullOpenPressure];
xv = tanh_Substitute(p2,PressureSpan,[0;1],0.995);
%%
[Q,FlowDirection] = HydraulicValve_Flow_Function(xv,p1,p2, ...
	ValveParameter,HydraulicOilParameter);
end
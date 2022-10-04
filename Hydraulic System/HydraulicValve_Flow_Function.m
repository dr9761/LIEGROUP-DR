function [Q,FlowDirection] = HydraulicValve_Flow_Function(xv,p1,p2, ...
	ValveParameter,HydraulicOilParameter)
%%
% p1 = ValveState.p1;
% p2 = ValveState.p2;
%
A = ValveParameter.A;
cq = ValveParameter.cq;
ValveType = ValveParameter.Type;
%
rho = HydraulicOilParameter.rho;
%%
delta_p = p1 - p2;
switch ValveType
	case 'Ideal Spool Valve'
		A0 = A * xv;
	case 'Spool Valve'
% 		A0 = A * sqrt(xv^2 + delta^2);
	case 'Cone Valve'
% 		A0 = pi*dm*sin(alpha)*(1-pi/(2*dm)*sin(2*alpha)) * xv;
end
%%
Q = cq*A0*sqrt(2*sqrt(delta_p^2)/rho);
FlowDirection = sign(delta_p);
end
function [y,dydx,ddydxdx] = tanh_Substitute(x,xspan,yspan,Confidence)
%%
% 99.9% 3.8088
% 99.5% 2.9980
% 99.0% 2.6476
% 95.0% 1.8368
% 90.0% 1.4765
Confidence_Set = ...
	[0.700;		0.800;		0.900;		0.950;		0.990;		0.995;		0.999];
ConfidenceIntervalCoefficient_Set = ...
	[0.8673;	1.0987;		1.4765;		1.8368;		2.6476;		2.9980;		3.8088];
Confidence_Pos = find(Confidence_Set>=Confidence);
if isempty(Confidence_Pos)
	ConfidenceIntervalCoefficient = ...
		ConfidenceIntervalCoefficient_Set(end);
else
	ConfidenceIntervalCoefficient = ...
		ConfidenceIntervalCoefficient_Set(Confidence_Pos(1));
end
%%
x_Interval = max(xspan) - min(xspan);
x_aver = (max(xspan) + min(xspan)) / 2;
x_adjust = 2*ConfidenceIntervalCoefficient/x_Interval*(x - x_aver);
%%
y_adjust = tanh(x_adjust);
% y_Interval = max(yspan) - min(yspan);
% y_aver = (max(yspan) + min(yspan)) / 2;
y_Interval = yspan(2) - yspan(1);
y_aver = (yspan(1) + yspan(2)) / 2;
y = y_adjust/2*y_Interval + y_aver;
%%
dydx = ConfidenceIntervalCoefficient*y_Interval/x_Interval*(1-(y_adjust)^2);
ddydxdx = -4*ConfidenceIntervalCoefficient/x_Interval*y_adjust*(1-(y_adjust)^2);
	
end
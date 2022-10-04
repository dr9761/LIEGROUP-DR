%% show_tanh_Substitute
clear; close all;
xspan = [5;15];
yspan = [10;20];
Confidence_Set = ...
	[0.700;		0.800;		0.900;		0.950;		0.990;		0.995;		0.999];
x_set = linspace(0,20);
y_set = nan(numel(Confidence_Set),numel(x_set));
dydt_set = nan(numel(Confidence_Set),numel(x_set));
ddydtdt_set = nan(numel(Confidence_Set),numel(x_set));
for ConfidenceNr = 1:numel(Confidence_Set)
	Confidence = Confidence_Set(ConfidenceNr);
	for xNr = 1:numel(x_set)
		x = x_set(xNr);
		[y_set(ConfidenceNr,xNr), ...
			dydt_set(ConfidenceNr,xNr), ...
			ddydtdt_set(ConfidenceNr,xNr)] = ...
			tanh_Substitute(x,xspan,yspan,Confidence);
	end
end
cosFigure = figure('Name','tanh Figure');
s_Axes = subplot(3,1,1,'Parent',cosFigure);
v_Axes = subplot(3,1,2,'Parent',cosFigure);
a_Axes = subplot(3,1,3,'Parent',cosFigure);
plot(s_Axes,x_set,y_set);
plot(v_Axes,x_set,dydt_set);
plot(a_Axes,x_set,ddydtdt_set);

title(s_Axes,'Position');		xlabel(s_Axes,'Time');ylabel(s_Axes,'Position');
title(v_Axes,'Velocity');		xlabel(v_Axes,'Time');ylabel(v_Axes,'Velocity');
title(a_Axes,'Acceleration');	xlabel(a_Axes,'Time');ylabel(a_Axes,'Acceleration');

grid(s_Axes,'on');grid(s_Axes,'MINOR');
grid(v_Axes,'on');grid(v_Axes,'MINOR');
grid(a_Axes,'on');grid(a_Axes,'MINOR');

legend(s_Axes,'c=70.0%','c=80.0%','c=90.0%','c=95.0%','c=90.0%','c=99.5%','c=99.9%', ...
	'Location','eastoutside');
legend(v_Axes,'c=70.0%','c=80.0%','c=90.0%','c=95.0%','c=90.0%','c=99.5%','c=99.9%', ...
	'Location','eastoutside');
legend(a_Axes,'c=70.0%','c=80.0%','c=90.0%','c=95.0%','c=90.0%','c=99.5%','c=99.9%', ...
	'Location','eastoutside');
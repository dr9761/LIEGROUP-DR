function cos_Substitute(t,x_range,t_range)
if nargin == 0
    t = [];
    x_range = [10,20];
    t_range = [5,15];
    close all;
end
%% from x_start->x_end
%% t_start > t_end
t_start = min(t_range);
t_end   = max(t_range);
t_Interval = t_end - t_start;
t_set   = linspace(t_start-0.1*t_Interval,t_end+0.1*t_Interval);
t_set   = linspace(0,20,1000);

x_start = x_range(1);
x_end   = x_range(2);

x_set       = nan(size(t_set));
dxdt_set    = nan(size(t_set));
ddxdtdt_set = nan(size(t_set));
for t_Nr = 1:numel(t_set)
    t = t_set(t_Nr);
    if t < t_start
        x = x_start;
        dxdt = 0;
        ddxdtdt = 0;
    elseif t > t_end
        x = x_end;
        dxdt = 0;
        ddxdtdt = 0;
    else
        x = x_start + ...
            1/2*(x_end-x_start)*(1-cos(pi*(t-t_start)/(t_end-t_start)));
        dxdt = -pi/2*(x_start-x_end)/(t_start-t_end)*sin(pi*(t-t_start)/(t_end-t_start));
        ddxdtdt = -pi^2/2*(x_start-x_end)/((t_start-t_end)^2)*cos(pi*(t-t_start)/(t_end-t_start));
    end
    
    x_set(t_Nr) = x;
    dxdt_set(t_Nr) = dxdt;
    ddxdtdt_set(t_Nr) = ddxdtdt;
end
cosFigure = figure('Name','cos Figure');
s_Axes = subplot(3,1,1,'Parent',cosFigure);
v_Axes = subplot(3,1,2,'Parent',cosFigure);
a_Axes = subplot(3,1,3,'Parent',cosFigure);
plot(s_Axes,t_set,x_set);
plot(v_Axes,t_set,dxdt_set);
plot(a_Axes,t_set,ddxdtdt_set);

title(s_Axes,'Position');		xlabel(s_Axes,'Time');ylabel(s_Axes,'Position');
title(v_Axes,'Velocity');		xlabel(v_Axes,'Time');ylabel(v_Axes,'Velocity');
title(a_Axes,'Acceleration');	xlabel(a_Axes,'Time');ylabel(a_Axes,'Acceleration');

grid(s_Axes,'on');grid(s_Axes,'MINOR');
grid(v_Axes,'on');grid(v_Axes,'MINOR');
grid(a_Axes,'on');grid(a_Axes,'MINOR');

axis(s_Axes,[0,20,5,25]);
axis(v_Axes,[0,20,-2,0.5]);
axis(a_Axes,[0,20,-1,1]);
end
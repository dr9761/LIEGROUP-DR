clear;close all;
t1 = 2;
t2 = 6;
t3 = 2;
t0 = t1 + t2 + t3;
v0 = -pi/10;
dflag = 0;
s0 = v0*(1/2*t1+t2+1/2*t3);
v_set = [];
a_set = [];
s_set = [];
t_set = linspace(-0.2*(t1+t2+t3), ...
	1.2*(t1+t2+t3),1000);
%%
s0 = pi/2;
t0 = 30;
t1 = 5;
t3 = 5;
t_set = linspace(-0.1*t0,1.1*t0,1000);
t_set = 0:0.1:t0;
for t = t_set
% 	[st,vt,at]=velocity_function_Test(t,t1,t2,t3,v0,dflag);
% 	[st,vt,at] = ThreeStage_PolyFunc(t,t1,t2,t3,v0);
	[st,vt,at] = ThreeStage_PolyFunc_2(t,s0,t0,t1,t3);
% 	[st,vt,at] = ...
% 		TrapezoidalVelocity_ThreeStage_Func_2(t,s0,t0,t1,t3);
	
	v_set = [v_set,vt];
	a_set = [a_set,at];
	s_set = [s_set,st];
end
%% delete uniform speed phase
% s_set = [s_set(t_set<=t1),s_set(t_set>=t0-t3)];
% v_set = [v_set(t_set<=t1),v_set(t_set>=t0-t3)];
% a_set = [a_set(t_set<=t1),a_set(t_set>=t0-t3)];
% t_set = [t_set(t_set<=t1),t_set(t_set>=t0-t3)];

ActionData = [t_set',s_set',v_set',a_set'];
%%
ActionFigure = figure('Name','Action Function Test');
s_axes = subplot(1,3,1,'Parent',ActionFigure);
v_axes = subplot(1,3,2,'Parent',ActionFigure);
a_axes = subplot(1,3,3,'Parent',ActionFigure);

plot(s_axes,t_set,s_set,'LineWidth',1);
axis(s_axes,[0,t0,0,2]);title(s_axes,'Position');
grid(s_axes,'on');grid(s_axes,'MINOR');
xlabel(s_axes,'Time[s]');ylabel(s_axes,'Position[m]');

plot(v_axes,t_set,v_set,'LineWidth',1);
axis(v_axes,[0,t0,0,0.1]);title(v_axes,'Velocity');
grid(v_axes,'on');grid(v_axes,'MINOR');
xlabel(v_axes,'Time[s]');ylabel(v_axes,'Velocity[m]');

plot(a_axes,t_set,a_set,'LineWidth',1);
axis(a_axes,[0,t0,-0.02,0.02]);title(a_axes,'Acceleration');
grid(a_axes,'on');grid(a_axes,'MINOR');
xlabel(a_axes,'Time[s]');ylabel(a_axes,'Acceleration[m]');
% hold(s_axes,'on');
% hold(v_axes,'on');
% hold(a_axes,'on');
% legend('s','v','a');
%%
x_min = min(s_set);
x_max = max(s_set);
v_max = max(abs(v_set));
a_max = max(abs(a_set));
fprintf('Moving Range:[%f,\t%f]\n',x_min,x_max);
fprintf('Maximum Velocity:     %f\n',v_max);
fprintf('Maximum Acceleration: %f\n',a_max);
%%
% ExcelFileName = ['Action\Action Function Data Sheet\', ...
% 	'Trapezoidal Velocity 3-Stage(s0=',num2str(s0), ...
% 	',t0=',num2str(t0),',',num2str(t1),',',num2str(t3),').xlsx'];
% writecell({'t','s','v','a'}, ...
% 	ExcelFileName, ...
% 	'Range','A1');
% writematrix(ActionData, ...
% 	ExcelFileName, ...
% 	'Range','A2');
%%
function [s,v,a]=velocity_function_Test(t,t1,t2,t3,v0,dflag)
%UNTITLED2 �0�7�0�9�0�7�0�7�0�3�0�8�0�8�0�6�0�7�0�4�0�1�0�1�0�7�0�9�0�2�0�4�0�8�0�5�0�8�0�2�0�9�0�9�0�6�0�9
%   �0�7�0�9�0�7�0�7�0�3�0�8�0�8�0�6�0�3ê�0�3�0�0�0�9�0�8�0�1÷
if 0<=t && t<=t1
   v=v0*t^2*(3*t1-2*t)/t1^3;
   s=v0*t^3*(t1-1/2*t)/t1^3;
   a=6*v0*t*(t1-t)/t1^3;
end
if t1<t && t<t1+t2
   v=v0;
   s=1/2*v0*t1+v0*(t-t1);
   a=0; 
end
if t1+t2<=t && t<=t1+t2+t3
   v=v0*(t1+t2+t3-t)^2*(t3+2*t-2*t1-2*t2)/t3^3;
   s=1/2*v0*t1+v0*t2+v0*((t-t1-t2)-(t3*(t-t1-t2)^3-1/2*(t-t1-t2)^4)/t3^3);
   a=v0*6*(t1+t2-t)*(t1+t2+t3-t)/t3^3;
end

if dflag==1
 v=0;
 a=0;
 s=0;
end
end


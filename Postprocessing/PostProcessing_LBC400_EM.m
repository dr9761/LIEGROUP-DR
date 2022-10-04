%% ========== PostProcessing_LBC400_EM =============
%% PostProcessing
%% Lattice Boom Crane 400t(LBC400)
%% Elementar Motion(EM)
%% =================================================
clear;clc;close all;
%%
load('Result\Lattice Boom Crane\Elementar Motion\400t Lifting\Result.mat','t_set','x_set');
FigureObj = figure('Name','400t Lifting');
StateAxes = subplot(2,2,1,'Parent',FigureObj);
VelocityAxes = subplot(2,2,3,'Parent',FigureObj);
PositionAxes = subplot(2,2,[2,4],'Parent',FigureObj);
q_set = x_set(:,1:end/2);
dq_set = x_set(:,end/2+1:end);
plot(StateAxes,t_set,q_set(:,end-5:end-3));
plot(VelocityAxes,t_set,dq_set(:,end-5:end-3));
plot3(PositionAxes,q_set(:,end-5),q_set(:,end-4),q_set(:,end-3));
axis(PositionAxes,[-25,5,-15,15,-5,25]);

grid(StateAxes,'on');grid(StateAxes,'MINOR');
grid(VelocityAxes,'on');grid(VelocityAxes,'MINOR');
grid(PositionAxes,'on');grid(PositionAxes,'MINOR');
legend(StateAxes,'x','y','z');
legend(VelocityAxes,'v_x','v_y','v_z');
xlabel(StateAxes,'Time');ylabel(StateAxes,'Position');
xlabel(VelocityAxes,'Time');ylabel(VelocityAxes,'Velocity');
xlabel(PositionAxes,'x');ylabel(PositionAxes,'y');zlabel(PositionAxes,'z');
title(StateAxes,'Time-State');
title(VelocityAxes,'Time-Velocity');
title(PositionAxes,'Position');
%%
clear;
load('Result\Lattice Boom Crane\Elementar Motion\400t Luffing\Result.mat','t_set','x_set');
FigureObj = figure('Name','400t Luffing');
StateAxes = subplot(2,2,1,'Parent',FigureObj);
VelocityAxes = subplot(2,2,3,'Parent',FigureObj);
PositionAxes = subplot(2,2,[2,4],'Parent',FigureObj);
q_set = x_set(:,1:end/2);
dq_set = x_set(:,end/2+1:end);
plot(StateAxes,t_set,q_set(:,end-5:end-3));
plot(VelocityAxes,t_set,dq_set(:,end-5:end-3));
plot3(PositionAxes,q_set(:,end-5),q_set(:,end-4),q_set(:,end-3));
axis(PositionAxes,[-40,-10,-15,15,-10,10]);

grid(StateAxes,'on');grid(StateAxes,'MINOR');
grid(VelocityAxes,'on');grid(VelocityAxes,'MINOR');
grid(PositionAxes,'on');grid(PositionAxes,'MINOR');
legend(StateAxes,'x','y','z');
legend(VelocityAxes,'v_x','v_y','v_z');
xlabel(StateAxes,'Time');ylabel(StateAxes,'Position');
xlabel(VelocityAxes,'Time');ylabel(VelocityAxes,'Velocity');
xlabel(PositionAxes,'x');ylabel(PositionAxes,'y');zlabel(PositionAxes,'z');
title(StateAxes,'Time-State');
title(VelocityAxes,'Time-Velocity');
title(PositionAxes,'Position');
%%
clear;
load('Result\Lattice Boom Crane\Elementar Motion\400t Slewing\Result.mat','t_set','x_set');
FigureObj = figure('Name','400t Slewing');
StateAxes = subplot(2,2,1,'Parent',FigureObj);
VelocityAxes = subplot(2,2,3,'Parent',FigureObj);
PositionAxes = subplot(2,2,[2,4],'Parent',FigureObj);
q_set = x_set(:,1:end/2);
dq_set = x_set(:,end/2+1:end);
plot(StateAxes,t_set,q_set(:,end-5:end-3));
plot(VelocityAxes,t_set,dq_set(:,end-5:end-3));
plot3(PositionAxes,q_set(:,end-5),q_set(:,end-4),q_set(:,end-3));
axis(PositionAxes,[-15,5,-15,5,-10,10]);

grid(StateAxes,'on');grid(StateAxes,'MINOR');
grid(VelocityAxes,'on');grid(VelocityAxes,'MINOR');
grid(PositionAxes,'on');grid(PositionAxes,'MINOR');
legend(StateAxes,'x','y','z');
legend(VelocityAxes,'v_x','v_y','v_z');
xlabel(StateAxes,'Time');ylabel(StateAxes,'Position');
xlabel(VelocityAxes,'Time');ylabel(VelocityAxes,'Velocity');
xlabel(PositionAxes,'x');ylabel(PositionAxes,'y');zlabel(PositionAxes,'z');
title(StateAxes,'Time-State');
title(VelocityAxes,'Time-Velocity');
title(PositionAxes,'Position');
%%
clear;
load('Result\Lattice Boom Crane\Elementar Motion\400t Combined\Result.mat','t_set','x_set');
FigureObj = figure('Name','400t Combined');
StateAxes = subplot(2,2,1,'Parent',FigureObj);
VelocityAxes = subplot(2,2,3,'Parent',FigureObj);
PositionAxes = subplot(2,2,[2,4],'Parent',FigureObj);
q_set = x_set(:,1:end/2);
dq_set = x_set(:,end/2+1:end);
plot(StateAxes,t_set,q_set(:,end-5:end-3));
plot(VelocityAxes,t_set,dq_set(:,end-5:end-3));
plot3(PositionAxes,q_set(:,end-5),q_set(:,end-4),q_set(:,end-3));
axis(PositionAxes,[-25,15,-35,5,-10,30]);

grid(StateAxes,'on');grid(StateAxes,'MINOR');
grid(VelocityAxes,'on');grid(VelocityAxes,'MINOR');
grid(PositionAxes,'on');grid(PositionAxes,'MINOR');
legend(StateAxes,'x','y','z');
legend(VelocityAxes,'v_x','v_y','v_z');
xlabel(StateAxes,'Time');ylabel(StateAxes,'Position');
xlabel(VelocityAxes,'Time');ylabel(VelocityAxes,'Velocity');
xlabel(PositionAxes,'x');ylabel(PositionAxes,'y');zlabel(PositionAxes,'z');
title(StateAxes,'Time-State');
title(VelocityAxes,'Time-Velocity');
title(PositionAxes,'Position');




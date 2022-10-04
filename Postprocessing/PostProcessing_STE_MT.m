%% ============ PostProcessing_STE_MT ============
%% PostProcessing
%% Super Truss Element Mulit-Test(STE)
%% Mulit-Test(MT)
%% ===============================================
clear;close all;clc;
%%
figure('Name','Viberation under Self Gravity');
load('Result\Super Truss Element\Self Gravity\Result.mat','t_set','x_set');
q_set = x_set(:,1:end/2);
t_set = t_set(t_set <= 0.5);
q_set = q_set(t_set <= 0.5,:);
plot(t_set,q_set(:,end-3));
title('z_{end}');xlabel('Time');ylabel('z_{end}');
grid on;grid MINOR;
%%
clear;
figure('Name','cos-Angle Drive');
load('Result\Super Truss Element\cos-Angle Drive\Result.mat','t_set','x_set');
q_set = x_set(:,1:end/2);
plot(t_set,q_set(:,end-3));
title('z_{end}');xlabel('Time');ylabel('z_{end}');
grid on;grid MINOR;
%%
clear;
figure('Name','Torque Drive');
load('Result\Super Truss Element\Torque Drive\Result.mat','t_set','x_set');
q_set = x_set(:,1:end/2);
plot(t_set,q_set(:,end-3));
title('z_{end}');xlabel('Time');ylabel('z_{end}');
grid on;grid MINOR;
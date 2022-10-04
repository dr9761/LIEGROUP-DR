mkdir('Result');
%% Rigid Body
clc;clear;close all;
configs.ExcelFileName = ...
	'Rigid Beam Pendulum Angle Drive';
configs.ExcelFileDir = 'Parameter File\Pendulum Angle Drive';
configs.opt = odeset('RelTol',0.01,'AbsTol',0.01,'MaxStep',0.01);
configs.Static_Start_Position = false;
configs.max_VelocityAcceleration_Tolerance = 1e-3;
configs.tspan = [0 10];
SolveParameter_func(configs);
pause(100);
%% Timoshenko Beam 1 Segment
clc;clear;close all;
configs.ExcelFileName = ...
	'Timoshenko Beam Pendulum Angle Drive - 1 Segments';
configs.ExcelFileDir = 'Parameter File\Pendulum Angle Drive';
configs.opt = odeset('RelTol',0.01,'AbsTol',0.01,'MaxStep',0.01);
configs.Static_Start_Position = false;
configs.max_VelocityAcceleration_Tolerance = 1e-3;
configs.tspan = [0 10];
SolveParameter_func(configs);
pause(100);
%% Timoshenko Beam 3 Segment
clc;clear;close all;
configs.ExcelFileName = ...
	'Timoshenko Beam Pendulum Angle Drive - 3 Segments';
configs.ExcelFileDir = 'Parameter File\Pendulum Angle Drive';
configs.opt = odeset('RelTol',0.01,'AbsTol',0.01,'MaxStep',0.01);
configs.Static_Start_Position = false;
configs.max_VelocityAcceleration_Tolerance = 1e-3;
configs.tspan = [0 10];
SolveParameter_func(configs);
pause(100);
%% Timoshenko Beam 5 Segment
clc;clear;close all;
configs.ExcelFileName = ...
	'Timoshenko Beam Pendulum Angle Drive - 5 Segments';
configs.ExcelFileDir = 'Parameter File\Pendulum Angle Drive';
configs.opt = odeset('RelTol',0.01,'AbsTol',0.01,'MaxStep',0.01);
configs.Static_Start_Position = false;
configs.max_VelocityAcceleration_Tolerance = 1e-3;
configs.tspan = [0 10];
SolveParameter_func(configs);
pause(100);
%% Timoshenko Beam 10 Segment
clc;clear;close all;
configs.ExcelFileName = ...
	'Timoshenko Beam Pendulum Angle Drive - 10 Segments';
configs.ExcelFileDir = 'Parameter File\Pendulum Angle Drive';
configs.opt = odeset('RelTol',0.01,'AbsTol',0.01,'MaxStep',0.01);
configs.Static_Start_Position = false;
configs.max_VelocityAcceleration_Tolerance = 1e-3;
configs.tspan = [0 10];
SolveParameter_func(configs);
pause(100);
%% Cubic Spline Beam 1 Segment
clc;clear;close all;
configs.ExcelFileName = ...
	'Cubic Spline Beam Pendulum Angle Drive - 1 Segments';
configs.ExcelFileDir = 'Parameter File\Pendulum Angle Drive';
configs.opt = odeset('RelTol',0.01,'AbsTol',0.01,'MaxStep',0.01);
configs.Static_Start_Position = false;
configs.max_VelocityAcceleration_Tolerance = 1e-3;
configs.tspan = [0 10];
SolveParameter_func(configs);
pause(100);
%% Cubic Spline Beam 3 Segment
clc;clear;close all;
configs.ExcelFileName = ...
	'Cubic Spline Beam Pendulum Angle Drive - 3 Segments';
configs.ExcelFileDir = 'Parameter File\Pendulum Angle Drive';
configs.opt = odeset('RelTol',0.01,'AbsTol',0.01,'MaxStep',0.01);
configs.Static_Start_Position = false;
configs.max_VelocityAcceleration_Tolerance = 1e-3;
configs.tspan = [0 10];
SolveParameter_func(configs);
pause(100);
%% Cubic Spline Beam 5 Segment
clc;clear;close all;
configs.ExcelFileName = ...
	'Cubic Spline Beam Pendulum Angle Drive - 5 Segments';
configs.ExcelFileDir = 'Parameter File\Pendulum Angle Drive';
configs.opt = odeset('RelTol',0.01,'AbsTol',0.01,'MaxStep',0.01);
configs.Static_Start_Position = false;
configs.max_VelocityAcceleration_Tolerance = 1e-3;
configs.tspan = [0 10];
SolveParameter_func(configs);
pause(100);
%% Cubic Spline Beam 10 Segment
clc;clear;close all;
configs.ExcelFileName = ...
	'Cubic Spline Beam Pendulum Angle Drive - 10 Segments';
configs.ExcelFileDir = 'Parameter File\Pendulum Angle Drive';
configs.opt = odeset('RelTol',0.01,'AbsTol',0.01,'MaxStep',0.01);
configs.Static_Start_Position = false;
configs.max_VelocityAcceleration_Tolerance = 1e-3;
configs.tspan = [0 10];
SolveParameter_func(configs);
pause(100);
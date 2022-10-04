mkdir('Result');
%% Folding Boom - Rigid
clc;clear;close all;
configs.ExcelFileName = ...
	'Folding Boom - Rigid';
configs.ExcelFileDir = 'Parameter File\Folding Boom System';
configs.opt = odeset('RelTol',0.01,'AbsTol',0.01,'MaxStep',0.01);
configs.Static_Start_Position = false;
configs.max_VelocityAcceleration_Tolerance = 1e-3;
configs.tspan = [0 2];
SolveParameter_func(configs);
pause(100);
%% Folding Boom - Timoshenko - 1 Segments
clc;clear;close all;
configs.ExcelFileName = ...
	'Folding Boom - Timoshenko - 1 Segments';
configs.ExcelFileDir = 'Parameter File\Folding Boom System';
configs.opt = odeset('RelTol',0.01,'AbsTol',0.01,'MaxStep',0.01);
configs.Static_Start_Position = false;
configs.max_VelocityAcceleration_Tolerance = 1e-3;
configs.tspan = [0 2];
SolveParameter_func(configs);
pause(100);
%% Folding Boom - Timoshenko - 3 Segments
clc;clear;close all;
configs.ExcelFileName = ...
	'Folding Boom - Timoshenko - 3 Segments';
configs.ExcelFileDir = 'Parameter File\Folding Boom System';
configs.opt = odeset('RelTol',0.01,'AbsTol',0.01,'MaxStep',0.01);
configs.Static_Start_Position = false;
configs.max_VelocityAcceleration_Tolerance = 1e-3;
configs.tspan = [0 2];
SolveParameter_func(configs);
pause(100);
%% Folding Boom - Timoshenko - 5 Segments
clc;clear;close all;
configs.ExcelFileName = ...
	'Folding Boom - Timoshenko - 5 Segments';
configs.ExcelFileDir = 'Parameter File\Folding Boom System';
configs.opt = odeset('RelTol',0.01,'AbsTol',0.01,'MaxStep',0.01);
configs.Static_Start_Position = false;
configs.max_VelocityAcceleration_Tolerance = 1e-3;
configs.tspan = [0 2];
SolveParameter_func(configs);
pause(100);
%% Folding Boom - Cubic Spline - 1 Segments
clc;clear;close all;
configs.ExcelFileName = ...
	'Folding Boom - Cubic Spline - 1 Segments';
configs.ExcelFileDir = 'Parameter File\Folding Boom System';
configs.opt = odeset('RelTol',0.01,'AbsTol',0.01,'MaxStep',0.01);
configs.Static_Start_Position = false;
configs.max_VelocityAcceleration_Tolerance = 1e-3;
configs.tspan = [0 2];
SolveParameter_func(configs);
pause(100);
%% Folding Boom - Cubic Spline - 3 Segments
clc;clear;close all;
configs.ExcelFileName = ...
	'Folding Boom - Cubic Spline - 3 Segments';
configs.ExcelFileDir = 'Parameter File\Folding Boom System';
configs.opt = odeset('RelTol',0.01,'AbsTol',0.01,'MaxStep',0.01);
configs.Static_Start_Position = false;
configs.max_VelocityAcceleration_Tolerance = 1e-3;
configs.tspan = [0 2];
SolveParameter_func(configs);
pause(100);
%% Folding Boom - Cubic Spline - 5 Segments
clc;clear;close all;
configs.ExcelFileName = ...
	'Folding Boom - Cubic Spline - 5 Segments';
configs.ExcelFileDir = 'Parameter File\Folding Boom System';
configs.opt = odeset('RelTol',0.01,'AbsTol',0.01,'MaxStep',0.01);
configs.Static_Start_Position = false;
configs.max_VelocityAcceleration_Tolerance = 1e-3;
configs.tspan = [0 2];
SolveParameter_func(configs);

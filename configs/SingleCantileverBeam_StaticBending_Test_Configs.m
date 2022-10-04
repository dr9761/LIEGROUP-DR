mkdir('Result');
%% Timoshenko Cantilever Beam Static Bending - 1 Segments
clc;clear;close all;
configs.ExcelFileName = ...
	'Timoshenko Cantilever Beam Static Bending - 1 Segments';
configs.ExcelFileDir = 'Parameter File\Single Cantilever Beam Static Bending';
configs.ActionFunctionHandle = ...
	@(t,x,tspan,ModelParameter)get_Action_CantileverBeamStaticBending(...
	t,x,tspan,ModelParameter);
SolveParameter_func(configs);
pause(10);
%% Timoshenko Cantilever Beam Static Bending - 3 Segments
clc;clear;close all;
configs.ExcelFileName = ...
	'Timoshenko Cantilever Beam Static Bending - 3 Segments';
configs.ExcelFileDir = 'Parameter File\Single Cantilever Beam Static Bending';
configs.ActionFunctionHandle = ...
	@(t,x,tspan,ModelParameter)get_Action_CantileverBeamStaticBending(...
	t,x,tspan,ModelParameter);
SolveParameter_func(configs);
pause(10);
%% Timoshenko Cantilever Beam Static Bending - 5 Segments
clc;clear;close all;
configs.ExcelFileName = ...
	'Timoshenko Cantilever Beam Static Bending - 5 Segments';
configs.ExcelFileDir = 'Parameter File\Single Cantilever Beam Static Bending';
configs.ActionFunctionHandle = ...
	@(t,x,tspan,ModelParameter)get_Action_CantileverBeamStaticBending(...
	t,x,tspan,ModelParameter);
SolveParameter_func(configs);
pause(10);
%% Timoshenko Cantilever Beam Static Bending - 10 Segments
clc;clear;close all;
configs.ExcelFileName = ...
	'Timoshenko Cantilever Beam Static Bending - 10 Segments';
configs.ExcelFileDir = 'Parameter File\Single Cantilever Beam Static Bending';
configs.ActionFunctionHandle = ...
	@(t,x,tspan,ModelParameter)get_Action_CantileverBeamStaticBending(...
	t,x,tspan,ModelParameter);
SolveParameter_func(configs);
pause(100);
%% Cubic Spline Cantilever Beam Static Bending - 1 Segments
clc;clear;close all;
configs.ExcelFileName = ...
	'Cubic Spline Cantilever Beam Static Bending - 1 Segments';
configs.ExcelFileDir = 'Parameter File\Single Cantilever Beam Static Bending';
configs.ActionFunctionHandle = ...
	@(t,x,tspan,ModelParameter)get_Action_CantileverBeamStaticBending(...
	t,x,tspan,ModelParameter);
SolveParameter_func(configs);
pause(10);
%% Cubic Spline Cantilever Beam Static Bending - 3 Segments
clc;clear;close all;
configs.ExcelFileName = ...
	'Cubic Spline Cantilever Beam Static Bending - 3 Segments';
configs.ExcelFileDir = 'Parameter File\Single Cantilever Beam Static Bending';
configs.ActionFunctionHandle = ...
	@(t,x,tspan,ModelParameter)get_Action_CantileverBeamStaticBending(...
	t,x,tspan,ModelParameter);
SolveParameter_func(configs);
pause(10);
%% Cubic Spline Cantilever Beam Static Bending - 5 Segments
clc;clear;close all;
configs.ExcelFileName = ...
	'Cubic Spline Cantilever Beam Static Bending - 5 Segments';
configs.ExcelFileDir = 'Parameter File\Single Cantilever Beam Static Bending';
configs.ActionFunctionHandle = ...
	@(t,x,tspan,ModelParameter)get_Action_CantileverBeamStaticBending(...
	t,x,tspan,ModelParameter);
SolveParameter_func(configs);
pause(10);
%% Cubic Spline Cantilever Beam Static Bending - 10 Segments
clc;clear;close all;
configs.ExcelFileName = ...
	'Cubic Spline Cantilever Beam Static Bending - 10 Segments';
configs.ExcelFileDir = 'Parameter File\Single Cantilever Beam Static Bending';
configs.ActionFunctionHandle = ...
	@(t,x,tspan,ModelParameter)get_Action_CantileverBeamStaticBending(...
	t,x,tspan,ModelParameter);
SolveParameter_func(configs);
mkdir('Result');
%% Lattice Type 1
% clc;clear;close all;
% configs.ExcelFileName = ...
% 	'Lattice Type 1 Mass';
% configs.ExcelFileDir = ...
% 	'Parameter File\Lattice boom crane model\Lattice Parameterization';
% Truss_Parameter_Test_Set_func(configs);
%% Lattice Type 2
% clc;clear;close all;
% configs.ExcelFileName = ...
% 	'Lattice Type 2 Mass';
% configs.ExcelFileDir = ...
% 	'Parameter File\Lattice boom crane model\Lattice Parameterization';
% Truss_Parameter_Test_Set_func(configs);
%% Lattice Type 3
% clc;clear;close all;
% configs.ExcelFileName = ...
% 	'Lattice Type 3 Mass';
% configs.ExcelFileDir = ...
% 	'Parameter File\Lattice boom crane model\Lattice Parameterization';
% Truss_Parameter_Test_Set_func(configs);
%% Lattice Type 4
% clc;clear;close all;
% configs.ExcelFileName = ...
% 	'Lattice Type 4 Mass';
% configs.ExcelFileDir = ...
% 	'Parameter File\Lattice boom crane model\Lattice Parameterization';
% Truss_Parameter_Test_Set_func(configs);
%% Lattice Type 5
% clc;clear;close all;
% configs.ExcelFileName = ...
% 	'Lattice Type 5 Mass';
% configs.ExcelFileDir = ...
% 	'Parameter File\Lattice boom crane model\Lattice Parameterization';
% Truss_Parameter_Test_Set_func(configs);
%% Lattice Type 6
clc;clear;close all;
configs.ExcelFileName = ...
	'Lattice Type 6 Mass';
configs.ExcelFileDir = ...
	'Parameter File\Lattice boom crane model\Lattice Parameterization';
Truss_Parameter_Test_Set_func(configs);
%%
function Truss_Parameter_Test_Set_func(configs)
%% Translation_x
% clc;close all;
% 
% TestType = 'Translation_x';
% configs.ActionFunctionHandle = ...
% 	@(t,x,tspan,ModelParameter)get_Action_Truss_Dynamics_Test(...
% 	t,x,tspan,ModelParameter,TestType);
% 
% SolveParameter_func(configs);
% pause(60);
%% Translation_y
% clc;close all;
% 
% TestType = 'Translation_y';
% configs.ActionFunctionHandle = ...
% 	@(t,x,tspan,ModelParameter)get_Action_Truss_Dynamics_Test(...
% 	t,x,tspan,ModelParameter,TestType);
% 
% SolveParameter_func(configs);
% pause(60);
%% Translation_z
% clc;close all;
% 
% TestType = 'Translation_z';
% configs.ActionFunctionHandle = ...
% 	@(t,x,tspan,ModelParameter)get_Action_Truss_Dynamics_Test(...
% 	t,x,tspan,ModelParameter,TestType);
% 
% SolveParameter_func(configs);
% pause(60);
%% Rotation_x
% clc;close all;
% 
% TestType = 'Rotation_x';
% configs.ActionFunctionHandle = ...
% 	@(t,x,tspan,ModelParameter)get_Action_Truss_Dynamics_Test(...
% 	t,x,tspan,ModelParameter,TestType);
% 
% SolveParameter_func(configs);
% pause(60);
%% Rotation_y
% clc;close all;
% 
% TestType = 'Rotation_y';
% configs.ActionFunctionHandle = ...
% 	@(t,x,tspan,ModelParameter)get_Action_Truss_Dynamics_Test(...
% 	t,x,tspan,ModelParameter,TestType);
% 
% SolveParameter_func(configs);
% pause(60);
%% Rotation_z
clc;close all;

TestType = 'Rotation_z';
configs.ActionFunctionHandle = ...
	@(t,x,tspan,ModelParameter)get_Action_Truss_Dynamics_Test(...
	t,x,tspan,ModelParameter,TestType);

SolveParameter_func(configs);
pause(60);
end
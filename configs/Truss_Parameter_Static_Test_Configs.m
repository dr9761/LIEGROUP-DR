mkdir('Result');
%% Lattice Type 1
% clc;clear;close all;
% configs.ExcelFileName = ...
% 	'Lattice Type 1 Stiffness';
% configs.ExcelFileDir = ...
% 	'Parameter File\Lattice boom crane model\Lattice Parameterization';
% Truss_Parameter_Test_Set_func(configs);
%% Lattice Type 2
% clc;clear;close all;
% configs.ExcelFileName = ...
% 	'Lattice Type 2 Stiffness';
% configs.ExcelFileDir = ...
% 	'Parameter File\Lattice boom crane model\Lattice Parameterization';
% Truss_Parameter_Test_Set_func(configs);
%% Lattice Type 3
% clc;clear;close all;
% configs.ExcelFileName = ...
% 	'Lattice Type 3 Stiffness';
% configs.ExcelFileDir = ...
% 	'Parameter File\Lattice boom crane model\Lattice Parameterization';
% Truss_Parameter_Test_Set_func(configs);
%% Lattice Type 4
% clc;clear;close all;
% configs.ExcelFileName = ...
% 	'Lattice Type 4 Stiffness';
% configs.ExcelFileDir = ...
% 	'Parameter File\Lattice boom crane model\Lattice Parameterization';
% Truss_Parameter_Test_Set_func(configs);
%% Lattice Type 5
% clc;clear;close all;
% configs.ExcelFileName = ...
% 	'Lattice Type 5 Stiffness';
% configs.ExcelFileDir = ...
% 	'Parameter File\Lattice boom crane model\Lattice Parameterization';
% Truss_Parameter_Test_Set_func(configs);
%% Lattice Type 6
clc;clear;close all;
configs.ExcelFileName = ...
	'Lattice Type 6 Stiffness';
configs.ExcelFileDir = ...
	'Parameter File\Lattice boom crane model\Lattice Parameterization';
Truss_Parameter_Test_Set_func(configs);

%%
function Truss_Parameter_Test_Set_func(configs)
%% Axial Stretch
clc;close all;

TestType = 'Axial Stretch';
configs.ActionFunctionHandle = ...
	@(t,x,tspan,ModelParameter)get_Action_Truss_Statics_Test(...
	t,x,tspan,ModelParameter,TestType);

SolveParameter_func(configs);
pause(10);
%% Axial Compression
clc;close all;

TestType = 'Axial Compression';
configs.ActionFunctionHandle = ...
	@(t,x,tspan,ModelParameter)get_Action_Truss_Statics_Test(...
	t,x,tspan,ModelParameter,TestType);

SolveParameter_func(configs);
pause(10);
%% x-Axis Twist
clc;close all;

TestType = 'x-Axis Twist';
configs.ActionFunctionHandle = ...
	@(t,x,tspan,ModelParameter)get_Action_Truss_Statics_Test(...
	t,x,tspan,ModelParameter,TestType);

SolveParameter_func(configs);
pause(10);
%% y-Axis Bending
clc;close all;

TestType = 'y-Axis Bending';
configs.ActionFunctionHandle = ...
	@(t,x,tspan,ModelParameter)get_Action_Truss_Statics_Test(...
	t,x,tspan,ModelParameter,TestType);

SolveParameter_func(configs);
pause(10);
%% z-Axis Bending
clc;close all;

TestType = 'z-Axis Bending';
configs.ActionFunctionHandle = ...
	@(t,x,tspan,ModelParameter)get_Action_Truss_Statics_Test(...
	t,x,tspan,ModelParameter,TestType);

SolveParameter_func(configs);
end
function g = Gravity_Configuration(ExcelFilePath)
%%
[~,~,Solver_ParameterTableRaw]= ...
	xlsread(ExcelFilePath,'Solver Parameter');
%%
fprintf('Setting global gravity...\n');
%%
GravityDirection = reshape(str2num(Solver_ParameterTableRaw{5,3}),3,1);
GravityValue = Solver_ParameterTableRaw{6,3};
%% make sure GravityDirection is a unit vector
GravityValue = abs(GravityValue);
GravityDirection = GravityDirection / norm(GravityDirection);
%%
g = GravityValue * GravityDirection;
%%
fprintf('Global Gravity has been set as follows:\n');
fprintf('\t x-direction: %6.4f\n',g(1));
fprintf('\t y-direction: %6.4f\n',g(2));
fprintf('\t z-direction: %6.4f\n',g(3));
fprintf('\n');
end
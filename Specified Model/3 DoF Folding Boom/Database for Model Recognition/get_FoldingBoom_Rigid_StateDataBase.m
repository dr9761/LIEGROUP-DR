close all;
do_load_Parameter = true;
if do_load_Parameter
	clc;clear;
	%% Change Working Dictionary
	Welcome_to_Programm;
	%% Configure Working Directory
	FullPathOfProject = Configure_WorkingDirectory;
	%% Load Sub-Module
	Load_SubModule(FullPathOfProject);
	%% Load Parameter from Excel File
	ExcelFileName = ...
		'Folding Boom - Rigid 3DoF';
	ExcelFileDir = [...
		'Parameter File', ...
		'\Folding Boom System\Controllable System'];
	[ModelParameter,SolverParameter] = ...
		Set_AllParameter_from_ExcelFile(ExcelFileName,ExcelFileDir);
end
%%
Joint_Parameter = ModelParameter.Joint_Parameter;
BodyElementParameter = ModelParameter.BodyElementParameter;
%%
DataQuantity = 1e6;
DataBase = cell(DataQuantity,1);
mkdir('Result\Folding Boom System\Pattern Recognition');
while true
	parfor DataNr = 1:DataQuantity
		dpsi = 2 * pi * rand();
		dphi1 = pi/2 * rand();
		dphi2 = pi * rand();
		
		q = [dpsi;dphi1;dphi2];
		%%
		ddpsidt = 10*(rand()-0.5);
		ddphi1dt = 10*(rand()-0.5);
		ddphi2dt = 10*(rand()-0.5);
		
		dq = [ddpsidt;ddphi1dt;ddphi2dt];
		%% -5e6 < u1,u2 < 5e6
		u = zeros(3,1);
		
		u(1) = 10e6 * rand() - 5e6;
		u(2) = 10e6 * rand() - 5e6;
		u(3) = 10e6 * rand() - 5e6;
		%% Ts
		Ts = 0.02;
		%%
		x1 = [q;dq];
		%
		k_1 = FoldingBoom_3DoF_Dynamic_func(DataNr,x1,u, ...
			ModelParameter,SolverParameter,[]);
		k_2 = FoldingBoom_3DoF_Dynamic_func(DataNr+0.5*Ts,x1+0.5*Ts*k_1,u, ...
			ModelParameter,SolverParameter,[]);
		k_3 = FoldingBoom_3DoF_Dynamic_func(DataNr+0.5*Ts,x1+0.5*Ts*k_2,u, ...
			ModelParameter,SolverParameter,[]);
		k_4 = FoldingBoom_3DoF_Dynamic_func(DataNr+Ts,x1+Ts*k_3,u, ...
			ModelParameter,SolverParameter,[]);
		%
		x2 = x1 + (1/6)*(k_1+2*k_2+2*k_3+k_4)*Ts;
		%%
		q1 = x1(1:3); dq1 = x1(4:6);
		[qb1,dqb1,~,~] = get_FoldingBoom_3DoF_ElementCoordinate(...
			q1,dq1,ModelParameter);
		
		q2 = x2(1:3); dq2 = x2(4:6);
		[qb2,dqb2,~,~] = get_FoldingBoom_3DoF_ElementCoordinate(...
			q2,dq2,ModelParameter);
		%
		r7_1 = qb1{7}(1:3);
		R7_1 = get_R(qb1{7}(4:6));
		dr7dt_1 = dqb1{7}(1:3);
		omega7_1 = dqb1{7}(4:6);
		%%
		r_tip_1 = r7_1 + R7_1*Joint_Parameter{7}.Joint{2}.r;
		dr_tipdt_1 = dr7dt_1 + R7_1*skew(omega7_1)*Joint_Parameter{7}.Joint{2}.r;
		y1 = [r_tip_1;dr_tipdt_1];
		%
		r7_2 = qb2{7}(1:3);
		R7_2 = get_R(qb2{7}(4:6));
		dr7dt_2 = dqb2{7}(1:3);
		omega7_2 = dqb2{7}(4:6);
		
		r_tip_2 = r7_2 + R7_2*Joint_Parameter{7}.Joint{2}.r;
		dr_tipdt_2 = dr7dt_2 + R7_2*skew(omega7_2)*Joint_Parameter{7}.Joint{2}.r;
		y2 = [r_tip_2;dr_tipdt_2];
		%% y tip x,y,z vx,vy,vz
		% [yk,uk,yk+1]
		DataBase{DataNr}.y1 = y1;
		DataBase{DataNr}.y2 = y2;
		DataBase{DataNr}.u = u;
	end
	
	DataBaseNr = numel(dir('Result\Folding Boom System\Pattern Recognition\'))-2+1;
	DataBaseFileName = ['FoldingBoom_3DoF_RK45_DataBase_',num2str(DataBaseNr)];
	DataBaseFile = ['Result\Folding Boom System\Pattern Recognition\', ...
		DataBaseFileName,'.mat'];
	save(DataBaseFile,'DataBase');
end
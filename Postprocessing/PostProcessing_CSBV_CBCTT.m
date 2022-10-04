%% ========== PostProcessing_CSBV_CBCTT ============
%% PostProcessing
%% Cubic Spline Beam Verification(CSBV)
%% Cantilever Beam Controlled Torque Test(CBCTT)
%% =================================================
clear;clc;close all;
MaxSegmentQuantity = 5;
TestSegmentSet = 1:MaxSegmentQuantity;
ResultFolderName = [...
	'Result\CubicSplineBeam Controlled Verification Test\', ...
	'PID MaxStep=0.1\'];
% PID MaxStep=5
% PID MaxStep=0.1
% Forward MaxStep=0.1
% Forward MaxStep=5
%%
deltaFigure = figure('Name','dtheta');
deltaAxes= axes(deltaFigure);

hold(deltaAxes,'on');
%%
gx = [1;0;0];
gz = [0;0;1];

%%
for TestSegment = TestSegmentSet
	ExperimentName = ...
		['CubicSplineBeam_Controlled_Verification_Test_Segment', ...
		num2str(TestSegment),'.mat'];
	ResultData = load([ResultFolderName,ExperimentName]);
	x_set = ResultData.x_set;
	t_set = ResultData.t_set;
% 	[TestSegment,ResultData.opt.MaxStep]
	
	q_set = x_set(:,1:size(x_set,2)/2);
	dq_set = x_set(:,size(x_set,2)/2+1:end);
	
	q_1_set = q_set(:,1:7);
	q_end_set = q_set(:,end-6:end);
	delta_u_set = zeros(numel(t_set),1);
	for TimeNr = 1:numel(t_set)
		q_1 = q_1_set(TimeNr,:);
		r01 = q_1(1:3);r01 = r01';
		phi1 = q_1(4:6);phi1 = phi1';
		R1 = get_R(phi1);
		nx = R1*gx;
		nz = R1*gz;
		
		r0end_Rigid = r01 + nx*ResultData.L*ResultData.SegmentQuantity;
		r0end = q_end_set(TimeNr,1:3);r0end = r0end';
		u_end = r0end-r0end_Rigid;
		delta_u = nz'*u_end;
		delta_u_set(TimeNr) = delta_u;
	end
	theta_1 = q_1_set(:,5);
	theta_end = q_end_set(:,5);
	
	delta_theta = theta_end - theta_1;
	
	plot(deltaAxes,t_set,delta_u_set);
end
%%
TheoreticResult = load(...
	['Result\CubicSplineBeam Controlled Verification Test\', ...
	'TheoreticResult.mat']);
Theoretic_t_set = TheoreticResult.t_set;
Theoretic_u_set = TheoreticResult.u_set;
plot(deltaAxes,Theoretic_t_set,Theoretic_u_set,'k-');
%%
grid(deltaAxes,'on');
grid(deltaAxes,'MINOR');
legend(deltaAxes, ...
	'C-1','C-2','C-3','C-4','C-5','Theoretic');

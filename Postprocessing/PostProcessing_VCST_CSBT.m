%% ========== PostProcessing_VCST_CSBT =============
%% PostProcessing
%% Variable Cross Section Test(VCST)
%% Cantilever Beam Self-gravity Test(CSBT)
%% =================================================
clear;clc;close all;
MaxSegmentQuantity = 10;
TestSegmentSet = 1:MaxSegmentQuantity;
ResultParentFolderName = 'Result\Variable Cross Section Test\';
BeamType = 'Stepped Beam';% Conical Beam % Stepped Beam
%%
CoordinateFigure = figure('Name','Coordinate');
CoordinateAxes.x	= subplot(3,2,1,'Parent',CoordinateFigure);
CoordinateAxes.phix = subplot(3,2,2,'Parent',CoordinateFigure);
CoordinateAxes.y	= subplot(3,2,3,'Parent',CoordinateFigure);
CoordinateAxes.phiy = subplot(3,2,4,'Parent',CoordinateFigure);
CoordinateAxes.z	= subplot(3,2,5,'Parent',CoordinateFigure);
CoordinateAxes.phiz = subplot(3,2,6,'Parent',CoordinateFigure);

VelocityFigure = figure('Name','Coordinate');
VelocityAxes.x	  = subplot(3,2,1,'Parent',VelocityFigure);
VelocityAxes.phix = subplot(3,2,2,'Parent',VelocityFigure);
VelocityAxes.y	  = subplot(3,2,3,'Parent',VelocityFigure);
VelocityAxes.phiy = subplot(3,2,4,'Parent',VelocityFigure);
VelocityAxes.z	  = subplot(3,2,5,'Parent',VelocityFigure);
VelocityAxes.phiz = subplot(3,2,6,'Parent',VelocityFigure);

hold(CoordinateAxes.x,'on');   hold(CoordinateAxes.y,'on');   hold(CoordinateAxes.z,'on');
hold(CoordinateAxes.phix,'on');hold(CoordinateAxes.phiy,'on');hold(CoordinateAxes.phiz,'on');
hold(VelocityAxes.x,'on');     hold(VelocityAxes.y,'on');     hold(VelocityAxes.z,'on');
hold(VelocityAxes.phix,'on');  hold(VelocityAxes.phiy,'on');  hold(VelocityAxes.phiz,'on');
%%
for TestSegment = TestSegmentSet
ExperimentName = ...
	['VariableCrossSection_CubicSpline_',num2str(TestSegment),'.mat'];
ResultFolderName = ...
	[ResultParentFolderName,BeamType,'\'];
ResultData = load([ResultFolderName,ExperimentName]);
x_set = ResultData.x_set;
t_set = ResultData.t_set;

q_set = x_set(:,1:size(x_set,2)/2);
dq_set = x_set(:,size(x_set,2)/2+1:end);

q_end_set = q_set(:,end-6:end);
dq_end_set = dq_set(:,end-6:end);

xPos_end_set = q_end_set(:,1);dxPos_end_set = dq_end_set(:,1);
yPos_end_set = q_end_set(:,2);dyPos_end_set = dq_end_set(:,2);
zPos_end_set = q_end_set(:,3);dzPos_end_set = dq_end_set(:,3);
xPhi_end_set = q_end_set(:,4);dxPhi_end_set = dq_end_set(:,4);
yPhi_end_set = q_end_set(:,5);dyPhi_end_set = dq_end_set(:,5);
zPhi_end_set = q_end_set(:,6);dzPhi_end_set = dq_end_set(:,6);

plot(CoordinateAxes.x,t_set,xPos_end_set);
plot(CoordinateAxes.y,t_set,yPos_end_set);
plot(CoordinateAxes.z,t_set,zPos_end_set);
plot(CoordinateAxes.phix,t_set,xPhi_end_set);
plot(CoordinateAxes.phiy,t_set,yPhi_end_set);
plot(CoordinateAxes.phiz,t_set,zPhi_end_set);

plot(VelocityAxes.x,t_set,dxPos_end_set);
plot(VelocityAxes.y,t_set,dyPos_end_set);
plot(VelocityAxes.z,t_set,dzPos_end_set);
plot(VelocityAxes.phix,t_set,dxPhi_end_set);
plot(VelocityAxes.phiy,t_set,dyPhi_end_set);
plot(VelocityAxes.phiz,t_set,dzPhi_end_set);
end
%%
legend(CoordinateAxes.x, ...
	'C-01','C-02','C-03','C-04','C-05', ...
	'C-06','C-07','C-08','C-09','C-10');
legend(CoordinateAxes.y, ...
	'C-01','C-02','C-03','C-04','C-05', ...
	'C-06','C-07','C-08','C-09','C-10');
legend(CoordinateAxes.z, ...
	'C-01','C-02','C-03','C-04','C-05', ...
	'C-06','C-07','C-08','C-09','C-10');
legend(CoordinateAxes.phix, ...
	'C-01','C-02','C-03','C-04','C-05', ...
	'C-06','C-07','C-08','C-09','C-10');
legend(CoordinateAxes.phiy, ...
	'C-01','C-02','C-03','C-04','C-05', ...
	'C-06','C-07','C-08','C-09','C-10');
legend(CoordinateAxes.phiz, ...
	'C-01','C-02','C-03','C-04','C-05', ...
	'C-06','C-07','C-08','C-09','C-10');

legend(VelocityAxes.x, ...
	'C-01','C-02','C-03','C-04','C-05', ...
	'C-06','C-07','C-08','C-09','C-10');
legend(VelocityAxes.y, ...
	'C-01','C-02','C-03','C-04','C-05', ...
	'C-06','C-07','C-08','C-09','C-10');
legend(VelocityAxes.z, ...
	'C-01','C-02','C-03','C-04','C-05', ...
	'C-06','C-07','C-08','C-09','C-10');
legend(VelocityAxes.phix, ...
	'C-01','C-02','C-03','C-04','C-05', ...
	'C-06','C-07','C-08','C-09','C-10');
legend(VelocityAxes.phiy, ...
	'C-01','C-02','C-03','C-04','C-05', ...
	'C-06','C-07','C-08','C-09','C-10');
legend(VelocityAxes.phiz, ...
	'C-01','C-02','C-03','C-04','C-05', ...
	'C-06','C-07','C-08','C-09','C-10');
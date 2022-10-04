function plot_WinchCableSystem(qe,BodyParameter,FigureObj)
%% Winch
WinchRadius = BodyParameter.WinchRadius;
WinchLength = BodyParameter.WinchLength;
[qwinch,~,~,~] = get_Winch_Coordinate(...
	qe,zeros(numel(qe),1),BodyParameter);
r0Winch = qwinch(1:3);
phiWinch = qwinch(4:6);
Rw = get_R(phiWinch);
WinchLengthInterpolationNr = 1;
WinchPhiInterpolationNr = 2;
WinchPointSet = ...
	zeros(3*WinchLengthInterpolationNr,WinchPhiInterpolationNr);
WinchSegmentLengthSet = linspace(0,WinchLength,WinchLengthInterpolationNr);
WinchSegmentPhiSet = linspace(0,2*pi,WinchPhiInterpolationNr);
for WinchSegmentLengthNr = 1:WinchLengthInterpolationNr
	WinchSegmentLength = WinchSegmentLengthSet(WinchSegmentLengthNr);
	for WinchSegmentPhiNr = 1:WinchPhiInterpolationNr
		WinchSegmentPhi = WinchSegmentPhiSet(WinchSegmentPhiNr);
		WinchRelativePoint = ...
			[WinchSegmentLength;
			WinchRadius*cos(WinchSegmentPhi);
			WinchRadius*sin(WinchSegmentPhi)];
		WinchPoint = r0Winch + Rw*WinchRelativePoint;
		WinchCenterPoint = r0Winch + Rw*[WinchSegmentLength;0;0];
		WinchPointSet(3*(WinchSegmentLengthNr-1)+[1:3],WinchSegmentPhiNr) = ...
			WinchPoint;
		if WinchSegmentPhiNr == 1
		plot_WinchRadius_x = [WinchCenterPoint(1),WinchPoint(1)];
		plot_WinchRadius_y = [WinchCenterPoint(2),WinchPoint(2)];
		plot_WinchRadius_z = [WinchCenterPoint(3),WinchPoint(3)];
		plot3(FigureObj, ...
			plot_WinchRadius_x,plot_WinchRadius_y,plot_WinchRadius_z, ...
			'b.-');
		end
	end
	plot_WinchCircle_x_set = WinchPointSet(3*(WinchSegmentLengthNr-1)+1,:);
	plot_WinchCircle_y_set = WinchPointSet(3*(WinchSegmentLengthNr-1)+2,:);
	plot_WinchCircle_z_set = WinchPointSet(3*(WinchSegmentLengthNr-1)+3,:);
	plot3(FigureObj, ...
		plot_WinchCircle_x_set,plot_WinchCircle_y_set,plot_WinchCircle_z_set, ...
		'b-');
end
%% Free Cable
sw = qe(10);
CableParameter = BodyParameter.CableParameter;
BodyParameter.FreeCableParameter = CableParameter;
BodyParameter.FreeCableParameter.L = CableParameter.L + sw;
[qcable,~,~,~] = get_Cable_Coordinate(...
	qe,zeros(numel(qe),1),BodyParameter);
FreeCableInterpolationNr = 10;
plot_CubicSplineRope(qcable,FreeCableInterpolationNr, ...
	BodyParameter.FreeCableParameter, ...
	'r.-',FigureObj)
end
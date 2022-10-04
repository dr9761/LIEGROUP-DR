function plot_Mechanism(q,ModelParameter,SolverParameter,FigureObj)
%%
if isempty(FigureObj)
	return;
end
%%
BodyElementParameter = ModelParameter.BodyElementParameter;
Joint_Parameter = ModelParameter.Joint_Parameter;
PlotParameter = ModelParameter.PlotParameter;

BodyQuantity = numel(BodyElementParameter);
%%
hold(FigureObj,'off');
plot3(FigureObj,0,0,0);
hold(FigureObj,'on');
%%
for BodyNr = 1:BodyQuantity
	m = BodyElementParameter{BodyNr}.GlobalCoordinate;
	qe = q(m);
	dqe = zeros(numel(qe),1);
	PlotStyle = PlotParameter{BodyNr}.PlotStyle;
	switch BodyElementParameter{BodyNr}.BodyType
		case 'Rigid Body'
			Joint = set_Joint(...
				qe,dqe,BodyElementParameter,BodyNr,Joint_Parameter);
			PlotSequence = PlotParameter{BodyNr}.PlotSequence;
			
			plot_RigidBody(Joint,PlotSequence,PlotStyle,FigureObj);
		case 'Timoshenko Beam'
			InterpolationNr = PlotParameter{BodyNr}.InterpolationNr;
			BodyParameter = PlotParameter{BodyNr}.BodyParameter;
			
			plot_TimoshenkoBeam(qe, ...
				InterpolationNr,BodyParameter,PlotStyle,FigureObj);
		case 'Strut Tie Model'
			plot_StrutTieModel(qe,PlotStyle,FigureObj);
		case 'Strut Tie Rope Model'
			plot_StrutTieModel(qe,PlotStyle,FigureObj);
		case 'Super Truss Element'
			InterpolationNr = PlotParameter{BodyNr}.InterpolationNr;
			Truss_Parameter = PlotParameter{BodyNr}.Truss_Parameter;
			
			plot_SuperTrussElement(qe, ...
				InterpolationNr,Truss_Parameter,PlotStyle,FigureObj);
		case 'Cubic Spline Beam'
			InterpolationNr = PlotParameter{BodyNr}.InterpolationNr;
			BodyParameter = PlotParameter{BodyNr}.BodyParameter;
			
			plot_CubicSplineBeam(qe, ...
				InterpolationNr,BodyParameter,PlotStyle,FigureObj);
		case 'Cubic Spline Rope'
			InterpolationNr = PlotParameter{BodyNr}.InterpolationNr;
			BodyParameter = PlotParameter{BodyNr}.BodyParameter;
			
			plot_CubicSplineBeam(qe, ...
				InterpolationNr,BodyParameter,PlotStyle,FigureObj);
	end
end
%%
AxesSize = SolverParameter.PlotConfiguration.AxesSize;
axis(FigureObj,AxesSize);
%
Azimuth = SolverParameter.PlotConfiguration.Azimuth;
Elevation = SolverParameter.PlotConfiguration.Elevation;
view(FigureObj,Azimuth,Elevation);
% axis([-40,60,-50,50,-50,50]);
% axis(FigureObj,[-5,2,-3.5,3.5,-1,6]);
% axis([-5,15,-10,10,0,20]);
% axis([-5,25,-15,15,-15,15]);
% axis(FigureObj,[-10,10,-10,10,-10,10]);
% view(FigureObj,0,0);%x-z
% view(0,90);%x-y
xlabel(FigureObj,'x');
ylabel(FigureObj,'y');
zlabel(FigureObj,'z');
%
if contains(SolverParameter.PlotConfiguration.GridSetting,'on')
	grid(FigureObj,'on');
end
if contains(SolverParameter.PlotConfiguration.GridSetting,'MINOR')
	grid(FigureObj,'MINOR');
end
hold(FigureObj,'off');
end
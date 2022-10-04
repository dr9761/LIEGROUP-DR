function plot_TimoshenkoBeam(qe,InterpolationNr,BodyParameter, ...
	PlotStyle,FigureObj)
%%
r = zeros(3,InterpolationNr+1);
for NodeNr = 1:(InterpolationNr+1)
	xi = (NodeNr-1)/InterpolationNr;
	[qc,~,~,~] = ...
		get_InternalNode_Coordination_TimoshenkoBeam(...
		qe,zeros(12,1),xi,BodyParameter);
	r(:,NodeNr) = qc(1:3);
end
%%
x = r(1,:);
y = r(2,:);
z = r(3,:);
%%
plot3(FigureObj,x,y,z,PlotStyle);
end
function plot_RigidBody(Joint,PlotSequence,PlotStyle,FigureObj)
%%
NodeQuantity = numel(PlotSequence);
%%
r = zeros(3,NodeQuantity);
for NodeNr = 1:NodeQuantity
	JointNr = PlotSequence(NodeNr);
	r(:,NodeNr) = Joint{JointNr}.r;
end
x = r(1,:);
y = r(2,:);
z = r(3,:);
%%
plot3(FigureObj,x,y,z,PlotStyle);
end
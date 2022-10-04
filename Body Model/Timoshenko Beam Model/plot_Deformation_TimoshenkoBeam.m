function plot_Deformation_TimoshenkoBeam(qe,BodyParameter)
dqe = zeros(size(qe));
L = BodyParameter.L;
[qB,~,~,~,~,~] = ...
	get_Corotational_Coordination_TimoshenkoBeam(qe,dqe,L);
%%
InterpolationNr = 20;
qd_set = zeros(6,InterpolationNr);
x_set = linspace(0,L,InterpolationNr+1);
for NodeNr = 1:InterpolationNr
	%%
	xi1 = (NodeNr-1)/InterpolationNr;
	r_rigid1 = xi1*[L;0;0];
	[qc1,~,~,~] = ...
		get_InternalNode_Coordination_TimoshenkoBeam(...
		qe,zeros(12,1),xi1,BodyParameter);
	[qd1] = ...
		get_Deformation_Coordination_TimoshenkoBeam(...
		qc1,qB,r_rigid1);
	%%
	xi2 = (NodeNr)/InterpolationNr;
	r_rigid2 = xi2*[L;0;0];
	[qc2,~,~,~] = ...
		get_InternalNode_Coordination_TimoshenkoBeam(...
		qe,zeros(12,1),xi2,BodyParameter);
	[qd2] = ...
		get_Deformation_Coordination_TimoshenkoBeam(...
		qc2,qB,r_rigid2);
	%%
	qd_set(:,NodeNr) = (qd2-qd1)/(L/(InterpolationNr+1));
end
%%
y_set = qd_set(5,:);
%%
plot(x_set(1:end-1),y_set);
% plot(FigureObj,x_set,y_set,PlotStyle);
end
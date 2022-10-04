function u = ShipCrane_InverseDynamic(q,dq,s,ddr3dtdt,ModelParameter)
%%
ddq = ShipCrane_InverseKinematics(...
	q,dq,s,ddr3dtdt,ModelParameter);
[~,M,F,B,~] = ...
	ShipCrane_ForwardDynamic(q,dq,s,zeros(3,1),ModelParameter);
%%
Mc = M(7:9,:);
Fc = F(7:9);
Bc = B(7:9,:);
u = -Bc \ (Mc*ddq + Fc);
end
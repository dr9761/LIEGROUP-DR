function ddq = ShipCrane_InverseKinematics(...
	q,dq,s,ddr3dtdt,ModelParameter)
%%
[~,~,~,~,Tn,dTn] = ShipCrane_ForwardKinematics(...
	q,dq,zeros(size(dq)),ModelParameter);
%
T3 = Tn{3};
Tr3 = T3(1:3,:);
Tr30 = Tr3(:,1:6);
Tr3c = Tr3(:,7:9);

dT3 = dTn{3};
dTr3 = dT3(1:3,:);
%%
ddq0 = s;
ddqc = Tr3c\(ddr3dtdt - Tr30*s - dTr3*dq);
ddq = [ddq0;ddqc];
end
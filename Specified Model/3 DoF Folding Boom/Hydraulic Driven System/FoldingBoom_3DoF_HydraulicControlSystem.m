function [QL1,QL2,QU1,QU2] = FoldingBoom_3DoF_HydraulicControlSystem(...
	x,u,s,dsdt,ModelParameter)
%%
s1 = s(1);
s2 = s(2);
ds1dt = dsdt(1);
ds2dt = dsdt(2);

QL = u(2);
QU = u(3);
%%
HydraulicParameter = ModelParameter.HydraulicParameter;
HydraulicCylinderParameter = HydraulicParameter.HydraulicCylinderParameter;

alphaL = HydraulicCylinderParameter{1}.alpha;
LL = HydraulicCylinderParameter{1}.L;
AL = HydraulicCylinderParameter{1}.A;

alphaU = HydraulicCylinderParameter{2}.alpha;
LU = HydraulicCylinderParameter{2}.L;
AU = HydraulicCylinderParameter{2}.A;
%%
QL2 = alphaL * (LL*AL*ds1dt - QL*(LL-s1)) / (s1+alphaL*(LL-s1));
QL1 = QL2 + QL;
%%
QU2 = alphaU * (LU*AU*ds2dt - QU*(LU-s2)) / (s2+alphaU*(LU-s2));
QU1 = QU2 + QU;

end
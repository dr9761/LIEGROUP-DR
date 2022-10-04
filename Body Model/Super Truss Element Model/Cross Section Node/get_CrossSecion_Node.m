function [qcs,dqcs,Tcs,dTcsdt] = get_CrossSecion_Node(...
	qe,dqe,CrossSectionParameter,CrossSectionNr,PointNr)
%%
m = 6*(CrossSectionNr-1)+(1:6);
qs = qe(m);
%
r0cs  = qs(1:3);
phis = qs(4:6);
Rs = get_R(phis);
%%
Ts = zeros(6,12);
Ts(:,m) = eye(6);
dqs = Ts * dqe;
omegas = dqs(4:6);
%%
r_s_cs = ...
	CrossSectionParameter.CrossSection{CrossSectionNr}.Point{PointNr};
%%
r0cs = r0cs + Rs * r_s_cs;
phics = phis;

qcs = [r0cs;phics];
%%
T_cs_s = [	eye(3),		-Rs*skew(r_s_cs);
			zeros(3),	eye(3)];
Tcs = T_cs_s * Ts;
%%
dqcs = Tcs * dqe;
%%			
dT_cs_sdt = [	zeros(3),	-Rs*skew(omegas)*skew(r_s_cs);
				zeros(3),	zeros(3)];
dTcsdt = dT_cs_sdt * Ts;

end
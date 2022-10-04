function [r0i,Ri,dqi,Ti,dTidt] = get_InternalNode(...
	r0s,Rs,dqs,Ts,dTsdt,xi,BodyParameter)
%%
% [qi,dqi,T_i_s,dT_i_sdt] = ...
% 	get_InternalNode_Coordination_TimoshenkoBeam(...
% 	qs,dqs,xi,BodyParameter);
%
[r0i,Ri,dqi,T_i_s,dT_i_sdt] = ...
	get_InternalNode_Coordination_CubicSplineBeam(...
	r0s,Rs,dqs,xi,BodyParameter);
%%
Ti = T_i_s * Ts;
%%
dTidt = T_i_s * dTsdt + dT_i_sdt * Ts;
end










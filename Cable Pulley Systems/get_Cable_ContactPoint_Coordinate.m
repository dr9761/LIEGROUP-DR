function [qw,dqw,Tw,dTw] = ...
	get_Cable_ContactPoint_Coordinate(qe,dqe,BodyParameter)
%%
rw = BodyParameter.WinchRadius;
rc = BodyParameter.CableRadius;
rh = BodyParameter.HelixRadius;
h = 2*rc;

gx = [1;0;0];
gy = [0;1;0];
gz = [0;0;1];
%%
r0A = qe(1:3);
phiA = qe(4:6);
thetap = qe(7);
thetaw = qe(8);
dthetawdx = qe(9);
qwe = qe(11:end);
%
dr0Adt = dqe(1:3);
omegaA = dqe(4:6);
dthetapdt = dqe(7);
dthetawdt = dqe(8);
ddthetawdxdt = dqe(9);
dqwe = dqe(11:end);
%
RA = get_R(phiA);
Rxw = get_R_x(thetaw);
Txw = get_T_x(thetaw);
dTxw = get_dT_x(thetaw);
%
Tr0A = zeros(3,numel(dqe));
Tr0A(:,1:3) = eye(3);
TphiA = zeros(3,numel(dqe));
TphiA(:,4:6) = eye(3);
Tthetap = zeros(1,numel(dqe));
Tthetap(:,7) = 1;
Tthetaw = zeros(1,numel(dqe));
Tthetaw(:,8) = 1;
Tdthetawdx = zeros(1,numel(dqe));
Tdthetawdx(:,9) = 1;
%%
rAw = h/(2*pi)*thetaw*gx + rw*Rxw*gy;
tw = 1/rh*(h/(2*pi)*gx + rw*Txw*gy);
nw = dTxw*gy;
%%
r0w = r0A + RA*rAw;
dr0wdx = rh*RA*tw*dthetawdx;
qw = [r0w;dr0wdx];
%% Apply Shape Function
qfc = [qwe;qw];
[ddN_1_0,ddN_1_1,ddN_2_0,ddN_2_1] = ...
	Hermite_Interpolation_Coefficient_ddN(1,1);
ddN0 = ...
	[ddN_1_0*eye(3),ddN_1_1*eye(3),ddN_2_0*eye(3),ddN_2_1*eye(3)];
ddr0wdxdx = ddN0*qfc;

[dddN_1_0,dddN_1_1,dddN_2_0,dddN_2_1] = ...
	Hermite_Interpolation_Coefficient_dddN(1,1);
dddN0 = ...
	[dddN_1_0*eye(3),dddN_1_1*eye(3),dddN_2_0*eye(3),dddN_2_1*eye(3)];
dddr0wdxdxdx = dddN0*qfc;
%%
dr0wdt = dr0Adt - RA*skew(rAw)*omegaA + RA*(rh*tw+0*h/(2*pi)*gx)*dthetapdt;
ddr0wdxdt = -rh*dthetawdx*RA*skew(tw)*omegaA + ...
	1/dthetawdx*ddr0wdxdx*dthetapdt + ...
	(rw*dthetawdx*RA*nw - 1/dthetawdx*ddr0wdxdx)*dthetawdt + ...
	rh*RA*tw*ddthetawdxdt;
dqw = [dr0wdt;ddr0wdxdt];
%%
Tr0w = Tr0A - RA*skew(rAw)*TphiA + RA*(rh*tw+0*h/(2*pi)*gx)*Tthetap;
Tdr0wdx = -rh*dthetawdx*RA*skew(tw)*TphiA + ...
	1/dthetawdx*ddr0wdxdx*Tthetap + ...
	(rw*dthetawdx*RA*nw - 1/dthetawdx*ddr0wdxdx)*Tthetaw + ...
	rh*RA*tw*Tdthetawdx;
Tw = [Tr0w;Tdr0wdx];
%%
dqfc = [dqwe;dqw];
dddr0wdxdxdt = ddN0*dqfc;
%% 未完成！！！！！
dTw = zeros(6,numel(dqe));
dTr0w = RA*skew(omegaA)*skew(rAw)*TphiA + ...
	2*rh*RA*skew(omegaA)*tw*Tthetaw + ...
	2*h/(2*pi)*RA*skew(omegaA)*gx*Tthetap + ...
	rw*RA*nw*dthetawdt*Tthetaw - ...
	2*ddr0wdxdt*(Tthetaw-Tthetap)/dthetawdx - ...
	ddr0wdxdx*(dthetawdt-dthetapdt)/dthetawdx*(Tthetaw-Tthetap)/dthetawdx - ...
	dr0wdx*(-ddthetawdxdt)*(Tthetaw-Tthetap)/dthetawdx;
dTdr0wdx = ddr0wdxdx/dthetawdx*ddthetawdxdt*(Tthetaw-Tthetap)/dthetawdx - ...
	rh*dthetawdx*RA*skew(omegaA)*skew(tw)*omegaA + ...
	2*rw*dthetawdx*RA*skew(omegaA)*nw*Tthetaw + ...
	2*rh*RA*skew(omegaA)*tw*Tdthetawdx - ...
	rw*dthetawdx*RA*Txw*gy*dthetawdt*Tthetaw + ...
	2*rw*RA*nw*dthetawdt*Tdthetawdx - ...
	2*dddr0wdxdxdt*(Tthetaw-Tthetap)/dthetawdx - ...
	dddr0wdxdxdx*(dthetawdt-dthetapdt)/dthetawdx*(Tthetaw-Tthetap)/dthetawdx;
dTw = [dTr0w;dTdr0wdx];
% dTdr0cdx = 2*rw*RA*skew(omegaA)*dTxw*gy*dthetawdx*Tthetap - ...
% 	rw*RA*Txw*gy*dthetawdx*(dthetapdt*Tthetap-dthetawdt*Tthetaw) - ...
% 	2*rw*RA*dTxw*gy*ddthetawdxdt*Tthetaw;
% dTw = [dTrc0;dTdr0cdx];
end
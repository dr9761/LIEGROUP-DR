function [Mass,Force] = add_Redundant_DoF_WinchCable(...
	Mass,Force,qe,dqe)
%%
thetapNr = 7;
thetawNr = 8;
dthetawdxNr = 9;
swNr = 10;
%%
dthetawdx = qe(dthetawdxNr);
ddthetawdxdt = dqe(dthetawdxNr);
dthetawdt = dqe(thetawNr);
dthetapdt = dqe(thetapNr);
dswdt = dqe(swNr);
%%
Mass(swNr,thetawNr) = 1;
Mass(swNr,swNr) = -dthetawdx;
Mass(swNr,thetapNr) = -1;
%%
Force(swNr) = ddthetawdxdt*(dthetawdt-dthetapdt)/dthetawdx;
end
function [dvABdt] = vABfunc(t,vAB,SystemForceFcn,MassMtx)
dvABdt = zeros(12,1);
dvABdt = inv(MassMtx)*SystemForceFcn;

end
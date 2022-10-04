function [y0] = dealIn(x0)
y0 = zeros(36,1);
xA = x0(1:3);
phiA = x0(4:6);
RA = getR(phiA)
xB = x0(7:9);
phiB = x0(10:12);
RB = getR(phiB);
vA = x0(13:18)
vB = x0(19:24)
y0 = [RA(1:3)';RA(4:6)';RA(7:9)';xA;RB(1:3)';RB(4:6)';RB(7:9)';xB;vA;vB];

end
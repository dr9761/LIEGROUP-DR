function plot_CableOnWinch(qe,InterpolationNr,BodyParameter,PlotStyle)
%%
CableRadius = BodyParameter.CableRadius;
WinchRadius = BodyParameter.WinchRadius;
phiwc0 = BodyParameter.phiwc0;
rwc0x = BodyParameter.rwc0x;
w_rww0 = [rwc0x;0;0];
w_rw0c0 = [0;-WinchRadius*sin(phiwc0);WinchRadius*cos(phiwc0)];

CableOnWinchParameter = BodyParameter.CableOnWinchParameter;
L  = CableOnWinchParameter.L;
%%
gx = [1;0;0];
%%
qw = qe(1:6);
r0w = qw(1:3);
phiw = qw(4:6);
Rw = get_R(phiw);

qc = qe(7);
thetac = qc(1);
%%
x_set = 0:L/InterpolationNr:L;
r_set = zeros(3,InterpolationNr+1);
%%
for i = 1:InterpolationNr+1
	x = x_set(i);
	thetax = x/L*thetac;
	r = r0w + Rw*w_rww0 + ...
		Rw*get_R_x(thetax)*w_rw0c0 + CableRadius/pi*thetax*Rw*gx;
	r_set(:,i) = r;
end
%%
x = r_set(1,:);
y = r_set(2,:);
z = r_set(3,:);
%%
plot3(x,y,z,PlotStyle);
end
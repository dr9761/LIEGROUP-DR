function sWJW = Intergrated_Shapefunction_sWJW(...
	BodyParameter,dqd_end)
%%
L = BodyParameter.L;
E = BodyParameter.E;
G = BodyParameter.G;
A = BodyParameter.A;
Iy = BodyParameter.Iy;
Iz = BodyParameter.Iz;
%%
u0     = dqd_end(1);
v0     = dqd_end(2);
w0     = dqd_end(3);
phi0   = dqd_end(4);
psi0   = dqd_end(5);
theta0 = dqd_end(6);
ue     = dqd_end(7);
ve     = dqd_end(8);
we     = dqd_end(9);
phie   = dqd_end(10);
psie   = dqd_end(11);
thetae = dqd_end(12);
%%
sWJW = zeros(3,1);
%%
sWJW(1) = -(L*(Iy - Iz) * ...
	(4*A^2*G^2*L^4*psi0*theta0 - A^2*G^2*L^4*psi0*thetae - ...
	A^2*G^2*L^4*psie*theta0 + 4*A^2*G^2*L^4*psie*thetae + ...
	3*A^2*G^2*L^3*psi0*v0 + 3*A^2*G^2*L^3*psie*v0 - ...
	3*A^2*G^2*L^3*psi0*ve - 3*A^2*G^2*L^3*psie*ve - ...
	3*A^2*G^2*L^3*theta0*w0 - 3*A^2*G^2*L^3*thetae*w0 + ...
	3*A^2*G^2*L^3*theta0*we + 3*A^2*G^2*L^3*thetae*we - ...
	36*A^2*G^2*L^2*v0*w0 + 36*A^2*G^2*L^2*v0*we + ...
	36*A^2*G^2*L^2*ve*w0 - 36*A^2*G^2*L^2*ve*we + ...
	23040*E^2*Iy*Iz*psi0*theta0 + 11520*E^2*Iy*Iz*psi0*thetae + ...
	11520*E^2*Iy*Iz*psie*theta0 + 23040*E^2*Iy*Iz*psie*thetae + ...
	120*A*E*G*Iy*L^2*psi0*theta0 - 120*A*E*G*Iy*L^2*psi0*thetae - ...
	120*A*E*G*Iy*L^2*psie*theta0 + 120*A*E*G*Iy*L^2*psie*thetae + ...
	120*A*E*G*Iz*L^2*psi0*theta0 - 120*A*E*G*Iz*L^2*psi0*thetae - ...
	120*A*E*G*Iz*L^2*psie*theta0 + 120*A*E*G*Iz*L^2*psie*thetae - ...
	720*A*E*G*Iz*L*psi0*v0 - 720*A*E*G*Iz*L*psie*v0 + ...
	720*A*E*G*Iz*L*psi0*ve + 720*A*E*G*Iz*L*psie*ve + ...
	720*A*E*G*Iy*L*theta0*w0 + 720*A*E*G*Iy*L*thetae*w0 - ...
	720*A*E*G*Iy*L*theta0*we - 720*A*E*G*Iy*L*thetae*we)) / ...
	(30*(A*G*L^2 + 48*E*Iy) * (A*G*L^2 + 48*E*Iz));
sWJW(2) = -(Iz*L*(...
	192*E*Iy*phi0*theta0 + 96*E*Iy*phi0*thetae + ...
	96*E*Iy*phie*theta0 + 192*E*Iy*phie*thetae - ...
	6*A*G*L*phi0*v0 - 6*A*G*L*phie*v0 + 6*A*G*L*phi0*ve + 6*A*G*L*phie*ve + ...
	A*G*L^2*phi0*theta0 - A*G*L^2*phi0*thetae - ...
	A*G*L^2*phie*theta0 + A*G*L^2*phie*thetae)) / ...
	(12*(A*G*L^2 + 48*E*Iy));
sWJW(3) = (Iy*L*(...
	192*E*Iz*phi0*psi0 + 96*E*Iz*phi0*psie + ...
	96*E*Iz*phie*psi0 + 192*E*Iz*phie*psie + ...
	6*A*G*L*phi0*w0 + 6*A*G*L*phie*w0 - 6*A*G*L*phi0*we - 6*A*G*L*phie*we + ...
	A*G*L^2*phi0*psi0 - A*G*L^2*phi0*psie - ...
	A*G*L^2*phie*psi0 + A*G*L^2*phie*psie)) / ...
	(12*(A*G*L^2 + 48*E*Iz));
end
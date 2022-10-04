function sNWJW = Intergrated_Shapefunction_sNWJW(...
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
sNWJW = zeros(12,1);
%%
sNWJW(1) = -(L*(Iy - Iz)*(6*A^2*G^2*L^4*psi0*theta0 - A^2*G^2*L^4*psi0*thetae - A^2*G^2*L^4*psie*theta0 + 2*A^2*G^2*L^4*psie*thetae + 6*A^2*G^2*L^3*psie*v0 - 6*A^2*G^2*L^3*psie*ve - 6*A^2*G^2*L^3*thetae*w0 + 6*A^2*G^2*L^3*thetae*we - 36*A^2*G^2*L^2*v0*w0 + 36*A^2*G^2*L^2*v0*we + 36*A^2*G^2*L^2*ve*w0 - 36*A^2*G^2*L^2*ve*we + 34560*E^2*Iy*Iz*psi0*theta0 + 11520*E^2*Iy*Iz*psi0*thetae + 11520*E^2*Iy*Iz*psie*theta0 + 11520*E^2*Iy*Iz*psie*thetae + 288*A*E*G*Iy*L^2*psi0*theta0 - 48*A*E*G*Iy*L^2*psi0*thetae - 192*A*E*G*Iy*L^2*psie*theta0 - 48*A*E*G*Iy*L^2*psie*thetae + 288*A*E*G*Iz*L^2*psi0*theta0 - 192*A*E*G*Iz*L^2*psi0*thetae - 48*A*E*G*Iz*L^2*psie*theta0 - 48*A*E*G*Iz*L^2*psie*thetae - 864*A*E*G*Iz*L*psi0*v0 - 576*A*E*G*Iz*L*psie*v0 + 864*A*E*G*Iz*L*psi0*ve + 576*A*E*G*Iz*L*psie*ve + 864*A*E*G*Iy*L*theta0*w0 + 576*A*E*G*Iy*L*thetae*w0 - 864*A*E*G*Iy*L*theta0*we - 576*A*E*G*Iy*L*thetae*we))/(60*(A*G*L^2 + 48*E*Iy)*(A*G*L^2 + 48*E*Iz));
sNWJW(2) = -(Iz*L*(241920*E^2*Iy^2*phi0*theta0 + 80640*E^2*Iy^2*phi0*thetae + 80640*E^2*Iy^2*phie*theta0 + 80640*E^2*Iy^2*phie*thetae + 46*A^2*G^2*L^4*phi0*theta0 - 31*A^2*G^2*L^4*phi0*thetae - 4*A^2*G^2*L^4*phie*theta0 - 11*A^2*G^2*L^4*phie*thetae - 132*A^2*G^2*L^3*phi0*v0 - 78*A^2*G^2*L^3*phie*v0 + 132*A^2*G^2*L^3*phi0*ve + 78*A^2*G^2*L^3*phie*ve + 7392*A*E*G*Iy*L^2*phi0*theta0 + 336*A*E*G*Iy*L^2*phi0*thetae + 1344*A*E*G*Iy*L^2*phie*theta0 + 1008*A*E*G*Iy*L^2*phie*thetae - 6048*A*E*G*Iy*L*phi0*v0 - 4032*A*E*G*Iy*L*phie*v0 + 6048*A*E*G*Iy*L*phi0*ve + 4032*A*E*G*Iy*L*phie*ve))/(420*(48*E*Iy + A*G*L^2)^2);
sNWJW(3) = (Iy*L*(241920*E^2*Iz^2*phi0*psi0 + 80640*E^2*Iz^2*phi0*psie + 80640*E^2*Iz^2*phie*psi0 + 80640*E^2*Iz^2*phie*psie + 46*A^2*G^2*L^4*phi0*psi0 - 31*A^2*G^2*L^4*phi0*psie - 4*A^2*G^2*L^4*phie*psi0 - 11*A^2*G^2*L^4*phie*psie + 132*A^2*G^2*L^3*phi0*w0 + 78*A^2*G^2*L^3*phie*w0 - 132*A^2*G^2*L^3*phi0*we - 78*A^2*G^2*L^3*phie*we + 7392*A*E*G*Iz*L^2*phi0*psi0 + 336*A*E*G*Iz*L^2*phi0*psie + 1344*A*E*G*Iz*L^2*phie*psi0 + 1008*A*E*G*Iz*L^2*phie*psie + 6048*A*E*G*Iz*L*phi0*w0 + 4032*A*E*G*Iz*L*phie*w0 - 6048*A*E*G*Iz*L*phi0*we - 4032*A*E*G*Iz*L*phie*we))/(420*(48*E*Iz + A*G*L^2)^2);
sNWJW(4) = 0;
sNWJW(5) = -(Iy*L^2*(24192*E^2*Iz^2*phi0*psi0 + 16128*E^2*Iz^2*phi0*psie + 16128*E^2*Iz^2*phie*psi0 + 24192*E^2*Iz^2*phie*psie + 2*A^2*G^2*L^4*phi0*psi0 - 5*A^2*G^2*L^4*phi0*psie - 2*A^2*G^2*L^4*phie*psi0 - 2*A^2*G^2*L^4*phie*psie + 24*A^2*G^2*L^3*phi0*w0 + 18*A^2*G^2*L^3*phie*w0 - 24*A^2*G^2*L^3*phi0*we - 18*A^2*G^2*L^3*phie*we + 672*A*E*G*Iz*L^2*phi0*psi0 + 168*A*E*G*Iz*L^2*phi0*psie + 168*A*E*G*Iz*L^2*phie*psi0 + 336*A*E*G*Iz*L^2*phie*psie + 1008*A*E*G*Iz*L*phi0*w0 + 1008*A*E*G*Iz*L*phie*w0 - 1008*A*E*G*Iz*L*phi0*we - 1008*A*E*G*Iz*L*phie*we))/(420*(48*E*Iz + A*G*L^2)^2);
sNWJW(6) = -(Iz*L^2*(24192*E^2*Iy^2*phi0*theta0 + 16128*E^2*Iy^2*phi0*thetae + 16128*E^2*Iy^2*phie*theta0 + 24192*E^2*Iy^2*phie*thetae + 2*A^2*G^2*L^4*phi0*theta0 - 5*A^2*G^2*L^4*phi0*thetae - 2*A^2*G^2*L^4*phie*theta0 - 2*A^2*G^2*L^4*phie*thetae - 24*A^2*G^2*L^3*phi0*v0 - 18*A^2*G^2*L^3*phie*v0 + 24*A^2*G^2*L^3*phi0*ve + 18*A^2*G^2*L^3*phie*ve + 672*A*E*G*Iy*L^2*phi0*theta0 + 168*A*E*G*Iy*L^2*phi0*thetae + 168*A*E*G*Iy*L^2*phie*theta0 + 336*A*E*G*Iy*L^2*phie*thetae - 1008*A*E*G*Iy*L*phi0*v0 - 1008*A*E*G*Iy*L*phie*v0 + 1008*A*E*G*Iy*L*phi0*ve + 1008*A*E*G*Iy*L*phie*ve))/(420*(48*E*Iy + A*G*L^2)^2);
sNWJW(7) = -(L*(Iy - Iz)*(2*A^2*G^2*L^4*psi0*theta0 - A^2*G^2*L^4*psi0*thetae - A^2*G^2*L^4*psie*theta0 + 6*A^2*G^2*L^4*psie*thetae + 6*A^2*G^2*L^3*psi0*v0 - 6*A^2*G^2*L^3*psi0*ve - 6*A^2*G^2*L^3*theta0*w0 + 6*A^2*G^2*L^3*theta0*we - 36*A^2*G^2*L^2*v0*w0 + 36*A^2*G^2*L^2*v0*we + 36*A^2*G^2*L^2*ve*w0 - 36*A^2*G^2*L^2*ve*we + 11520*E^2*Iy*Iz*psi0*theta0 + 11520*E^2*Iy*Iz*psi0*thetae + 11520*E^2*Iy*Iz*psie*theta0 + 34560*E^2*Iy*Iz*psie*thetae - 48*A*E*G*Iy*L^2*psi0*theta0 - 192*A*E*G*Iy*L^2*psi0*thetae - 48*A*E*G*Iy*L^2*psie*theta0 + 288*A*E*G*Iy*L^2*psie*thetae - 48*A*E*G*Iz*L^2*psi0*theta0 - 48*A*E*G*Iz*L^2*psi0*thetae - 192*A*E*G*Iz*L^2*psie*theta0 + 288*A*E*G*Iz*L^2*psie*thetae - 576*A*E*G*Iz*L*psi0*v0 - 864*A*E*G*Iz*L*psie*v0 + 576*A*E*G*Iz*L*psi0*ve + 864*A*E*G*Iz*L*psie*ve + 576*A*E*G*Iy*L*theta0*w0 + 864*A*E*G*Iy*L*thetae*w0 - 576*A*E*G*Iy*L*theta0*we - 864*A*E*G*Iy*L*thetae*we))/(60*(A*G*L^2 + 48*E*Iy)*(A*G*L^2 + 48*E*Iz));
sNWJW(8) = -(Iz*L*(80640*E^2*Iy^2*phi0*theta0 + 80640*E^2*Iy^2*phi0*thetae + 80640*E^2*Iy^2*phie*theta0 + 241920*E^2*Iy^2*phie*thetae - 11*A^2*G^2*L^4*phi0*theta0 - 4*A^2*G^2*L^4*phi0*thetae - 31*A^2*G^2*L^4*phie*theta0 + 46*A^2*G^2*L^4*phie*thetae - 78*A^2*G^2*L^3*phi0*v0 - 132*A^2*G^2*L^3*phie*v0 + 78*A^2*G^2*L^3*phi0*ve + 132*A^2*G^2*L^3*phie*ve + 1008*A*E*G*Iy*L^2*phi0*theta0 + 1344*A*E*G*Iy*L^2*phi0*thetae + 336*A*E*G*Iy*L^2*phie*theta0 + 7392*A*E*G*Iy*L^2*phie*thetae - 4032*A*E*G*Iy*L*phi0*v0 - 6048*A*E*G*Iy*L*phie*v0 + 4032*A*E*G*Iy*L*phi0*ve + 6048*A*E*G*Iy*L*phie*ve))/(420*(48*E*Iy + A*G*L^2)^2);
sNWJW(9) = (Iy*L*(80640*E^2*Iz^2*phi0*psi0 + 80640*E^2*Iz^2*phi0*psie + 80640*E^2*Iz^2*phie*psi0 + 241920*E^2*Iz^2*phie*psie - 11*A^2*G^2*L^4*phi0*psi0 - 4*A^2*G^2*L^4*phi0*psie - 31*A^2*G^2*L^4*phie*psi0 + 46*A^2*G^2*L^4*phie*psie + 78*A^2*G^2*L^3*phi0*w0 + 132*A^2*G^2*L^3*phie*w0 - 78*A^2*G^2*L^3*phi0*we - 132*A^2*G^2*L^3*phie*we + 1008*A*E*G*Iz*L^2*phi0*psi0 + 1344*A*E*G*Iz*L^2*phi0*psie + 336*A*E*G*Iz*L^2*phie*psi0 + 7392*A*E*G*Iz*L^2*phie*psie + 4032*A*E*G*Iz*L*phi0*w0 + 6048*A*E*G*Iz*L*phie*w0 - 4032*A*E*G*Iz*L*phi0*we - 6048*A*E*G*Iz*L*phie*we))/(420*(48*E*Iz + A*G*L^2)^2);
sNWJW(10) = 0;
sNWJW(11) = (Iy*L^2*(24192*E^2*Iz^2*phi0*psi0 + 16128*E^2*Iz^2*phi0*psie + 16128*E^2*Iz^2*phie*psi0 + 24192*E^2*Iz^2*phie*psie - 2*A^2*G^2*L^4*phi0*psi0 - 2*A^2*G^2*L^4*phi0*psie - 5*A^2*G^2*L^4*phie*psi0 + 2*A^2*G^2*L^4*phie*psie + 18*A^2*G^2*L^3*phi0*w0 + 24*A^2*G^2*L^3*phie*w0 - 18*A^2*G^2*L^3*phi0*we - 24*A^2*G^2*L^3*phie*we + 336*A*E*G*Iz*L^2*phi0*psi0 + 168*A*E*G*Iz*L^2*phi0*psie + 168*A*E*G*Iz*L^2*phie*psi0 + 672*A*E*G*Iz*L^2*phie*psie + 1008*A*E*G*Iz*L*phi0*w0 + 1008*A*E*G*Iz*L*phie*w0 - 1008*A*E*G*Iz*L*phi0*we - 1008*A*E*G*Iz*L*phie*we))/(420*(48*E*Iz + A*G*L^2)^2);
sNWJW(12) = (Iz*L^2*(24192*E^2*Iy^2*phi0*theta0 + 16128*E^2*Iy^2*phi0*thetae + 16128*E^2*Iy^2*phie*theta0 + 24192*E^2*Iy^2*phie*thetae - 2*A^2*G^2*L^4*phi0*theta0 - 2*A^2*G^2*L^4*phi0*thetae - 5*A^2*G^2*L^4*phie*theta0 + 2*A^2*G^2*L^4*phie*thetae - 18*A^2*G^2*L^3*phi0*v0 - 24*A^2*G^2*L^3*phie*v0 + 18*A^2*G^2*L^3*phi0*ve + 24*A^2*G^2*L^3*phie*ve + 336*A*E*G*Iy*L^2*phi0*theta0 + 168*A*E*G*Iy*L^2*phi0*thetae + 168*A*E*G*Iy*L^2*phie*theta0 + 672*A*E*G*Iy*L^2*phie*thetae - 1008*A*E*G*Iy*L*phi0*v0 - 1008*A*E*G*Iy*L*phie*v0 + 1008*A*E*G*Iy*L*phi0*ve + 1008*A*E*G*Iy*L*phie*ve))/(420*(48*E*Iy + A*G*L^2)^2);
end
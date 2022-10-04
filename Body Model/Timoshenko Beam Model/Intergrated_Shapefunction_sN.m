function sN = Intergrated_Shapefunction_sN(...
	BodyParameter)
%%
L = BodyParameter.L;
E = BodyParameter.E;
G = BodyParameter.G;
A = BodyParameter.A;
Iy = BodyParameter.Iy;
Iz = BodyParameter.Iz;
%%
u   = 1;v   = 2;w     = 3;
phi = 4;psi = 5;theta = 6;

u0   = 1;v0    = 2;w0      = 3;
phi0 = 4;psi0  = 5;theta0  = 6;
ue   = 7;ve    = 8;we      = 9;
phie = 10;psie = 11;thetae = 12;

sN = zeros(6,12);
%%
sN(u,u0) = L/2;
sN(u,ue) = L/2;
%
sN(v,v0) = L/2;
sN(v,theta0) = L^2/12;
sN(v,ve) = L/2;
sN(v,thetae) = -L^2/12;
%
sN(w,w0) = L/2;
sN(w,psi0) = -L^2/12;
sN(w,we) = L/2;
sN(w,psie) = L^2/12;
%
sN(phi,phi0) = L/2;
sN(phi,phie) = L/2;
%
sN(psi,w0) = (A*G*L^2)/(A*G*L^2 + 48*E*Iz);
sN(psi,psi0) = (24*E*Iz*L)/(A*G*L^2 + 48*E*Iz);
sN(psi,we) = -(A*G*L^2)/(A*G*L^2 + 48*E*Iz);
sN(psi,psie) = (24*E*Iz*L)/(A*G*L^2 + 48*E*Iz);
%
sN(theta,v0) = -(A*G*L^2)/(A*G*L^2 + 48*E*Iy);
sN(theta,theta0) = (24*E*Iy*L)/(A*G*L^2 + 48*E*Iy);
sN(theta,ve) = (A*G*L^2)/(A*G*L^2 + 48*E*Iy);
sN(theta,thetae) = (24*E*Iy*L)/(A*G*L^2 + 48*E*Iy);
end
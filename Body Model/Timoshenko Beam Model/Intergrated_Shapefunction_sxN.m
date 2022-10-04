function sxN = Intergrated_Shapefunction_sxN(...
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

sxN = zeros(6,12);
%%
sxN(u,u0) = L^2/6;
sxN(u,ue) = L^2/3;
%
sxN(v,v0) = (3*L^2)/20 + (4*E*Iy*L^2)/(5*(A*G*L^2 + 48*E*Iy));
sxN(v,theta0) = L^3/30 + (2*E*Iy*L^3)/(5*(A*G*L^2 + 48*E*Iy));
sxN(v,ve) = L^2/3 + (A*G*L^4)/(60*(A*G*L^2 + 48*E*Iy));
sxN(v,thetae) = (2*E*Iy*L^3)/(5*(A*G*L^2 + 48*E*Iy)) - L^3/20;
%
sxN(w,w0) = (3*L^2)/20 + (4*E*Iz*L^2)/(5*(A*G*L^2 + 48*E*Iz));
sxN(w,psi0) = - L^3/30 - (2*E*Iz*L^3)/(5*(A*G*L^2 + 48*E*Iz));
sxN(w,we) = L^2/3 + (A*G*L^4)/(60*(A*G*L^2 + 48*E*Iz));
sxN(w,psie) = L^3/20 - (2*E*Iz*L^3)/(5*(A*G*L^2 + 48*E*Iz));
%
sxN(phi,phi0) = L^2/6;
sxN(phi,phie) = L^2/3;
%
sxN(psi,w0) = (A*G*L^3)/(2*A*G*L^2 + 96*E*Iz);
sxN(psi,psi0) = (12*E*Iz*L^2)/(A*G*L^2 + 48*E*Iz) - L^2/12;
sxN(psi,we) = -(A*G*L^3)/(2*A*G*L^2 + 96*E*Iz);
sxN(psi,psie) = L^2/12 + (12*E*Iz*L^2)/(A*G*L^2 + 48*E*Iz);
%
sxN(theta,v0) = -(A*G*L^3)/(2*A*G*L^2 + 96*E*Iy);
sxN(theta,theta0) = (12*E*Iy*L^2)/(A*G*L^2 + 48*E*Iy) - L^2/12;
sxN(theta,ve) = (A*G*L^3)/(2*A*G*L^2 + 96*E*Iy);
sxN(theta,thetae) = L^2/12 + (12*E*Iy*L^2)/(A*G*L^2 + 48*E*Iy);
end
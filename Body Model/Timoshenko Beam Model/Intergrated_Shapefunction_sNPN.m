function sNPN = Intergrated_Shapefunction_sNPN(...
	BodyParameter)
%%
L = BodyParameter.L;
E = BodyParameter.E;
G = BodyParameter.G;
A = BodyParameter.A;
Iy = BodyParameter.Iy;
Iz = BodyParameter.Iz;
%%
u0   = 1;v0    = 2;w0      = 3;
phi0 = 4;psi0  = 5;theta0  = 6;
ue   = 7;ve    = 8;we      = 9;
phie = 10;psie = 11;thetae = 12;

sNPN = zeros(12,12);
%%
sNPN(u0,u0) = (A*L)/3;
sNPN(ue,u0) = (A*L)/6;
%
sNPN(v0,v0) = (A*L*(13*A^2*G^2*L^4 + 1176*A*E*G*Iy*L^2 + 42*A*G^2*Iy*L^2 + 26880*E^2*Iy^2))/(35*(48*E*Iy + A*G*L^2)^2);
sNPN(theta0,v0) = (A*L^2*(11*A^2*G^2*L^4 + 924*A*E*G*Iy*L^2 + 21*A*G^2*Iy*L^2 + 20160*E^2*Iy^2 - 5040*E*G*Iy^2))/(210*(48*E*Iy + A*G*L^2)^2);
sNPN(ve,v0) = (3*A*L*(3*A^2*G^2*L^4 + 336*A*E*G*Iy*L^2 - 28*A*G^2*Iy*L^2 + 8960*E^2*Iy^2))/(70*(48*E*Iy + A*G*L^2)^2);
sNPN(thetae,v0) = -(A*L^2*(13*A^2*G^2*L^4 + 1512*A*E*G*Iy*L^2 - 42*A*G^2*Iy*L^2 + 40320*E^2*Iy^2 + 10080*E*G*Iy^2))/(420*(48*E*Iy + A*G*L^2)^2);
%
sNPN(w0,w0) = (A*L*(13*A^2*G^2*L^4 + 1176*A*E*G*Iz*L^2 + 42*A*G^2*Iz*L^2 + 26880*E^2*Iz^2))/(35*(48*E*Iz + A*G*L^2)^2);
sNPN(psi0,w0) = -(A*L^2*(11*A^2*G^2*L^4 + 924*A*E*G*Iz*L^2 + 21*A*G^2*Iz*L^2 + 20160*E^2*Iz^2 - 5040*E*G*Iz^2))/(210*(48*E*Iz + A*G*L^2)^2);
sNPN(we,w0) = (3*A*L*(3*A^2*G^2*L^4 + 336*A*E*G*Iz*L^2 - 28*A*G^2*Iz*L^2 + 8960*E^2*Iz^2))/(70*(48*E*Iz + A*G*L^2)^2);
sNPN(psie,w0) = (A*L^2*(13*A^2*G^2*L^4 + 1512*A*E*G*Iz*L^2 - 42*A*G^2*Iz*L^2 + 40320*E^2*Iz^2 + 10080*E*G*Iz^2))/(420*(48*E*Iz + A*G*L^2)^2);
%
sNPN(phi0,phi0) = (L*(Iy + Iz))/3;
sNPN(phie,phi0) = (L*(Iy + Iz))/6;
%
sNPN(w0,psi0) = -(L^2*((11*A^3*G^2*L^4)/210 + (22*A^2*E*G*Iz*L^2)/5 + (A^2*G^2*Iz*L^2)/10 + 96*A*E^2*Iz^2 - 24*A*E*G*Iz^2))/(48*E*Iz + A*G*L^2)^2;
sNPN(psi0,psi0) = (L*(A^3*G^2*L^6 + 84*A^2*E*G*Iz*L^4 + 14*A^2*G^2*Iz*L^4 + 2016*A*E^2*Iz^2*L^2 + 840*A*E*G*Iz^2*L^2 + 80640*E^2*Iz^3))/(105*(48*E*Iz + A*G*L^2)^2);
sNPN(we,psi0) = -(L^2*((13*A^3*G^2*L^4)/420 + (18*A^2*E*G*Iz*L^2)/5 - (A^2*G^2*Iz*L^2)/10 + 96*A*E^2*Iz^2 + 24*A*E*G*Iz^2))/(48*E*Iz + A*G*L^2)^2;
sNPN(psie,psi0) = -(L*(3*A^3*G^2*L^6 + 336*A^2*E*G*Iz*L^4 + 14*A^2*G^2*Iz*L^4 + 8064*A*E^2*Iz^2*L^2 + 3360*A*E*G*Iz^2*L^2 - 161280*E^2*Iz^3))/(420*(48*E*Iz + A*G*L^2)^2);
%
sNPN(v0,theta0) = (L^2*((11*A^3*G^2*L^4)/210 + (22*A^2*E*G*Iy*L^2)/5 + (A^2*G^2*Iy*L^2)/10 + 96*A*E^2*Iy^2 - 24*A*E*G*Iy^2))/(48*E*Iy + A*G*L^2)^2;
sNPN(theta0,theta0) = (L*(A^3*G^2*L^6 + 84*A^2*E*G*Iy*L^4 + 14*A^2*G^2*Iy*L^4 + 2016*A*E^2*Iy^2*L^2 + 840*A*E*G*Iy^2*L^2 + 80640*E^2*Iy^3))/(105*(48*E*Iy + A*G*L^2)^2);
sNPN(ve,theta0) = (L^2*((13*A^3*G^2*L^4)/420 + (18*A^2*E*G*Iy*L^2)/5 - (A^2*G^2*Iy*L^2)/10 + 96*A*E^2*Iy^2 + 24*A*E*G*Iy^2))/(48*E*Iy + A*G*L^2)^2;
sNPN(thetae,theta0) = -(L*(3*A^3*G^2*L^6 + 336*A^2*E*G*Iy*L^4 + 14*A^2*G^2*Iy*L^4 + 8064*A*E^2*Iy^2*L^2 + 3360*A*E*G*Iy^2*L^2 - 161280*E^2*Iy^3))/(420*(48*E*Iy + A*G*L^2)^2);
%
sNPN(u0,ue) = (A*L)/6;
sNPN(ue,ue) = (A*L)/3;
%
sNPN(v0,ve) = (3*A*L*(3*A^2*G^2*L^4 + 336*A*E*G*Iy*L^2 - 28*A*G^2*Iy*L^2 + 8960*E^2*Iy^2))/(70*(48*E*Iy + A*G*L^2)^2);
sNPN(theta0,ve) = (A*L^2*(13*A^2*G^2*L^4 + 1512*A*E*G*Iy*L^2 - 42*A*G^2*Iy*L^2 + 40320*E^2*Iy^2 + 10080*E*G*Iy^2))/(420*(48*E*Iy + A*G*L^2)^2);
sNPN(ve,ve) = (A*L*(13*A^2*G^2*L^4 + 1176*A*E*G*Iy*L^2 + 42*A*G^2*Iy*L^2 + 26880*E^2*Iy^2))/(35*(48*E*Iy + A*G*L^2)^2);
sNPN(thetae,ve) = -(A*L^2*(11*A^2*G^2*L^4 + 924*A*E*G*Iy*L^2 + 21*A*G^2*Iy*L^2 + 20160*E^2*Iy^2 - 5040*E*G*Iy^2))/(210*(48*E*Iy + A*G*L^2)^2);
%
sNPN(w0,we) = (3*A*L*(3*A^2*G^2*L^4 + 336*A*E*G*Iz*L^2 - 28*A*G^2*Iz*L^2 + 8960*E^2*Iz^2))/(70*(48*E*Iz + A*G*L^2)^2);
sNPN(psi0,we) = -(A*L^2*(13*A^2*G^2*L^4 + 1512*A*E*G*Iz*L^2 - 42*A*G^2*Iz*L^2 + 40320*E^2*Iz^2 + 10080*E*G*Iz^2))/(420*(48*E*Iz + A*G*L^2)^2);
sNPN(we,we) = (A*L*(13*A^2*G^2*L^4 + 1176*A*E*G*Iz*L^2 + 42*A*G^2*Iz*L^2 + 26880*E^2*Iz^2))/(35*(48*E*Iz + A*G*L^2)^2);
sNPN(psie,we) = (A*L^2*(11*A^2*G^2*L^4 + 924*A*E*G*Iz*L^2 + 21*A*G^2*Iz*L^2 + 20160*E^2*Iz^2 - 5040*E*G*Iz^2))/(210*(48*E*Iz + A*G*L^2)^2);
%
sNPN(phi0,phie) = (L*(Iy + Iz))/6;
sNPN(phie,phie) = (L*(Iy + Iz))/3;
%
sNPN(w0,psie) = (L^2*((13*A^3*G^2*L^4)/420 + (18*A^2*E*G*Iz*L^2)/5 - (A^2*G^2*Iz*L^2)/10 + 96*A*E^2*Iz^2 + 24*A*E*G*Iz^2))/(48*E*Iz + A*G*L^2)^2;
sNPN(psi0,psie) = -(L*(3*A^3*G^2*L^6 + 336*A^2*E*G*Iz*L^4 + 14*A^2*G^2*Iz*L^4 + 8064*A*E^2*Iz^2*L^2 + 3360*A*E*G*Iz^2*L^2 - 161280*E^2*Iz^3))/(420*(48*E*Iz + A*G*L^2)^2);
sNPN(we,psie) = (L^2*((11*A^3*G^2*L^4)/210 + (22*A^2*E*G*Iz*L^2)/5 + (A^2*G^2*Iz*L^2)/10 + 96*A*E^2*Iz^2 - 24*A*E*G*Iz^2))/(48*E*Iz + A*G*L^2)^2;
sNPN(psie,psie) = (L*(A^3*G^2*L^6 + 84*A^2*E*G*Iz*L^4 + 14*A^2*G^2*Iz*L^4 + 2016*A*E^2*Iz^2*L^2 + 840*A*E*G*Iz^2*L^2 + 80640*E^2*Iz^3))/(105*(48*E*Iz + A*G*L^2)^2);
%
sNPN(v0,thetae) = -(L^2*((13*A^3*G^2*L^4)/420 + (18*A^2*E*G*Iy*L^2)/5 - (A^2*G^2*Iy*L^2)/10 + 96*A*E^2*Iy^2 + 24*A*E*G*Iy^2))/(48*E*Iy + A*G*L^2)^2;
sNPN(theta0,thetae) = -(L*(3*A^3*G^2*L^6 + 336*A^2*E*G*Iy*L^4 + 14*A^2*G^2*Iy*L^4 + 8064*A*E^2*Iy^2*L^2 + 3360*A*E*G*Iy^2*L^2 - 161280*E^2*Iy^3))/(420*(48*E*Iy + A*G*L^2)^2);
sNPN(ve,thetae) = -(L^2*((11*A^3*G^2*L^4)/210 + (22*A^2*E*G*Iy*L^2)/5 + (A^2*G^2*Iy*L^2)/10 + 96*A*E^2*Iy^2 - 24*A*E*G*Iy^2))/(48*E*Iy + A*G*L^2)^2;
sNPN(thetae,thetae) = (L*(A^3*G^2*L^6 + 84*A^2*E*G*Iy*L^4 + 14*A^2*G^2*Iy*L^4 + 2016*A*E^2*Iy^2*L^2 + 840*A*E*G*Iy^2*L^2 + 80640*E^2*Iy^3))/(105*(48*E*Iy + A*G*L^2)^2);

end
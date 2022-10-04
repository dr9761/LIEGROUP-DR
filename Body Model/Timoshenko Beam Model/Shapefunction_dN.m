function dN = Shapefunction_dN(BodyParameter,xi)
%%
L = BodyParameter.L;
E = BodyParameter.E;
G = BodyParameter.G;
A = BodyParameter.A;
Iy = BodyParameter.Iy;
Iz = BodyParameter.Iz;
%%
alpha_y = 48*E*Iy/(G*A*L^2);
beta_y = 1/(1+alpha_y);
alpha_z = 48*E*Iz/(G*A*L^2);
beta_z = 1/(1+alpha_z);
%% set coordination
u = 1;v = 2;w = 3;
phi = 4;psi = 5;theta = 6;
u0 = 1;v0 = 2;w0 = 3;
phi0 = 4;psi0 = 5;theta0 = 6;
ue = 7;ve = 8;we = 9;
phie = 10;psie = 11;thetae = 12;
dN = zeros(6,12);
%% Hu
dN(u,u0) = -1/L;
dN(u,ue) = 1/L;
%% Hv
dN(v,v0) = beta_y/L * (6*xi^2 - 6*xi - alpha_y);
dN(v,theta0) = beta_y * (3*xi^2 -2*(alpha_y/2+2)*xi + (1/2*alpha_y+1));
dN(v,ve) = beta_y/L * (-6*xi^2 + 6*xi + alpha_y);
dN(v,thetae) = beta_y * (3*xi^2 +2*(alpha_y-2)/2*xi - 1/2*alpha_y);
%% Hw
dN(w,w0) = beta_z/L * (6*xi^2 - 6*xi - alpha_z);
dN(w,psi0) = beta_z * (-3*xi^2 + 2*(alpha_z/2+2)*xi - (1/2*alpha_z+1));
dN(w,we) = beta_z/L * (-6*xi^2 + 6*xi + alpha_z);
dN(w,psie) = -beta_z * (3*xi^2 + 2*(alpha_z-2)/2*xi - 1/2*alpha_z);
%% Hphi
dN(phi,phi0) = -1/L;
dN(phi,phie) = 1/L;
%% Hpsi
dN(psi,w0) = -6*beta_z/L/L * (2*xi - 1);
dN(psi,psi0) = beta_z/L * (6*xi - (alpha_z+4));
dN(psi,we) = 6*beta_z/L/L * (2*xi - 1);
dN(psi,psie) = beta_z/L * (6*xi + (alpha_z-2));
%% Htheta
dN(theta,v0) = 6*beta_y/L/L * (2*xi - 1);
dN(theta,theta0) = beta_y/L * (6*xi - (alpha_y+4));
dN(theta,ve) = -6*beta_y/L/L * (2*xi - 1);
dN(theta,thetae) = beta_y/L * (6*xi + (alpha_y-2));
end
function ddN = Shapefunction_ddN(BodyParameter,xi)
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
ddN = zeros(6,12);
%% Hu
ddN(u,u0) = 0;
ddN(u,ue) = 0;
%% Hv
ddN(v,v0) = beta_y/L/L * (12*xi - 6);
ddN(v,theta0) = beta_y/L * (6*xi -2*(alpha_y/2+2));
ddN(v,ve) = beta_y/L/L * (-12*xi + 6);
ddN(v,thetae) = beta_y/L * (6*xi +2*(alpha_y-2)/2);
%% Hw
ddN(w,w0) = beta_z/L/L * (12*xi - 6);
ddN(w,psi0) = beta_z/L * (-6*xi + 2*(alpha_z/2+2));
ddN(w,we) = beta_z/L/L * (-12*xi + 6);
ddN(w,psie) = -beta_z/L * (6*xi + 2*(alpha_z-2)/2);
%% Hphi
ddN(phi,phi0) = 0;
ddN(phi,phie) = 0;
%% Hpsi
ddN(psi,w0) = -6*beta_z/L/L/L * (2);
ddN(psi,psi0) = beta_z/L/L * (6);
ddN(psi,we) = 6*beta_z/L/L/L * (2);
ddN(psi,psie) = beta_z/L/L * (6);
%% Htheta
ddN(theta,v0) = 6*beta_y/L/L/L * (2);
ddN(theta,theta0) = beta_y/L/L * (6);
ddN(theta,ve) = -6*beta_y/L/L/L * (2);
ddN(theta,thetae) = beta_y/L/L * (6);
end
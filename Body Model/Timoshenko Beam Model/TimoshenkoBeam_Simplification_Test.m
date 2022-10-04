clc;clear;
syms L E G A Iy Iz;
%%
BodyParameter.L  = L;
BodyParameter.E  = E;
BodyParameter.G  = G;
BodyParameter.A  = A;
BodyParameter.Iy = Iy;
BodyParameter.Iz = Iz;
%%
syms x;
xi = x/L;
%%
N(x) = Shapefunction_N_Sym(BodyParameter,xi);
sN = int(N,x,0,L);
%%
xN(x) = x*N(x);
sxN = int(xN,x,0,L);
%%
% P = [A*sym(eye(3)),sym(zeros(3));
% 	sym(zeros(3)),diag([Iy+Iz,Iz,Iy])];
% NPN(x) = N(x)'*P*N(x);
% sNPN = int(NPN,x,0,L);
% sNPN = subs(sNPN,[E',G',A',Iy',Iz',L'],[E,G,A,Iy,Iz,L]);
% delta_sNPN = sNPN' - sNPN;
% delta_sNPN = simplify(subs(delta_sNPN, ...
% 	[E',G',A',Iy',Iz',L'],[E,G,A,Iy,Iz,L]));
%%
syms omegaBx omegaBy omegaBz;
J0 = diag([0,Iy,Iz]);
% omegaB = [omegaBx;omegaBy;omegaBz];
% W = [A*skew(omegaB),zeros(3);
% 	zeros(3),skew(J0*omegaB)];
% NWN(x) = N(x)'*W*N(x);
% sNWN = int(NWN,x,0,L);
% sNWN = subs(sNWN,[E',G',A',Iy',Iz',L'],[E,G,A,Iy,Iz,L]);
%%
syms u0 v0 w0 phi0 psi0 theta0;
syms ue ve we phie psie thetae;
dqd_end = [u0;v0;w0;phi0;psi0;theta0;...
	ue;ve;we;phie;psie;thetae];
omegac = [zeros(3),eye(3)]*N(x)*dqd_end;
% WJW = skew(omegac)*J0*omegac;
% sWJW = int(WJW,x,0,L);
% sWJW = simplify(sWJW)
%%
NWJW = N(x)'*[eye(3);zeros(3)]*skew(omegac)*J0*omegac;
sNWJW = int(NWJW,x,0,L);
sNWJW = subs(sNWJW,[E',G',A',Iy',Iz',L'],[E,G,A,Iy,Iz,L])
%%
function N = Shapefunction_N_Sym(BodyParameter,xi)
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
N = sym(zeros(6,12));
%% Hu
N(u,u0) = 1 - xi;
N(u,ue) = xi;
%% Hv
N(v,v0) = beta_y * (2*xi^3 - 3*xi^2 - alpha_y*xi + (alpha_y+1));
N(v,theta0) = L*beta_y * (xi^3 -(alpha_y/2+2)*xi^2 + (1/2*alpha_y+1)*xi);
N(v,ve) = beta_y * (-2*xi^3 + 3*xi^2 + alpha_y*xi);
N(v,thetae) = L*beta_y * (xi^3 +(alpha_y-2)/2*xi^2 - 1/2*alpha_y*xi);
%% Hw
N(w,w0) = beta_z * (2*xi^3 - 3*xi^2 - alpha_z*xi + (alpha_z+1));
N(w,psi0) = L*beta_z * (-xi^3 + (alpha_z/2+2)*xi^2 - (1/2*alpha_z+1)*xi);
N(w,we) = beta_z * (-2*xi^3 + 3*xi^2 + alpha_z*xi);
N(w,psie) = -L*beta_z * (xi^3 + (alpha_z-2)/2*xi^2 - 1/2*alpha_z*xi);
%% Hphi
N(phi,phi0) = 1 - xi;
N(phi,phie) = xi;
%% Hpsi
N(psi,w0) = -6*beta_z/L * (xi^2 - xi);
N(psi,psi0) = beta_z * (3*xi^2 - (alpha_z+4)*xi + (alpha_z+1));
N(psi,we) = 6*beta_z/L * (xi^2 - xi);
N(psi,psie) = beta_z * (3*xi^2 + (alpha_z-2)*xi);
%% Htheta
N(theta,v0) = 6*beta_y/L * (xi^2 - xi);
N(theta,theta0) = beta_y * (3*xi^2 - (alpha_y+4)*xi + (alpha_y+1));
N(theta,ve) = -6*beta_y/L * (xi^2 - xi);
N(theta,thetae) = beta_y * (3*xi^2 + (alpha_y-2)*xi);
end
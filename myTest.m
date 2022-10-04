phi = rand(3,1);
dphidt = rand(3,1);
dphids = rand(3,1);

T = get_T(phi);
omega = T*dphidt;
kappa = T*dphids;

dTdt = get_dT(phi,dphidt);
dTds = get_dT(phi,dphids);

(skew(kappa)*T+dTds)*dphidt
(skew(omega)*T+dTdt)*dphids
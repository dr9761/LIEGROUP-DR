function sNWN = Intergrated_Shapefunction_sNWN_Symbolic(...
	BodyParameter,omegaB)
%%
L = BodyParameter.L;
E = BodyParameter.E;
G = BodyParameter.G;
A = BodyParameter.A;
Iy = BodyParameter.Iy;
Iz = BodyParameter.Iz;
%%
omegaBx = omegaB(1);
omegaBy = omegaB(2);
omegaBz = omegaB(3);
%%
sNWN = casadi.SX.zeros(12,12);
%%
sNWN(1,1) = 0;
sNWN(2,1) = (7*A*L*omegaBz)/20 - (4*A*E*Iy*L*omegaBz)/(5*(A*G*L^2 + 48*E*Iy));
sNWN(3,1) = (4*A*E*Iz*L*omegaBy)/(5*(A*G*L^2 + 48*E*Iz)) - (7*A*L*omegaBy)/20;
sNWN(4,1) = 0;
sNWN(5,1) = (A*L^2*omegaBy)/20 - (2*A*E*Iz*L^2*omegaBy)/(5*(A*G*L^2 + 48*E*Iz));
sNWN(6,1) = (A*L^2*omegaBz)/20 - (2*A*E*Iy*L^2*omegaBz)/(5*(A*G*L^2 + 48*E*Iy));
sNWN(7,1) = 0;
sNWN(8,1) = (3*A*L*omegaBz)/20 + (4*A*E*Iy*L*omegaBz)/(5*(A*G*L^2 + 48*E*Iy));
sNWN(9,1) = - (3*A*L*omegaBy)/20 - (4*A*E*Iz*L*omegaBy)/(5*(A*G*L^2 + 48*E*Iz));
sNWN(10,1) = 0;
sNWN(11,1) = - (A*L^2*omegaBy)/30 - (2*A*E*Iz*L^2*omegaBy)/(5*(A*G*L^2 + 48*E*Iz));
sNWN(12,1) = - (A*L^2*omegaBz)/30 - (2*A*E*Iy*L^2*omegaBz)/(5*(A*G*L^2 + 48*E*Iy));
%
sNWN(1,2) = -(A*L*omegaBz*(7*A*G*L^2 + 320*E*Iy))/(20*(A*G*L^2 + 48*E*Iy));
sNWN(2,2) = 0;
sNWN(3,2) = (A*L*omegaBx*(13*A^2*G^2*L^4 + 26880*E^2*Iy*Iz + 588*A*E*G*Iy*L^2 + 588*A*E*G*Iz*L^2))/(35*(A*G*L^2 + 48*E*Iy)*(A*G*L^2 + 48*E*Iz));
sNWN(4,2) = -(A*G*Iy*L^2*omegaBy)/(2*A*G*L^2 + 96*E*Iy);
sNWN(5,2) = -(A*L^2*omegaBx*(11*A^2*G^2*L^4 + 20160*E^2*Iy*Iz + 504*A*E*G*Iy*L^2 + 420*A*E*G*Iz*L^2))/(210*(A*G*L^2 + 48*E*Iy)*(A*G*L^2 + 48*E*Iz));
sNWN(6,2) = 0;
sNWN(7,2) = -(A*L*omegaBz*(3*A*G*L^2 + 160*E*Iy))/(20*(A*G*L^2 + 48*E*Iy));
sNWN(8,2) = 0;
sNWN(9,2) = (3*A*L*omegaBx*(3*A^2*G^2*L^4 + 8960*E^2*Iy*Iz + 168*A*E*G*Iy*L^2 + 168*A*E*G*Iz*L^2))/(70*(A*G*L^2 + 48*E*Iy)*(A*G*L^2 + 48*E*Iz));
sNWN(10,2) = -(A*G*Iy*L^2*omegaBy)/(2*A*G*L^2 + 96*E*Iy);
sNWN(11,2) = (A*L^2*omegaBx*(13*A^2*G^2*L^4 + 40320*E^2*Iy*Iz + 672*A*E*G*Iy*L^2 + 840*A*E*G*Iz*L^2))/(420*(A*G*L^2 + 48*E*Iy)*(A*G*L^2 + 48*E*Iz));
sNWN(12,2) = 0;
%
sNWN(1,3) = (A*L*omegaBy*(7*A*G*L^2 + 320*E*Iz))/(20*(A*G*L^2 + 48*E*Iz));
sNWN(2,3) = -(A*L*omegaBx*(13*A^2*G^2*L^4 + 26880*E^2*Iy*Iz + 588*A*E*G*Iy*L^2 + 588*A*E*G*Iz*L^2))/(35*(A*G*L^2 + 48*E*Iy)*(A*G*L^2 + 48*E*Iz));
sNWN(3,3) = 0;
sNWN(4,3) = -(A*G*Iz*L^2*omegaBz)/(2*A*G*L^2 + 96*E*Iz);
sNWN(5,3) = 0;
sNWN(6,3) = -(A*L^2*omegaBx*(11*A^2*G^2*L^4 + 20160*E^2*Iy*Iz + 420*A*E*G*Iy*L^2 + 504*A*E*G*Iz*L^2))/(210*(A*G*L^2 + 48*E*Iy)*(A*G*L^2 + 48*E*Iz));
sNWN(7,3) = (A*L*omegaBy*(3*A*G*L^2 + 160*E*Iz))/(20*(A*G*L^2 + 48*E*Iz));
sNWN(8,3) = -(3*A*L*omegaBx*(3*A^2*G^2*L^4 + 8960*E^2*Iy*Iz + 168*A*E*G*Iy*L^2 + 168*A*E*G*Iz*L^2))/(70*(A*G*L^2 + 48*E*Iy)*(A*G*L^2 + 48*E*Iz));
sNWN(9,3) = 0;
sNWN(10,3) = -(A*G*Iz*L^2*omegaBz)/(2*A*G*L^2 + 96*E*Iz);
sNWN(11,3) = 0;
sNWN(12,3) = (A*L^2*omegaBx*(13*A^2*G^2*L^4 + 40320*E^2*Iy*Iz + 840*A*E*G*Iy*L^2 + 672*A*E*G*Iz*L^2))/(420*(A*G*L^2 + 48*E*Iy)*(A*G*L^2 + 48*E*Iz));
%
sNWN(1,4) = 0;
sNWN(2,4) = (A*G*Iy*L^2*omegaBy)/(2*A*G*L^2 + 96*E*Iy);
sNWN(3,4) = (A*G*Iz*L^2*omegaBz)/(2*A*G*L^2 + 96*E*Iz);
sNWN(4,4) = 0;
sNWN(5,4) = (Iz*L*omegaBz)/12 + (12*E*Iz^2*L*omegaBz)/(A*G*L^2 + 48*E*Iz);
sNWN(6,4) = - (Iy*L*omegaBy)/12 - (12*E*Iy^2*L*omegaBy)/(A*G*L^2 + 48*E*Iy);
sNWN(7,4) = 0;
sNWN(8,4) = -(A*G*Iy*L^2*omegaBy)/(2*A*G*L^2 + 96*E*Iy);
sNWN(9,4) = -(A*G*Iz*L^2*omegaBz)/(2*A*G*L^2 + 96*E*Iz);
sNWN(10,4) = 0;
sNWN(11,4) = (12*E*Iz^2*L*omegaBz)/(A*G*L^2 + 48*E*Iz) - (Iz*L*omegaBz)/12;
sNWN(12,4) = (Iy*L*omegaBy)/12 - (12*E*Iy^2*L*omegaBy)/(A*G*L^2 + 48*E*Iy);
%
sNWN(1,5) = -(A*L^2*omegaBy*(A*G*L^2 + 40*E*Iz))/(20*(A*G*L^2 + 48*E*Iz));
sNWN(2,5) = (A*L^2*omegaBx*(11*A^2*G^2*L^4 + 20160*E^2*Iy*Iz + 504*A*E*G*Iy*L^2 + 420*A*E*G*Iz*L^2))/(210*(A*G*L^2 + 48*E*Iy)*(A*G*L^2 + 48*E*Iz));
sNWN(3,5) = 0;
sNWN(4,5) = -(Iz*L*omegaBz*(A*G*L^2 + 192*E*Iz))/(12*(A*G*L^2 + 48*E*Iz));
sNWN(5,5) = 0;
sNWN(6,5) = (A*L^3*omegaBx*(A^2*G^2*L^4 + 2016*E^2*Iy*Iz + 42*A*E*G*Iy*L^2 + 42*A*E*G*Iz*L^2))/(105*(A*G*L^2 + 48*E*Iy)*(A*G*L^2 + 48*E*Iz));
sNWN(7,5) = -(A*L^2*omegaBy*(A*G*L^2 + 60*E*Iz))/(30*(A*G*L^2 + 48*E*Iz));
sNWN(8,5) = (A*L^2*omegaBx*(13*A^2*G^2*L^4 + 40320*E^2*Iy*Iz + 672*A*E*G*Iy*L^2 + 840*A*E*G*Iz*L^2))/(420*(A*G*L^2 + 48*E*Iy)*(A*G*L^2 + 48*E*Iz));
sNWN(9,5) = 0;
sNWN(10,5) = -(Iz*L*omegaBz*(- A*G*L^2 + 96*E*Iz))/(12*(A*G*L^2 + 48*E*Iz));
sNWN(11,5) = 0;
sNWN(12,5) = -(A*L^3*omegaBx*(A^2*G^2*L^4 + 2688*E^2*Iy*Iz + 56*A*E*G*Iy*L^2 + 56*A*E*G*Iz*L^2))/(140*(A*G*L^2 + 48*E*Iy)*(A*G*L^2 + 48*E*Iz));
%
sNWN(1,6) = -(A*L^2*omegaBz*(A*G*L^2 + 40*E*Iy))/(20*(A*G*L^2 + 48*E*Iy));
sNWN(2,6) = 0;
sNWN(3,6) = (A*L^2*omegaBx*(11*A^2*G^2*L^4 + 20160*E^2*Iy*Iz + 420*A*E*G*Iy*L^2 + 504*A*E*G*Iz*L^2))/(210*(A*G*L^2 + 48*E*Iy)*(A*G*L^2 + 48*E*Iz));
sNWN(4,6) = (Iy*L*omegaBy*(A*G*L^2 + 192*E*Iy))/(12*(A*G*L^2 + 48*E*Iy));
sNWN(5,6) = -(A*L^3*omegaBx*(A^2*G^2*L^4 + 2016*E^2*Iy*Iz + 42*A*E*G*Iy*L^2 + 42*A*E*G*Iz*L^2))/(105*(A*G*L^2 + 48*E*Iy)*(A*G*L^2 + 48*E*Iz));
sNWN(6,6) = 0;
sNWN(7,6) = -(A*L^2*omegaBz*(A*G*L^2 + 60*E*Iy))/(30*(A*G*L^2 + 48*E*Iy));
sNWN(8,6) = 0;
sNWN(9,6) = (A*L^2*omegaBx*(13*A^2*G^2*L^4 + 40320*E^2*Iy*Iz + 840*A*E*G*Iy*L^2 + 672*A*E*G*Iz*L^2))/(420*(A*G*L^2 + 48*E*Iy)*(A*G*L^2 + 48*E*Iz));
sNWN(10,6) = (Iy*L*omegaBy*(- A*G*L^2 + 96*E*Iy))/(12*(A*G*L^2 + 48*E*Iy));
sNWN(11,6) = (A*L^3*omegaBx*(A^2*G^2*L^4 + 2688*E^2*Iy*Iz + 56*A*E*G*Iy*L^2 + 56*A*E*G*Iz*L^2))/(140*(A*G*L^2 + 48*E*Iy)*(A*G*L^2 + 48*E*Iz));
sNWN(12,6) = 0;
%
sNWN(1,7) = 0;
sNWN(2,7) = (3*A*L*omegaBz)/20 + (4*A*E*Iy*L*omegaBz)/(5*(A*G*L^2 + 48*E*Iy));
sNWN(3,7) = - (3*A*L*omegaBy)/20 - (4*A*E*Iz*L*omegaBy)/(5*(A*G*L^2 + 48*E*Iz));
sNWN(4,7) = 0;
sNWN(5,7) = (A*L^2*omegaBy)/30 + (2*A*E*Iz*L^2*omegaBy)/(5*(A*G*L^2 + 48*E*Iz));
sNWN(6,7) = (A*L^2*omegaBz)/30 + (2*A*E*Iy*L^2*omegaBz)/(5*(A*G*L^2 + 48*E*Iy));
sNWN(7,7) = 0;
sNWN(8,7) = (7*A*L*omegaBz)/20 - (4*A*E*Iy*L*omegaBz)/(5*(A*G*L^2 + 48*E*Iy));
sNWN(9,7) = (4*A*E*Iz*L*omegaBy)/(5*(A*G*L^2 + 48*E*Iz)) - (7*A*L*omegaBy)/20;
sNWN(10,7) = 0;
sNWN(11,7) = (2*A*E*Iz*L^2*omegaBy)/(5*(A*G*L^2 + 48*E*Iz)) - (A*L^2*omegaBy)/20;
sNWN(12,7) = (2*A*E*Iy*L^2*omegaBz)/(5*(A*G*L^2 + 48*E*Iy)) - (A*L^2*omegaBz)/20;
%
sNWN(1,8) = -(A*L*omegaBz*(3*A*G*L^2 + 160*E*Iy))/(20*(A*G*L^2 + 48*E*Iy));
sNWN(2,8) = 0;
sNWN(3,8) = (3*A*L*omegaBx*(3*A^2*G^2*L^4 + 8960*E^2*Iy*Iz + 168*A*E*G*Iy*L^2 + 168*A*E*G*Iz*L^2))/(70*(A*G*L^2 + 48*E*Iy)*(A*G*L^2 + 48*E*Iz));
sNWN(4,8) = (A*G*Iy*L^2*omegaBy)/(2*A*G*L^2 + 96*E*Iy);
sNWN(5,8) = -(A*L^2*omegaBx*(13*A^2*G^2*L^4 + 40320*E^2*Iy*Iz + 672*A*E*G*Iy*L^2 + 840*A*E*G*Iz*L^2))/(420*(A*G*L^2 + 48*E*Iy)*(A*G*L^2 + 48*E*Iz));
sNWN(6,8) = 0;
sNWN(7,8) = -(A*L*omegaBz*(7*A*G*L^2 + 320*E*Iy))/(20*(A*G*L^2 + 48*E*Iy));
sNWN(8,8) = 0;
sNWN(9,8) = (A*L*omegaBx*(13*A^2*G^2*L^4 + 26880*E^2*Iy*Iz + 588*A*E*G*Iy*L^2 + 588*A*E*G*Iz*L^2))/(35*(A*G*L^2 + 48*E*Iy)*(A*G*L^2 + 48*E*Iz));
sNWN(10,8) = (A*G*Iy*L^2*omegaBy)/(2*A*G*L^2 + 96*E*Iy);
sNWN(11,8) = (A*L^2*omegaBx*(11*A^2*G^2*L^4 + 20160*E^2*Iy*Iz + 504*A*E*G*Iy*L^2 + 420*A*E*G*Iz*L^2))/(210*(A*G*L^2 + 48*E*Iy)*(A*G*L^2 + 48*E*Iz));
sNWN(12,8) = 0;
%
sNWN(1,9) = (A*L*omegaBy*(3*A*G*L^2 + 160*E*Iz))/(20*(A*G*L^2 + 48*E*Iz));
sNWN(2,9) = -(3*A*L*omegaBx*(3*A^2*G^2*L^4 + 8960*E^2*Iy*Iz + 168*A*E*G*Iy*L^2 + 168*A*E*G*Iz*L^2))/(70*(A*G*L^2 + 48*E*Iy)*(A*G*L^2 + 48*E*Iz));
sNWN(3,9) = 0;
sNWN(4,9) = (A*G*Iz*L^2*omegaBz)/(2*A*G*L^2 + 96*E*Iz);
sNWN(5,9) = 0;
sNWN(6,9) = -(A*L^2*omegaBx*(13*A^2*G^2*L^4 + 40320*E^2*Iy*Iz + 840*A*E*G*Iy*L^2 + 672*A*E*G*Iz*L^2))/(420*(A*G*L^2 + 48*E*Iy)*(A*G*L^2 + 48*E*Iz));
sNWN(7,9) = (A*L*omegaBy*(7*A*G*L^2 + 320*E*Iz))/(20*(A*G*L^2 + 48*E*Iz));
sNWN(8,9) = -(A*L*omegaBx*(13*A^2*G^2*L^4 + 26880*E^2*Iy*Iz + 588*A*E*G*Iy*L^2 + 588*A*E*G*Iz*L^2))/(35*(A*G*L^2 + 48*E*Iy)*(A*G*L^2 + 48*E*Iz));
sNWN(9,9) = 0;
sNWN(10,9) = (A*G*Iz*L^2*omegaBz)/(2*A*G*L^2 + 96*E*Iz);
sNWN(11,9) = 0;
sNWN(12,9) = (A*L^2*omegaBx*(11*A^2*G^2*L^4 + 20160*E^2*Iy*Iz + 420*A*E*G*Iy*L^2 + 504*A*E*G*Iz*L^2))/(210*(A*G*L^2 + 48*E*Iy)*(A*G*L^2 + 48*E*Iz));
%
sNWN(1,10) = 0;
sNWN(2,10) = (A*G*Iy*L^2*omegaBy)/(2*A*G*L^2 + 96*E*Iy);
sNWN(3,10) = (A*G*Iz*L^2*omegaBz)/(2*A*G*L^2 + 96*E*Iz);
sNWN(4,10) = 0;
sNWN(5,10) = (12*E*Iz^2*L*omegaBz)/(A*G*L^2 + 48*E*Iz) - (Iz*L*omegaBz)/12;
sNWN(6,10) = (Iy*L*omegaBy)/12 - (12*E*Iy^2*L*omegaBy)/(A*G*L^2 + 48*E*Iy);
sNWN(7,10) = 0;
sNWN(8,10) = -(A*G*Iy*L^2*omegaBy)/(2*A*G*L^2 + 96*E*Iy);
sNWN(9,10) = -(A*G*Iz*L^2*omegaBz)/(2*A*G*L^2 + 96*E*Iz);
sNWN(10,10) = 0;
sNWN(11,10) = (Iz*L*omegaBz)/12 + (12*E*Iz^2*L*omegaBz)/(A*G*L^2 + 48*E*Iz);
sNWN(12,10) = - (Iy*L*omegaBy)/12 - (12*E*Iy^2*L*omegaBy)/(A*G*L^2 + 48*E*Iy);
%
sNWN(1,11) = (A*L^2*omegaBy*(A*G*L^2 + 60*E*Iz))/(30*(A*G*L^2 + 48*E*Iz));
sNWN(2,11) = -(A*L^2*omegaBx*(13*A^2*G^2*L^4 + 40320*E^2*Iy*Iz + 672*A*E*G*Iy*L^2 + 840*A*E*G*Iz*L^2))/(420*(A*G*L^2 + 48*E*Iy)*(A*G*L^2 + 48*E*Iz));
sNWN(3,11) = 0;
sNWN(4,11) = -(Iz*L*omegaBz*(- A*G*L^2 + 96*E*Iz))/(12*(A*G*L^2 + 48*E*Iz));
sNWN(5,11) = 0;
sNWN(6,11) = -(A*L^3*omegaBx*(A^2*G^2*L^4 + 2688*E^2*Iy*Iz + 56*A*E*G*Iy*L^2 + 56*A*E*G*Iz*L^2))/(140*(A*G*L^2 + 48*E*Iy)*(A*G*L^2 + 48*E*Iz));
sNWN(7,11) = (A*L^2*omegaBy*(A*G*L^2 + 40*E*Iz))/(20*(A*G*L^2 + 48*E*Iz));
sNWN(8,11) = -(A*L^2*omegaBx*(11*A^2*G^2*L^4 + 20160*E^2*Iy*Iz + 504*A*E*G*Iy*L^2 + 420*A*E*G*Iz*L^2))/(210*(A*G*L^2 + 48*E*Iy)*(A*G*L^2 + 48*E*Iz));
sNWN(9,11) = 0;
sNWN(10,11) = -(Iz*L*omegaBz*(A*G*L^2 + 192*E*Iz))/(12*(A*G*L^2 + 48*E*Iz));
sNWN(11,11) = 0;
sNWN(12,11) = (A*L^3*omegaBx*(A^2*G^2*L^4 + 2016*E^2*Iy*Iz + 42*A*E*G*Iy*L^2 + 42*A*E*G*Iz*L^2))/(105*(A*G*L^2 + 48*E*Iy)*(A*G*L^2 + 48*E*Iz));
%
sNWN(1,12) = (A*L^2*omegaBz*(A*G*L^2 + 60*E*Iy))/(30*(A*G*L^2 + 48*E*Iy));
sNWN(2,12) = 0;
sNWN(3,12) = -(A*L^2*omegaBx*(13*A^2*G^2*L^4 + 40320*E^2*Iy*Iz + 840*A*E*G*Iy*L^2 + 672*A*E*G*Iz*L^2))/(420*(A*G*L^2 + 48*E*Iy)*(A*G*L^2 + 48*E*Iz));
sNWN(4,12) = (Iy*L*omegaBy*(- A*G*L^2 + 96*E*Iy))/(12*(A*G*L^2 + 48*E*Iy));
sNWN(5,12) = (A*L^3*omegaBx*(A^2*G^2*L^4 + 2688*E^2*Iy*Iz + 56*A*E*G*Iy*L^2 + 56*A*E*G*Iz*L^2))/(140*(A*G*L^2 + 48*E*Iy)*(A*G*L^2 + 48*E*Iz));
sNWN(6,12) = 0;
sNWN(7,12) = (A*L^2*omegaBz*(A*G*L^2 + 40*E*Iy))/(20*(A*G*L^2 + 48*E*Iy));
sNWN(8,12) = 0;
sNWN(9,12) = -(A*L^2*omegaBx*(11*A^2*G^2*L^4 + 20160*E^2*Iy*Iz + 420*A*E*G*Iy*L^2 + 504*A*E*G*Iz*L^2))/(210*(A*G*L^2 + 48*E*Iy)*(A*G*L^2 + 48*E*Iz));
sNWN(10,12) = (Iy*L*omegaBy*(A*G*L^2 + 192*E*Iy))/(12*(A*G*L^2 + 48*E*Iy));
sNWN(11,12) = -(A*L^3*omegaBx*(A^2*G^2*L^4 + 2016*E^2*Iy*Iz + 42*A*E*G*Iy*L^2 + 42*A*E*G*Iz*L^2))/(105*(A*G*L^2 + 48*E*Iy)*(A*G*L^2 + 48*E*Iz));
sNWN(12,12) = 0;

end
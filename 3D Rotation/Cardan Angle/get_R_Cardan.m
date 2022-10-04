function R = get_R_Cardan(Angle)
% I-x->1-y->2-z->B
phi   = Angle(1);
psi   = Angle(2);
theta = Angle(3);

R = get_R_z(theta) * get_R_y(psi) * get_R_x(phi);

end
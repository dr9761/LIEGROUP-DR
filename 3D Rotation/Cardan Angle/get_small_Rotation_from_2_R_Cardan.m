function Angle = get_small_Rotation_from_2_R_Cardan(R)
%%
psi   = -asin(R(3,1));
theta = asin(R(2,1) / cos(psi));
phi   = asin(R(3,2) / cos(psi));
%%
Angle = [phi;psi;theta];

end
function Rotation = get_Rotation_from_R_small_deofrmation(R)

skew_phi = R - eye(3);

Rotation_x = (skew_phi(3,2) - skew_phi(2,3)) / 2;
Rotation_y = (skew_phi(1,3) - skew_phi(3,1)) / 2;
Rotation_z = (skew_phi(2,1) - skew_phi(1,2)) / 2;

Rotation = [Rotation_x;Rotation_y;Rotation_z];

end
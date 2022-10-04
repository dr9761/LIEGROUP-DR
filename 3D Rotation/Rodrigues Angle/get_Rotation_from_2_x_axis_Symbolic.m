function Rotation = get_Rotation_from_2_x_axis_Symbolic(x1,x2)

RotationAxis = skew(x1)*x2 / (norm(skew(x1)*x2)+eps);
cosPhi = x1'*x2;
sinPhi = norm(skew(x1)*x2);
RotationAngle = atan2(sinPhi,cosPhi);
% RotationAngle = acos(x1'*x2);
% if (sin(RotationAngle) - norm(skew(x1)*x2)) < 1e-5
% 	RotationAngle = RotationAngle;
% elseif sin(RotationAngle) + norm(skew(x1)*x2) < 1e-5
% 	RotationAngle = -RotationAngle;
% else
% 	error('get_Rotation_from_2_x_axis_Symbolic\n');
% end

Rotation = RotationAxis * RotationAngle;

end
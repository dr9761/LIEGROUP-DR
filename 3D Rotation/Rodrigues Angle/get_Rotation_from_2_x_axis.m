function Rotation = get_Rotation_from_2_x_axis(x1,x2)

% if x1(1) == x2(1) && x1(2) == x2(2) && x1(3) == x2(3)
if x1 == x2
	Rotation = zeros(3,1);
else
	RotationAxis = skew(x1)*x2 / norm(skew(x1)*x2);
	RotationAngle = acos(x1'*x2);
	if (sin(RotationAngle) - norm(skew(x1)*x2)) < 1e-5
		RotationAngle = RotationAngle;
	elseif sin(RotationAngle) + norm(skew(x1)*x2) < 1e-5
		RotationAngle = -RotationAngle;
	else
		pause();
	end
	
	Rotation = RotationAxis * RotationAngle;
end

end
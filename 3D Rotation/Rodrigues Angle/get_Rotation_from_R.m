function Rotation = get_Rotation_from_R(R,phi_ref)
%%
R = R/det(R);
R(:,1) = R(:,1)/norm(R(:,1));
R(:,2) = R(:,2)/norm(R(:,2));
R(:,3) = R(:,3)/norm(R(:,3));
%%
deltaR = [	R(3,2) - R(2,3);
			R(1,3) - R(3,1);
			R(2,1) - R(1,2)];
if norm(deltaR) <= 1e-5
	% RotationAngle = 0 or pi
	if max(max(abs(R-eye(3)))) <= 1e-5
		Rotation = zeros(3,1);
		return
	else% RotationAngle = pi
		RotationAxis_x = sqrt((R(1,1)+1)/2);
		if abs(RotationAxis_x) > 1e-5
			RotationAxis_y = R(1,2)/(2*RotationAxis_x);
			RotationAxis_z = R(1,3)/(2*RotationAxis_x);
		else%if RotationAxis_x == 0
			RotationAxis_y = sqrt((R(2,2)+1)/2);
			if abs(RotationAxis_y) > 1e-5
				RotationAxis_z = R(2,3)/(2*RotationAxis_y);
			else%if RotationAxis_y == 0
				RotationAxis_z = sqrt((R(3,3)+1)/2);
			end
		end

		RotationAxis = [RotationAxis_x;RotationAxis_y;RotationAxis_z];
		RotationAxis = RotationAxis/norm(RotationAxis);
		
		RotationAngle = pi;
	end
else
	RotationAxis = deltaR / norm(deltaR);
	Temp_RotationAxis = RotationAxis;
	Temp_RotationAxis(abs(Temp_RotationAxis)<1e-4) = 0;
	SinRotationAngle = 1/2 * mean(rmmissing( ...
		deltaR(Temp_RotationAxis~=0) ./ Temp_RotationAxis(Temp_RotationAxis~=0)));
	if SinRotationAngle > 1
		SinRotationAngle = 1;
	elseif SinRotationAngle < -1
		SinRotationAngle = -1;
	end
	RotationAngle = asin(SinRotationAngle);
end
%%
R11 = cos(RotationAngle)+ ...
	(1-cos(RotationAngle))*(RotationAxis(1)^2);
R11_2 = cos(pi - RotationAngle)+ ...
	(1-cos(pi - RotationAngle))*(RotationAxis(1)^2);
if abs(R11 - R(1,1)) > abs(R11_2 - R(1,1))
	RotationAngle = pi - RotationAngle;
end
%%
phi_ref = zeros(3,1);
while (RotationAngle - norm(phi_ref)) > 2*pi
	RotationAngle = RotationAngle - 2*pi;
end
while (norm(phi_ref) - RotationAngle) > 2*pi
	RotationAngle = RotationAngle + 2*pi;
end
Rotation = RotationAngle * RotationAxis;
if ~isreal(Rotation) || ...
		sum(ismissing(Rotation)) > 0
	warning('Rotation wrong!2');
end
if max(max(abs(get_R(Rotation)-R))) > 5e-2
	warning('Rotation wrong!');
end
end
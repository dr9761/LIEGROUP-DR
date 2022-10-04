function R = get_R(phi)

theta = norm(phi);
if theta == 0
	R = eye(3);
else
% 	R = eye(3)*cos(theta) + ...
% 		sin(theta)/theta*skew(phi) + ...
% 		(1-cos(theta))/(theta^2)*phi*phi';
	R = eye(3) + ...
		sin(theta) / theta * skew(phi) + ...
		(1 - cos(theta)) / (theta ^ 2) * skew(phi) * skew(phi);
end
% R = eye(3) + ...
% 	sin(theta) / (theta+eps) * skew(phi) + ...
% 	(1 - cos(theta)) / ((theta+eps) ^ 2) * skew(phi) * skew(phi);
end
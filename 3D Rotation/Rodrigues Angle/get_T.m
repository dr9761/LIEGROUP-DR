function T = get_T(phi)

theta = norm(phi);
if theta == 0
	T = eye(3);
else
	T = eye(3) + ...
		(cos(theta)-1)/(theta^2)*skew(phi) + ...
		(1-sin(theta)/theta)/(theta^2)*skew(phi)*skew(phi);
end

end
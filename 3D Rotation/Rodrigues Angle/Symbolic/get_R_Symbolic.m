function R = get_R_Symbolic(phi)

theta = norm(phi);
R = eye(3) + ...
	sin(theta) / (theta+eps) * skew(phi) + ...
	(1 - cos(theta)) / ((theta+eps) ^ 2) * skew(phi) * skew(phi);

end
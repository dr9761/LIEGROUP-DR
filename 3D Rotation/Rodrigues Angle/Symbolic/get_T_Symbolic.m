function T = get_T_Symbolic(phi)

theta = norm(phi);
T = eye(3) + ...
	(cos(theta)-1)/((theta+eps)^2)*skew(phi) + ...
	(1-sin(theta)/(theta+eps))/((theta+eps)^2)*skew(phi)*skew(phi);

end
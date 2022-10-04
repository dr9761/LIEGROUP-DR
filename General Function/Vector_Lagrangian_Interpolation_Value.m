function y = Vector_Lagrangian_Interpolation_Value(p,x)

[VectorDimension,~] = size(p);
y = zeros(VectorDimension,1);
for k = 1:VectorDimension
	pi = p(k,:);
	yi = polyval(pi,x);
	y(k,:) = yi;
end

end
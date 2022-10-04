function p = Vector_Lagrangian_Interpolation_Function(x,y)

[VectorDimension,NodeQuantity] = size(y);
p = zeros(VectorDimension,NodeQuantity);
for k = 1:VectorDimension
	pi = polyfit(x,y(k,:),NodeQuantity-1);
	p(k,:) = pi;
end

end
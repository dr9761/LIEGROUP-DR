function N = Lagrangian_Vector_ShapeFunction_N(...
	x_set,VectorDimension,x)
NodeQuantity = numel(x_set);
% [VectorDimension,NodeQuantity] = size(y_set);
N = zeros(VectorDimension,VectorDimension*NodeQuantity);
for DimensionNr = 1:VectorDimension
% 	yi = y_set(DimensionNr,:);
	for NodeNr = 1:NodeQuantity
		xi = x_set(NodeNr);
		Phie = 1;
		for k = 1:NodeQuantity
			if k ~= NodeNr
				Phie = Phie * (x-x_set(k)) / (xi - x_set(k));
			end
		end
		N(DimensionNr,VectorDimension*(NodeNr-1)+DimensionNr) = ...
			Phie;
	end
end


end
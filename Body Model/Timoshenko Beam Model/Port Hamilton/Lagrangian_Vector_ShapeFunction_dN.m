function dN = Lagrangian_Vector_ShapeFunction_dN(...
	x_set,VectorDimension,x)
NodeQuantity = numel(x_set);
% [VectorDimension,NodeQuantity] = size(y_set);
dN = zeros(VectorDimension,VectorDimension*NodeQuantity);
for DimensionNr = 1:VectorDimension
	% 	yi = y_set(DimensionNr,:);
	for i = 1:NodeQuantity
		Denominator = 1;
		SumPhi = 0;
		for k = 1:NodeQuantity
			if k ~= i
				MulPhi = 1;
				for j = 1:NodeQuantity
					if j ~= i && j ~= k
						MulPhi = MulPhi*(x-x_set(j));
					end
				end
				SumPhi = SumPhi + MulPhi;
				Denominator = Denominator * (x_set(i) - x_set(k));
			end
		end
		dPhie = SumPhi / Denominator;
		dN(DimensionNr,VectorDimension*(i-1)+DimensionNr) = ...
			dPhie;
	end
end


end
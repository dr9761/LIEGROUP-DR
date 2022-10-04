function dp = Derivative_Lagrangian_Interpolation_Function(p)
Order_plus_1 = size(p,2);
dp = zeros(size(p,1),Order_plus_1);
for k = 1:Order_plus_1-1
	dp(:,k+1) = p(:,k)*(Order_plus_1-k);
end

end
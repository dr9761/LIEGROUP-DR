function L = Obstacle_cost_3DNormStyle(r,CostParameters)
ObstacleQuantity = numel(CostParameters.Obstacle);
L = 0;
for ObstacleNr = 1:ObstacleQuantity
	Obstacle = CostParameters.Obstacle{ObstacleNr};
	%
	cost_range = Obstacle.cost_range;
	confidence = Obstacle.confidence;
	safety_distance = Obstacle.safety_distance;
	p = Obstacle.p;
	phi = Obstacle.phi;
	size = Obstacle.size;
	xb = Obstacle.xb;
	%
	radius = 1;
	radius_range = [radius,radius+safety_distance];
	R = get_R(phi);
	
	distance = diag(1./(size/2))*R'*(r-xb);
	distance = (sum(distance.^p))^(1/p);
	
	L = max([L,tanh_Substitute(distance,radius_range,cost_range,confidence)]);
end

end
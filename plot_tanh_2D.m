function plot_tanh_2D(p0,x_range,y_range,r_range,value_range,confidence)
% plot_tanh_2D([-25;10],[-50;-5],[0;30],[5,6],[0,100000],0.999)
x_set = linspace(x_range(1),x_range(2));
y_set = linspace(y_range(1),y_range(2));
[x_grid,y_grid] = meshgrid(x_set,y_set);
value = nan(size(x_grid));
p0 = reshape(p0,2,1);
for  PointNr = 1:numel(x_grid)
	x = x_grid(PointNr);
	y = y_grid(PointNr);
	p = [x;y];
	distance = norm(p-p0);
	value(PointNr) = tanh_Substitute(distance,r_range,value_range,confidence);
end
surf(x_grid,y_grid,value);
end
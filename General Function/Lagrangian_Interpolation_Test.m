% Lagrangian_Interpolation_Test
clear;close all;
NodeQuantity = 10;
L = 10;
x_set = linspace(0,L,NodeQuantity);
y_set = rand(1,10) ./ (rand(1,10)+eps);
Lagrangian_Interpolation_Test_Figure = ...
	figure('Name','Lagrangian_Interpolation_Test');
Lagrangian_Interpolation_N = subplot(3,1,1, ...
	'Parent',Lagrangian_Interpolation_Test_Figure);
Lagrangian_Interpolation_dN = subplot(3,1,2, ...
	'Parent',Lagrangian_Interpolation_Test_Figure);
hold(Lagrangian_Interpolation_N,'off');
hold(Lagrangian_Interpolation_dN,'off');
plot(Lagrangian_Interpolation_N,x_set,y_set,'ro');

hold(Lagrangian_Interpolation_N,'on');
hold(Lagrangian_Interpolation_dN,'on');
xx_set = linspace(0,L,10*NodeQuantity);
yy_set = zeros(1,10*NodeQuantity);
for k = 1:(10*NodeQuantity)
	x = xx_set(k);
	yy_set(k) = Lagrangian_Vector_ShapeFunction_N(...
		x_set,1,x) * reshape(y_set,numel(y_set),1);
	dyy_set(k) = Lagrangian_Vector_ShapeFunction_dN(...
		x_set,1,x) * reshape(y_set,numel(y_set),1);
end
plot(Lagrangian_Interpolation_N,xx_set,yy_set,'b-');
plot(Lagrangian_Interpolation_dN,xx_set,dyy_set,'b-');

p = polyfit(x_set,y_set,numel(x_set)-1);
dp = Derivative_Lagrangian_Interpolation_Function(p);
yyy_set = polyval(p,xx_set);
dyyy_set = polyval(dp,xx_set);
plot(Lagrangian_Interpolation_N,xx_set,yyy_set,'c--');
plot(Lagrangian_Interpolation_dN,xx_set,dyyy_set,'c--');
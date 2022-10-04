function L = stage_cost_simple2DObstacleAvoidance(x,u,Q,R,xe)
% Q = diag([10,10,10,10]);
% R = diag([1,1]);
% xe = [-35;10; 0; 0;] ;
%     endstate = [0;0; 0; 0; 0;  0] ;
L = (x-xe)'*Q*(x-xe) + u'*R*u;%1e-11*

%%
% cost_range = 2*[500000,0];
% confidence = 0.9;
% radius_range = [5,8];
% %
% xb = [-25-0.0;10];distance1 = norm(x(1:2)-xb);
% %
% xb = [-20+0.0;10];distance2 = norm(x(1:2)-xb);
% %
% xb = [-25-0.1;7.5];distance3 = norm(x(1:2)-xb);
% %
% xb = [-20+0.1;7.5];distance4 = norm(x(1:2)-xb);
% %
% xb = [-25-0.2;5];distance5 = norm(x(1:2)-xb);
% %
% xb = [-20+0.2;5];distance6 = norm(x(1:2)-xb);
% %
% xb = [-25-0.3;2.5];distance7 = norm(x(1:2)-xb);
% %
% xb = [-20+0.3;2.5];distance8 = norm(x(1:2)-xb);
% %
% xb = [-25-0.4;0];distance9 = norm(x(1:2)-xb);
% %
% xb = [-20+0.4;0];distance10 = norm(x(1:2)-xb);
% % %
% L = L + max([ ...
% 	tanh_Substitute(distance1,radius_range,cost_range,confidence), ...
% 	tanh_Substitute(distance2,radius_range,cost_range,confidence), ...
% 	tanh_Substitute(distance3,radius_range,cost_range,confidence), ...
% 	tanh_Substitute(distance4,radius_range,cost_range,confidence), ...
% 	tanh_Substitute(distance5,radius_range,cost_range,confidence), ...
% 	tanh_Substitute(distance6,radius_range,cost_range,confidence), ...
% 	tanh_Substitute(distance7,radius_range,cost_range,confidence), ...
% 	tanh_Substitute(distance8,radius_range,cost_range,confidence), ...
% 	tanh_Substitute(distance9,radius_range,cost_range,confidence), ...
% 	tanh_Substitute(distance10,radius_range,cost_range,confidence)]);

cost_range = 2*[500000,0];
confidence = 0.9;
radius = 10;
safety_distance = 2;
radius_range = [radius,radius+safety_distance];
p = 8;
phi = [0;0;0];
R = get_R(phi);
r1 = 7.5;r2 = 10;r3 = 10;
xb = [-22.5;5;0];
distance1 = diag([radius/r1,radius/r2,radius/r3])*R'*([x(1);x(2);0]-xb);

distance1 = (sum(distance1.^p))^(1/p);
L = L + max([ ...
	tanh_Substitute(distance1,radius_range,cost_range,confidence)]);
end
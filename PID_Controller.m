function u = PID_Controller(x_set,DesignedTrajectoryFunc,t,Ts, ...
	ProblemName,ControllerType)
%% get output of the system y,dyy,ddy
k = round(t / Ts + 1);
y_set = x_set(4:5,1:k);
dy_set = x_set(9:10,1:k);
if k == 1
	ddy_set = zeros(2,1);
else
	ddy_set = [zeros(2,1),1/Ts*diff(dy_set')'];
end
y_c = y_set(:,k);
dy_c = dy_set(:,k);
ddy_c = ddy_set(:,k);
%%
[y_do1,	dy_do1,	ddy_do1] = DesignedTrajectoryFunc(t-Ts);% dc: designed, old, -1
[y_dc,	dy_dc,	ddy_dc]	 = DesignedTrajectoryFunc(t);% dc: designed, current
[y_dn1,	dy_dn1,	ddy_dn1] = DesignedTrajectoryFunc(t+Ts);% dn: designed, next, +1
%%
diff_y_c = y_dc - y_c;
diff_dy_c = dy_dc - dy_c;
diff_ddy_c = ddy_dc - ddy_c;
% diff_c =
%%
Ki = 100*diag([1,-1]);% coordinate
Kp = 300*diag([1,-1]);% velocity
Kd = 2*diag([1,-1]);% acceleration
u = Ki*diff_y_c + Kp*diff_dy_c + Kd*diff_ddy_c;
u = [u;0];
end
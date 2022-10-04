function [t_set,x_set] = Runge_Kutta_4_PID(...
	myFunc,tspan,x0,opt)
%%
Ts = opt.MaxStep;
Tstart = tspan(1);
Tend = tspan(2);
%%
t_set = Tstart:Ts:Tend;
x_set = [x0,zeros(numel(x0),numel(t_set)-1)];
for k = 1:numel(t_set)-1
	%
	t = t_set(k);
	x = x_set(:,k);
	%
	q = x(1:numel(x)/2);
	dq = x(numel(x)/2+1:end);
	if k == 1
		ddq = zeros(size(dq));
	else
		ddq = (dq-x_set(numel(x)/2+1:end,k-1)) / Ts;
	end
	
	
	DesignedTrajectoryFunc = @(t)DesignedTrajectoryFunc_PendulumWithMovingJoint(t);
	u = PID_Controller(x_set,DesignedTrajectoryFunc,t,Ts, ...
		'Pendulum with Moving Joint','normal');
	%
	k_1 = myFunc(t,x,u);
	k_2 = myFunc(t+0.5*Ts,x+0.5*Ts*k_1,u);
	k_3 = myFunc(t+0.5*Ts,x+0.5*Ts*k_2,u);
	k_4 = myFunc(t+Ts,x+k_3*Ts,u);
	%
	x = x + (1/6)*(k_1+2*k_2+2*k_3+k_4)*Ts;
	x_set(:,k+1) = x;
end
%%
t_set = t_set';
x_set = x_set';
end
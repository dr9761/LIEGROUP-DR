function [t_set,x_set] = Runge_Kutta_4(...
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
	k_1 = myFunc(t,x);
	k_2 = myFunc(t+0.5*Ts,x+0.5*Ts*k_1);
	k_3 = myFunc(t+0.5*Ts,x+0.5*Ts*k_2);
	k_4 = myFunc(t+Ts,x+k_3*Ts);
	%
	x_set(:,k+1) = x + (1/6)*(k_1+2*k_2+2*k_3+k_4)*Ts;
end
%%
t_set = t_set';
x_set = x_set';
end
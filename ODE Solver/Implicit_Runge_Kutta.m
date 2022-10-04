function [t_set,x_set] = Implicit_Runge_Kutta(...
	myFunc,tspan,x0,opt)
%%
Ts = opt.MaxStep;
Tstart = tspan(1);
Tend = tspan(2);
%%
[A,b,c,r] = Load_Implicit_RungeKutta_Parameter('Lobatto',3);
% [A,b,c,r] = Load_Implicit_RungeKutta_Parameter('Radau',3);
% [A,b,c,r] = Load_Implicit_RungeKutta_Parameter('Gauss',3);
%%
t_set = Tstart:Ts:Tend;
x_set = [x0,zeros(numel(x0),numel(t_set)-1)];
for k = 1:numel(t_set)-1
	%
	t = t_set(k);
	x = x_set(:,k);
	%
	opt = optimoptions('fsolve', ...
		'Algorithm','trust-region', ...
		'StepTolerance',1e-12, ...
		'FunctionTolerance',1e-12, ...
		'SpecifyObjectiveGradient',false, ...
		'Display','iter', ...
		'MaxIterations',40000, ...
		'MaxFunctionEvaluations',2000000, ...
		'PlotFcn',[]);
	k_set_0 = repmat(myFunc(t,x),[r,1]);
	Implicit_RungeKutta_k_FunctionHandle = @(k_set)Implicit_RungeKutta_k_Function(...
		k_set,t,x,myFunc,A,c,r,Ts);
	[k_set,~,k_Flag,~,~] = ...
		fsolve(Implicit_RungeKutta_k_FunctionHandle,k_set_0,opt);
	b_set = nan(numel(x),numel(x)*r);
	for p = 1:r
		b_set(:,(p-1)*numel(x) + [1:numel(x)]) = b(p)*eye(numel(x));
	end
	%
	x_set(:,k+1) = x + b_set*k_set*Ts;
end
%%
t_set = t_set';
x_set = x_set';
end

function FunctionResidual = Implicit_RungeKutta_k_Function(k_set,t,x,myFunc,A,c,r,Ts)

FunctionResidual = k_set;
k_dimension = numel(k_set)/r;
for p = 1:r
	ai = nan(k_dimension,numel(k_set));
	for q = 1:r
		ai(:,k_dimension*(q-1) + [1:k_dimension]) = A(p,q)*eye(k_dimension);
	end
	ti = t + c(p) * Ts;
	xi = x + Ts * ai * k_set;
	fi = myFunc(ti,xi);
	FunctionResidual(k_dimension*(p-1) + [1:k_dimension]) = ...
		FunctionResidual(k_dimension*(p-1) + [1:k_dimension]) - fi;
end

end
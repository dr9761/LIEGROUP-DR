function [t_set,x_set] = Implicit_Runge_Kutta_4(...
	ModelParameter,tspan,x0,opt,SolverParameter,ComputingFigure)
%%
[A,b,c,r] = Load_Implicit_RungeKutta_Parameter('Lobatto',3);
% [A,b,c,r] = Load_Implicit_RungeKutta_Parameter('Radau',3);
% [A,b,c,r] = Load_Implicit_RungeKutta_Parameter('Gauss',3);
%% Gauss 3
% r = 3;
% b = [5,8,5] / 18;
% A = [ ...
% 	50,				80-24*sqrt(15),	50-12*sqrt(15);
% 	50+15*sqrt(15),	80,				50-15*sqrt(6);
% 	50-12*sqrt(15),	80+24*sqrt(15),	50] ...
% 	/ 360;
% c = [5-sqrt(15),5,5+sqrt(15)] / 10;
%%
n = numel(x0);
%
Ts = opt.MaxStep;
Tstart = tspan(1);
Tend = tspan(2);
%
t_set = Tstart:Ts:Tend;
x_set = [x0,zeros(numel(x0),numel(t_set)-1)];
%%
for k = 1:numel(t_set)-1
	t = t_set(k);
	x = x_set(:,k);
	%%
	u = [];
	[f,StateJacobian_t,StateJacobian_x,StateJacobian_u] ...
		= get_State_JacobianMatrix_Multi_Body_Dynamic(...
		t,x,u,ModelParameter.State_JacobianFunc);
	dfdt = StateJacobian_t;
	dfdx = StateJacobian_x;
% 	f = myFunc(t,x);
	%%
	P = zeros(r*n);
	Q = zeros(n,r*n);
	F = zeros(r*n,1);
	for p = 1:r
		xPos = n*(p-1)+(1:n);
		Q(:,xPos) = b(p)*eye(n);
		F(xPos) = f + c(p)*dfdt;
		for q = 1:r
			yPos = n*(q-1)+(1:n);
			P(xPos,yPos) = A(p,q)*dfdx;
		end
	end
	%%
	k_set = (eye(r*n) - Ts*P) \ F;
	x_set(:,k+1) = x + Q*k_set*Ts;
	%%
	if SolverParameter.ComputingDisplay.DisplayTime
		fprintf('t = %6.4f\n',t);
	end
	if SolverParameter.ComputingDisplay.PlotMechanisum
		plot_Mechanism(x_set(1:size(x_set)/2,k+1), ...
			ModelParameter,SolverParameter,ComputingFigure);
		title(ComputingFigure,['t = ',num2str(t)]);
		drawnow;
	end
	
end
%%
t_set = t_set';
x_set = x_set';
end

function FunctionResidual = Runge_Kutta_FunctionHandle(k_set,x,u,f,A,r)
FunctionResidual = k_set;
k_dimension = numel(k_set)/r;
for p = 1:r
	ai = nan(k_dimension,numel(k_set));
	for q = 1:r
		ai(:,k_dimension*(q-1) + [1:k_dimension]) = A(p,q)*eye(k_dimension);
	end
ti = t + c(p) * Ts;
xi = x + Ts * ai * k_set;
ui = u;
fi = f(ti,)
FunctionResidual(k_dimension*(p-1) + [1:k_dimension]) = ...
	f(,)




end
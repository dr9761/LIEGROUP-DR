function status = Judgment_CargoLeavingGround(t,y,flag, ...
	ModelParameter,SolverParameter)
%%
status = 0;         % Assume stop button wasn't pushed.
%% support odeplot(t,y) [v5 syntax]
if nargin < 3 || isempty(flag)
	flag = '';
elseif isstring(flag) && isscalar(flag)
	flag = char(flag);
end
%%
persistent tspan_in_func;
%%
switch(flag)
	
	case ''    % odeplot(t,y,'')
		[~,~,lambda] = ...
			Multi_Body_Dynamics_2nd_Order_func(t,y,tspan_in_func, ...
			ModelParameter,SolverParameter,[]);
		if lambda(36) > 0
			status = 1;
		end
	case 'init'    % odeplot(tspan,y0,'init')
		tspan_in_func = t;
	case 'done'    % odeplot([],[],'done')
		
	otherwise
		error(message('MATLAB:odeplot:UnrecognizedFlag', flag));
end  % switch flag

end  % odeplot
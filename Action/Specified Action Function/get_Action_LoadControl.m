function [Action,ActionTagSet] = get_Action_LoadControl(...
	t,x,tspan,ModelParameter)

% Action = [0;0;0];
% Action = [1e1;-2.7e1;-1.5e1];
% Action = [1e6;-2.7e6;-1.5e6];
Action = [2e5;-2.7e6;-1.5e6];
ActionTagSet = {'Act1';'Act2';'Act3'};

end
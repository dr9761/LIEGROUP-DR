function [Action,ActionTagSet] = get_Action_FoldingBoom_Instantaneous(...
	t,x,tspan,ModelParameter,u)

Action = u;
ActionTagSet = {'UnderAct';'AboveAct';'Torsion'};

end
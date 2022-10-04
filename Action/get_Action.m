function [Action,ActionTagSet] = get_Action(...
	t,x,tspan,ModelParameter,ActionFunctionHandle)
Drive_Action_Map = ...
	ModelParameter.DriveParameter.NodalForceDriveParameter.Drive_Action_Map;
RequiredActionQuantity = Drive_Action_Map.length;
Action = zeros(RequiredActionQuantity,1);
ActionTagSet = cell(0);
%%
if ~isempty(ActionFunctionHandle)
	[Action,ActionTagSet] = ActionFunctionHandle(...
		t,x,tspan,ModelParameter);
end
%%
if numel(Action) > RequiredActionQuantity
	warning('Too Many Actions!');
	Action = Action(1:RequiredActionQuantity);
elseif numel(Action) < RequiredActionQuantity
	warning('Too Less Actions!');
	Action = [Action;zeros(RequiredActionQuantity-numel(Action),1)];
end
if numel(ActionTagSet) ~= RequiredActionQuantity
	warning('Action Tag wrong!');
	ActionTagSet = Drive_Action_Map.keys;
end
end
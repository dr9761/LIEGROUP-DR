function InitialState = Load_Existing_InitialState(...
	exist_InitialState,InitialStateFileName,ModelParameter)
%%
InitialState = ModelParameter.InitialState;
%%
if exist_InitialState
	x0 = load(InitialStateFileName,'x_set');
	x0 = x0.x_set(end,:);
	x0 = x0';
	q0 = x0(1:numel(x0)/2);
	dq0 = x0(numel(x0)/2+1:end);
	InitialState.x0 = x0;
	InitialState.q0 = q0;
	InitialState.dq0 = dq0;
end

end
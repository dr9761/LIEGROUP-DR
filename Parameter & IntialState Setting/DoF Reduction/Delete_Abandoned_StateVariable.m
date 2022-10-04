function [q0,dq0] = Delete_Abandoned_StateVariable(...
	q0,dq0,TotalCoordinateQuantity, ...
	Abandon_StateVariableNrSet)
%%
for StateVariableNr = 1:TotalCoordinateQuantity
	AbandonStateVariableTest = ...
		find(Abandon_StateVariableNrSet(2,:) == StateVariableNr);
	if numel(AbandonStateVariableTest) ~= 0
		q0(StateVariableNr) = NaN;
		dq0(StateVariableNr) = NaN;
	end
end
%%
q0 = rmmissing(q0);
dq0 = rmmissing(dq0);

end
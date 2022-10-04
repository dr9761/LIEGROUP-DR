function [Action,ActionTagSet] = get_Action_CantileverBeamStaticBending(...
	t,x,tspan,ModelParameter)
%%
BodyElementParameter = ModelParameter.BodyElementParameter;
FinalBodyNr = numel(BodyElementParameter);
E = BodyElementParameter{FinalBodyNr}.E;
Iy = BodyElementParameter{FinalBodyNr}.Iy;
L = 15;
M_max = -E*Iy*1/(L/(2*pi));
if t < 100
	Action = M_max * t / 100;
else
	Action = M_max;
end
ActionTagSet{1} = 'Act1';

end
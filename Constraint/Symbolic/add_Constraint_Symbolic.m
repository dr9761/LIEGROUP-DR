function [Phi,B,dPhi,Tau] = add_Constraint_Symbolic(q,dq,Frame,Body, ...
	BodyElementParameter,ConstraintParameter)
%%
ConstraintQuantity = numel(ConstraintParameter);
BodyQuantity = numel(Body);
%%
Phie = cell(ConstraintQuantity,1);
Be = cell(ConstraintQuantity,1);
dPhie = cell(ConstraintQuantity,1);
Taue = cell(ConstraintQuantity,1);

for ConstraintNr = 1:ConstraintQuantity
	%%
	BodyNr1 = ConstraintParameter{ConstraintNr}.BodyNr1;
	JointNr1 = ConstraintParameter{ConstraintNr}.JointNr1;
	%
	BodyNr2 = ConstraintParameter{ConstraintNr}.BodyNr2;
	JointNr2 = ConstraintParameter{ConstraintNr}.JointNr2;
	%
	if BodyNr1 <= BodyQuantity && BodyNr2 <= BodyQuantity
		ConstraintType = ...
			ConstraintParameter{ConstraintNr}.ConstraintType;
		%%
		if BodyNr1 == 0
			Body1 = Frame;
		else
			Body1 = Body{BodyNr1};
		end
		if BodyNr2 == 0
			Body2 = Frame;
		else
			Body2 = Body{BodyNr2};
		end
		%%
		if BodyNr1 == 0
			SpecialParameter.WinchRadius = 0;
		else
			SpecialParameter.WinchRadius = ...
				BodyElementParameter{BodyNr1}.ra;
		end
		%%
		[Phie{ConstraintNr},Be{ConstraintNr},dPhie{ConstraintNr},Taue{ConstraintNr}] = ...
			set_Constraint_Symbolic(q,dq,Body1,JointNr1,Body2,JointNr2, ...
			SpecialParameter,ConstraintType);
	end
end

Phi = [];B = [];dPhi = [];Tau = [];
for i = 1:numel(Phie)
	Phi = [Phi;Phie{i}];
	B = [B,Be{i}];
	dPhi = [dPhi;dPhie{i}];
	Tau = [Tau;Taue{i}];
end

end
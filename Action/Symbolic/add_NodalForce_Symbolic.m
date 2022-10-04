function Total_NodalForce = add_NodalForce_Symbolic(...
	q,dq,t,Body,NodalForceParameter)
%%
Total_NodalForce = casadi.SX.zeros(numel(q),1);
%%
NodalForceQuantity = numel(NodalForceParameter);
for NodalForceNr = 1:NodalForceQuantity
	BodyNr = NodalForceParameter{NodalForceNr}.BodyNr;
	JointNr = NodalForceParameter{NodalForceNr}.JointNr;
	R = get_R_Symbolic(Body{BodyNr}.Joint{JointNr}.phi);
	%%
	NodalForce = ...
		NodalForceParameter{NodalForceNr}.NodalForce;
	NodalForceCoordinate = ...
		NodalForceParameter{NodalForceNr}.NodalForceCoordinate;
	if strcmpi(NodalForceCoordinate,'Body')
		NodalForce = R * NodalForce;
	end
	%%
	NodalMoment = ...
		NodalForceParameter{NodalForceNr}.NodalMoment;
	NodalMomentCoordinate = ...
		NodalForceParameter{NodalForceNr}.NodalMomentCoordinate;
	if strcmpi(NodalMomentCoordinate,'Inertial')
		NodalMoment = R' * NodalMoment;
	end 
	%%
	GeneralizedNodalForce = [NodalForce;NodalMoment];
	%%
	TJB = Body{BodyNr}.Joint{JointNr}.T_qi_q;
	TB = Body{BodyNr}.T_qe_q;
	TJ = TJB*TB;
	%%
	NodalForce = TJ'*GeneralizedNodalForce;
	Total_NodalForce = Total_NodalForce + NodalForce;
end
Total_NodalForce = -Total_NodalForce;
end
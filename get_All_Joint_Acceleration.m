function All_Joint_Acceleration = get_All_Joint_Acceleration(q,dq,ddq, ...
	BodyElementParameter,Joint_Parameter)
%%
BodyQuantity = numel(BodyElementParameter);
for BodyNr = 1:BodyQuantity
	BodyJointQuantity = numel(Joint_Parameter{BodyNr}.Joint);
	for JointNr = 1:BodyJointQuantity
		%
		BodyCoordinate = BodyElementParameter{BodyNr}.Coordinate;
		qe  = q(BodyCoordinate);
		dqe = dq(BodyCoordinate);
		ddqe = ddq(BodyCoordinate);
		r_B_0k = Joint_Parameter{BodyNr}.Joint{JointNr}.r;
		%
		ddrdtdt = get_Joint_Acceleration_RigidBody(qe,dqe,ddqe, ...
			r_B_0k);
		%
		All_Joint_Acceleration{BodyNr,JointNr} = ddrdtdt;
	end
end
end
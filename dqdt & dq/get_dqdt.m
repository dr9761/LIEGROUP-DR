function dq_dt = get_dqdt(q,dq,BodyElementParameter)
BodyQuantity = numel(BodyElementParameter);
dq_dt = zeros(numel(dq),1);
for BodyNr = 1:BodyQuantity
	m = BodyElementParameter{BodyNr}.GlobalCoordinate;
	qe = q(m);
	dqe = dq(m);
	switch BodyElementParameter{BodyNr}.BodyType
		case 'Rigid Body'
			dqedt = get_dqedt_RigidBody(qe,dqe);
		case 'Timoshenko Beam'
			dqedt = get_dqedt_FlexibleBeam(qe,dqe);
		case 'Super Truss Element'
			dqedt = get_dqedt_FlexibleBeam(qe,dqe);
		case 'Strut Tie Model'
			dqedt = get_dqedt_StrutTieModel(qe,dqe);
		case 'Strut Tie Rope Model'
			dqedt = get_dqedt_StrutTieModel(qe,dqe);
		case 'Cubic Spline Beam'
			dqedt = get_dqedt_CubicSplineBeam(qe,dqe);
		case 'Cubic Spline Rope'
			dqedt = get_dqedt_CubicSplineBeam(qe,dqe);
	end
	dq_dt(m) = dqedt;
end

end
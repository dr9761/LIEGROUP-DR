function Joint = set_Joint_Symbolic(qe,dqe, ...
	BodyElementParameter,BodyNr,Joint_Parameter)
% Body = BodyElementParameter{BodyNr};
BodyType = Joint_Parameter{BodyNr}.BodyType;
switch BodyType
	case 'Rigid Body'
		JointQuantity = numel(Joint_Parameter{BodyNr}.Joint);
		Joint = cell(JointQuantity,1);
		for JointNr = 1:numel(Joint_Parameter{BodyNr}.Joint)
			r = Joint_Parameter{BodyNr}.Joint{JointNr}.r;
			phi = Joint_Parameter{BodyNr}.Joint{JointNr}.phi;
			
			Joint{JointNr} = set_RigidBody_Joint_Symbolic(r,phi,qe,dqe);
		end
	case 'Timoshenko Beam'
		Joint = set_FlexibleBeam_Joint(qe,dqe);
	case 'Super Truss Element'
		Joint = set_FlexibleBeam_Joint(qe,dqe);
	case 'Strut Tie Model'
		Joint = set_StrutTieModel_Joint(qe,dqe);
	case 'Strut Tie Rope Model'
		Joint = set_StrutTieModel_Joint(qe,dqe);
	case 'Cubic Spline Beam'
		Joint = set_CubicSplineBeam_Joint(qe,dqe);
	case 'Cubic Spline Rope'
		Joint = set_CubicSplineBeam_Joint(qe,dqe);
end
end


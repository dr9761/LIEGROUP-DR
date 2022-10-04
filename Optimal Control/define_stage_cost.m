function L = define_stage_cost(x,u,CostParameters)
switch CostParameters.ProblemName
	case 'Simple 2D Obstacle Avoidance'
		Q = CostParameters.Q;
		R = CostParameters.R;
		xe = CostParameters.xe;
		L = stage_cost_simple2DObstacleAvoidance(x,u,Q,R,xe);
	case 'Pendulum with Moving Joint - Tracking'
		Q = CostParameters.Q;
		alpha_d = CostParameters.alpha_d;
		beta_d = CostParameters.beta_d;
		alpha = x(4);
		beta = x(5);
		delta_phi = [alpha_d-alpha;beta_d-beta];
		L = delta_phi' * Q * delta_phi;
	case 'Pendulum with Moving Joint - Obstacle Avoidance'
		Q = CostParameters.Q;
		R = CostParameters.R;
		xe = CostParameters.xe;
		xe = reshape(xe,size(x));
		delta_x = xe - x;
		delta_x = reshape(delta_x,[numel(delta_x),1]);
		u = reshape(u,[numel(u),1]);
		L = delta_x'*Q*delta_x + u'*R*u;
		%
		r0 = reshape(x(1:3),[3,1]);
		alpha = x(4);
		beta = x(5);
		Length = CostParameters.BodyElementParameter{1}.L;
		gx = [1;0;0];
		RB = get_R_y(pi/2+alpha)*get_R_z(beta);
		r01 = r0 + Length * RB * gx;
		%
		L_Obstacle = Obstacle_cost_3DNormStyle(r01,CostParameters);
		L = L + L_Obstacle;
	case 'Ship Crane - Tracking'
		Q = CostParameters.Q;
		ye = CostParameters.ye;
		ModelParameter = CostParameters.ModelParameter;
		
		q = x(1:numel(x)/2);q = reshape(q,[numel(q),1]);
		dq = x(numel(x)/2+1:end);dq = reshape(dq,[numel(dq),1]);
		[r0n,~,dqn,~,~,~] = ShipCrane_ForwardKinematics(...
			q,dq,zeros(size(dq)),ModelParameter);
		r3 = r0n{3};
		dr3dt = dqn{3}(1:3);
		y = [r3;dr3dt];
		
		delta_y = ye - y;
		L = delta_y' * Q * delta_y;
	case 'Triple Jib Pendulum - PTP'
		Q = CostParameters.Q;
		R = CostParameters.R;
		x5e = CostParameters.x5e;
		ModelParameter = CostParameters.ModelParameter;
		%
		q = x(1:numel(x)/2);
		dq = x(numel(x)/2+1:end);
		[r0b,~,dqb,~,~] = get_TripleJib_Pendulum_ElementCoordinate_Symbolic(...
			q,dq,ModelParameter);
		r5 = r0b{4};
		dr5dt = dqb{4}(1:3);
		x5 = [r5;dr5dt];
		delta_x5 = x5e - x5;
		delta_y = [delta_x5;q(4:5);dq(4:5)];
		L = delta_y' * Q * delta_y;
		%
		L = L + u' * R * u;
end

end
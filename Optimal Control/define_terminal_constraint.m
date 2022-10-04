function ef = define_terminal_constraint(x,CostParameters)
% Pend = 100*eye(4);
% xe = [-35;10; 0; 0;] ;
% ef = (x-xe)'*Pend*(x-xe);
switch CostParameters.ProblemName
	case 'Simple 2D Obstacle Avoidance'
		Pend = CostParameters.Pend;
		xe = CostParameters.xe;
		ef = (x-xe)'*Pend*(x-xe);
	case 'Pendulum with Moving Joint - Tracking'
		Q = CostParameters.Q;
		alpha_d = CostParameters.alpha_d;
		beta_d = CostParameters.beta_d;
		alpha = x(4);
		beta = x(5);
		delta_phi = [alpha_d-alpha;beta_d-beta];
		ef = delta_phi' * Q * delta_phi;
	case 'Pendulum with Moving Joint - Obstacle Avoidance'
		Pend = CostParameters.Pend;
		xe = CostParameters.xe;
		delta_x = xe - x;
		ef = delta_x'*Pend*delta_x;
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
		ef = delta_y' * Q * delta_y;
	case 'Triple Jib Pendulum - PTP'
		Pend = CostParameters.Pend;
		x5e = CostParameters.x5e;
		ModelParameter = CostParameters.ModelParameter;
		
		q = x(1:numel(x)/2);
		dq = x(numel(x)/2+1:end);
		[r0b,~,dqb,~,~] = get_TripleJib_Pendulum_ElementCoordinate_Symbolic(...
			q,dq,ModelParameter);
		r5 = r0b{4};
		dr5dt = dqb{4}(1:3);
		x5 = [r5;dr5dt];
		delta_x5 = x5e - x5;
		delta_y = [delta_x5;q(4:5);dq(4:5)];
		
		alpha = 0;
		ef = delta_y' * Pend * delta_y - alpha;
		ef = 0;
end
end
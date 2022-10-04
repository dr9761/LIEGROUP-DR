function [Phi,B,dPhi,Tau] = set_Constraint_Symbolic(...
	q,dq,Bodyi,i,Bodyj,j, ...
	SpecialParameter,ConstraintType)
%% Joint
Joint_i = Bodyi.Joint{i};
Joint_j = Bodyj.Joint{j};
%%
switch ConstraintType
	case 'Revolute_x'	
		[Phi,B,dPhi,Tau] = set_Constraint_Revolute_x_axis_Symbolic(...
			q,dq,Bodyi,Joint_i,Bodyj,Joint_j);
	case 'Revolute_y'	
		[Phi,B,dPhi,Tau] = set_Constraint_Revolute_y_axis_Symbolic(...
			q,dq,Bodyi,Joint_i,Bodyj,Joint_j);
	case 'Revolute_z'
		[Phi,B,dPhi,Tau] = set_Constraint_Revolute_z_axis_Symbolic(...
			q,dq,Bodyi,Joint_i,Bodyj,Joint_j);
	case 'Prismatic'
		[Phi,B,dPhi,Tau] = set_Constraint_Prismatic_Symbolic(...
			q,dq,Bodyi,Joint_i,Bodyj,Joint_j);
	case 'Spherical'
		[Phi,B,dPhi,Tau] = set_Constraint_Spherical_Symbolic(...
			q,dq,Bodyi,Joint_i,Bodyj,Joint_j);
	case 'Fixed'
		[Phi,B,dPhi,Tau] = set_Constraint_Fixed_Symbolic(...
			q,dq,Bodyi,Joint_i,Bodyj,Joint_j);
	case 'Closed_Revolute'
		[Phi,B,dPhi,Tau] = set_Constraint_Closed_Revolute_Symbolic(...
			q,dq,Bodyi,Joint_i,Bodyj,Joint_j);
	case 'Winch-Cable'
		WinchRadius = SpecialParameter.WinchRadius;
		[Phi,B,dPhi,Tau] = set_Constraint_WinchCable(...
			q,dq,Bodyi,Joint_i,Bodyj,Joint_j,WinchRadius);
	otherwise
		Phi = [];B = [];dPhi = [];Tau = [];
end

end
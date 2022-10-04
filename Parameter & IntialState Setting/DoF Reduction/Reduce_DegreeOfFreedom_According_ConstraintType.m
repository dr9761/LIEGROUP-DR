function [Coordinate_overlap,Coordinate_abandon, ...
	AbandonConstraintNr] = ...
	Reduce_DegreeOfFreedom_According_ConstraintType(...
	ConstraintType,ConstraintNr, ...
	Body1,Body2,BodyType1,BodyType2,JointNr1,JointNr2)
%%
Joint1_Coordinate_overlap = [];
Joint2_Coordinate_overlap = [];
AbandonConstraint_Flag = false;
switch ConstraintType
	case 'Fixed'
		%%
		if ~strcmpi(BodyType1,'Rigid Body') && ...
				~strcmpi(BodyType2,'Rigid Body') && ...
				~strcmpi(BodyType1,'Frame') && ...
				~strcmpi(BodyType2,'Frame') && ...
				strcmpi(BodyType1,BodyType2)
			Coordinate1 = Body1.GlobalCoordinate;
			Coordinate2 = Body2.GlobalCoordinate;
			if JointNr1 == 1
				Joint1_Coordinate_overlap = Coordinate1(1:numel(Coordinate1)/2);
			elseif JointNr1 == 2
				Joint1_Coordinate_overlap = Coordinate1(numel(Coordinate1)/2+1:end);
			end
			if JointNr2 == 1
				Joint2_Coordinate_overlap = Coordinate2(1:numel(Coordinate2)/2);
			elseif JointNr2 == 2
				Joint2_Coordinate_overlap = Coordinate2(numel(Coordinate2)/2+1:end);
			end
			AbandonConstraint_Flag = true;
		elseif ~strcmpi(BodyType1,'Rigid Body') && ...
				~strcmpi(BodyType2,'Rigid Body') && ...
				~strcmpi(BodyType1,'Frame') && ...
				~strcmpi(BodyType2,'Frame') && ...
				~strcmpi(BodyType1,BodyType2)
% 			if JointNr1 == 1
% 				Joint1_Coordinate_overlap = [...
% 					Body1.Coordinate.r1,Body1.Coordinate.phi1];
% 			elseif JointNr1 == 2
% 				Joint1_Coordinate_overlap = [...
% 					Body1.Coordinate.r2,Body1.Coordinate.phi2];
% 			end
% 			if JointNr2 == 1
% 				Joint2_Coordinate_overlap = [...
% 					Body2.Coordinate.r1,Body2.Coordinate.phi1];
% 			elseif JointNr2 == 2
% 				Joint2_Coordinate_overlap = [...
% 					Body2.Coordinate.r2,Body2.Coordinate.phi2];
% 			end
% 			AbandonConstraint_Flag = true;
		elseif strcmpi(BodyType1,'Rigid Body') && ...
				~strcmpi(BodyType2,'Rigid Body')
% 			if JointNr1 == 1
% 				Joint1_Coordinate_overlap = Body1.Coordinate.r;
% 				if JointNr2 == 1
% 					Joint2_Coordinate_overlap = Body2.Coordinate.r1;
% 				elseif JointNr2 == 2
% 					Joint2_Coordinate_overlap = Body2.Coordinate.r2;
% 				end
% 			end
% 			AbandonConstraint_Flag = true;
		end
		% 		[q1,dq1,q2,dq2,Body1,Body2] = ...
		% 			Reduce_DegreeOfFreedom_for_Fixed_Constraint(...
		% 			q1,dq1,q2,dq2,Body1,Body2,JointNr1,JointNr2);
	case 'Spherical'
		%%
		if ~strcmpi(BodyType1,'Rigid Body') && ...
				~strcmpi(BodyType2,'Rigid Body') && ...
				~strcmpi(BodyType1,'Frame') && ...
				~strcmpi(BodyType2,'Frame')
			if JointNr1 == 1
				Joint1_Coordinate_overlap = Body1.Coordinate.r1;
			elseif JointNr1 == 2
				Joint1_Coordinate_overlap = Body1.Coordinate.r2;
			end
			if JointNr2 == 1
				Joint2_Coordinate_overlap = Body2.Coordinate.r1;
			elseif JointNr2 == 2
				Joint2_Coordinate_overlap = Body2.Coordinate.r2;
			end
			AbandonConstraint_Flag = true;
			
		else
			
		end
	case 'Revolute_y'
	%%
	if strcmpi(BodyType1,'Rigid Body') && ...
			~strcmpi(BodyType2,'Rigid Body')
		if JointNr1 == 1
			Joint1_Coordinate_overlap = Body1.Coordinate.r;
			if JointNr2 == 1
				Joint2_Coordinate_overlap = Body2.Coordinate.r1;
			elseif JointNr2 == 2
				Joint2_Coordinate_overlap = Body2.Coordinate.r2;
			end
		end
	elseif ~strcmpi(BodyType1,'Rigid Body') && ...
			~strcmpi(BodyType2,'Rigid Body') && ...
			~strcmpi(BodyType1,'Frame') && ...
			~strcmpi(BodyType2,'Frame')
		if JointNr1 == 1
			Joint1_Coordinate_overlap = Body1.Coordinate.r1;
		elseif JointNr1 == 2
			Joint1_Coordinate_overlap = Body1.Coordinate.r2;
		end
		if JointNr2 == 1
			Joint2_Coordinate_overlap = Body2.Coordinate.r1;
		elseif JointNr2 == 2
			Joint2_Coordinate_overlap = Body2.Coordinate.r2;
		end
	end
end
%%
Coordinate_overlap = [];
Coordinate_abandon = [];
AbandonConstraintNr = [];
% if ~isempty(Joint1_Coordinate_overlap) && ...
% 		~isempty(Joint2_Coordinate_overlap)
if AbandonConstraint_Flag
	Coordinate_overlap = ...
		min(Joint1_Coordinate_overlap,Joint2_Coordinate_overlap);
	Coordinate_abandon = ...
		max(Joint1_Coordinate_overlap,Joint2_Coordinate_overlap);
	
	AbandonConstraintNr = ConstraintNr;
else
end
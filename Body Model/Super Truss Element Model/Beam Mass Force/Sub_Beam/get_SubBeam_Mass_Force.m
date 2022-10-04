function [SubBeamMass,SubBeamForce] = get_SubBeam_Mass_Force(...
	InternalNode,Body_Parameter, ...
	PlaneNr,MainBeamNr1,InternalNodeNr1,MainBeamNr2,InternalNodeNr2, ...
	phib1,phib2,dqe,g)
%%
Rb1 = get_R(phib1);
Rb2 = get_R(phib2);

T_b1_i1 = [eye(3),zeros(3);zeros(3),Rb1'];
T_b2_i2 = [eye(3),zeros(3);zeros(3),Rb2'];
%%
% q1 = InternalNode.Plane{PlaneNr}.qi{MainBeamNr1,InternalNodeNr1};
% q2 = InternalNode.Plane{PlaneNr}.qi{MainBeamNr2,InternalNodeNr2};
% 
% R1 = get_R(q1(4:6));
% R2 = get_R(q2(4:6));
% 
% qb1 = zeros(6,1);
% qb1(1:3) = q1(1:3);
% qb1(4:6) = get_Rotation_from_R(R1*Rb1,q1(4:6));
% x1 = [1;0;0];
% x2 = R1*Rb1*[1;0;0];
% qb1(4:6) = get_Rotation_from_2_x_axis(x1,x2);

% qb2 = zeros(6,1);
% qb2(1:3) = q2(1:3);
% qb2(4:6) = get_Rotation_from_R(R2*Rb2,qb1(4:6));
% x1 = [1;0;0];
% x2 = R2*Rb2*[1;0;0];
% qb2(4:6) = get_Rotation_from_2_x_axis(x1,x2);

% qb = [qb1;qb2];

r0b1 = InternalNode.Plane{PlaneNr}.r0i{MainBeamNr1,InternalNodeNr1};
r0b2 = InternalNode.Plane{PlaneNr}.r0i{MainBeamNr2,InternalNodeNr2};
r0b = [r0b1;r0b2];

R1 = InternalNode.Plane{PlaneNr}.Ri{MainBeamNr1,InternalNodeNr1};
R2 = InternalNode.Plane{PlaneNr}.Ri{MainBeamNr2,InternalNodeNr2};
Rb = [R1*Rb1;R2*Rb2];
%%
dq1 = InternalNode.Plane{PlaneNr}.dqi{MainBeamNr1,InternalNodeNr1};
dq2 = InternalNode.Plane{PlaneNr}.dqi{MainBeamNr2,InternalNodeNr2};

dqb1 = zeros(6,1);
dqb1(1:3) = dq1(1:3);
dqb1(4:6) = Rb1' * dq1(4:6);

dqb2 = zeros(6,1);
dqb2(1:3) = dq2(1:3);
dqb2(4:6) = Rb2' * dq2(4:6);

dqb = [dqb1;dqb2];
%%
Ti1 = InternalNode.Plane{PlaneNr}.Ti{MainBeamNr1,InternalNodeNr1};
Ti2 = InternalNode.Plane{PlaneNr}.Ti{MainBeamNr2,InternalNodeNr2};

Tb1 = T_b1_i1 * Ti1;
Tb2 = T_b2_i2 * Ti2;

Tb = [Tb1;Tb2];
%%
dTi1dt = InternalNode.Plane{PlaneNr}.dTi{MainBeamNr1,InternalNodeNr1};
dTi2dt = InternalNode.Plane{PlaneNr}.dTi{MainBeamNr2,InternalNodeNr2};

dTb1dt = T_b1_i1 * dTi1dt;
dTb2dt = T_b2_i2 * dTi2dt;

dTbdt = [dTb1dt;dTb2dt];
%%
[SubBeamMass,SubBeamForce] = ...
	SuperTrussElement_TimoshenkoBeam_MassForce(...
	r0b,Rb,dqb,g,Body_Parameter);
%%
SubBeamForce = Tb' * (SubBeamMass * dTbdt * dqe + SubBeamForce);
SubBeamMass = Tb' * SubBeamMass * Tb;
% SubBeamMass\SubBeamForce
end
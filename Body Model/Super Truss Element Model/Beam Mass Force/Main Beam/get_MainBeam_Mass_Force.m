function [MainBeamMass,MainBeamForce] = get_MainBeam_Mass_Force(...
	InternalNode,MainBeamParameter,Body_Parameter, ...
	MainBeamNr,InternalNodeNr1,InternalNodeNr2, ...
	dqe,g)
%% To calculate the Mass Matrix and Force Vector,
%% we can simply use the coordinations of internal node,
%% because they are defined along Main Beam
%%
PlaneNr = MainBeamParameter.Plane{MainBeamNr}(1);
% q1 = InternalNode.Plane{PlaneNr}.qi{MainBeamNr,InternalNodeNr1};
% q2 = InternalNode.Plane{PlaneNr}.qi{MainBeamNr,InternalNodeNr2};
% 
% qb1 = zeros(6,1);
% qb1(1:3) = q1(1:3);
% qb1(4:6) = q1(4:6);
% 
% qb2 = zeros(6,1);
% qb2(1:3) = q2(1:3);
% qb2(4:6) = q2(4:6);
% 
% qb = [qb1;qb2];

r0b1 = InternalNode.Plane{PlaneNr}.r0i{MainBeamNr,InternalNodeNr1};
r0b2 = InternalNode.Plane{PlaneNr}.r0i{MainBeamNr,InternalNodeNr2};
r0b = [r0b1;r0b2];

Rb1 = InternalNode.Plane{PlaneNr}.Ri{MainBeamNr,InternalNodeNr1};
Rb2 = InternalNode.Plane{PlaneNr}.Ri{MainBeamNr,InternalNodeNr2};
Rb = [Rb1;Rb2];
%%
dq1 = InternalNode.Plane{PlaneNr}.dqi{MainBeamNr,InternalNodeNr1};
dq2 = InternalNode.Plane{PlaneNr}.dqi{MainBeamNr,InternalNodeNr2};

dqb1 = zeros(6,1);
dqb1(1:3) = dq1(1:3);
dqb1(4:6) = dq1(4:6);

dqb2 = zeros(6,1);
dqb2(1:3) = dq2(1:3);
dqb2(4:6) = dq2(4:6);

dqb = [dqb1;dqb2];
%%
Ti1 = InternalNode.Plane{PlaneNr}.Ti{MainBeamNr,InternalNodeNr1};
Ti2 = InternalNode.Plane{PlaneNr}.Ti{MainBeamNr,InternalNodeNr2};

Tb1 = Ti1;
Tb2 = Ti2;

Tb = [Tb1;Tb2];
%%
dTi1dt = InternalNode.Plane{PlaneNr}.dTi{MainBeamNr,InternalNodeNr1};
dTi2dt = InternalNode.Plane{PlaneNr}.dTi{MainBeamNr,InternalNodeNr2};

dTb1dt = dTi1dt;
dTb2dt = dTi2dt;

dTbdt = [dTb1dt;dTb2dt];
%%
[MainBeamMass,MainBeamForce] = ...
	SuperTrussElement_TimoshenkoBeam_MassForce(...
	r0b,Rb,dqb,g,Body_Parameter);
%%
MainBeamForce = Tb' * (MainBeamMass * dTbdt * dqe + ...
	MainBeamForce);
MainBeamMass = Tb' * MainBeamMass * Tb;


end
function [CrossSectionBeamMass,CrossSectionBeamForce] = ...
	get_CrossSectionBeam_Mass_Force(...
	CrossSectionNr,BeamNr,Point1Nr,Point2Nr,Body_Parameter, ...
	CrossSectionBeamParameter,CrossSectionNode,dqe,g)
%%
phib = ...
	CrossSectionBeamParameter.CrossSectionBeam{CrossSectionNr}.Rotation{BeamNr};
Rb = get_R(phib);
T_b_cs = [eye(3),zeros(3);zeros(3),Rb'];
%%
q1 = CrossSectionNode.CrossSection{CrossSectionNr}.qs{Point1Nr};
q2 = CrossSectionNode.CrossSection{CrossSectionNr}.qs{Point2Nr};

R1 = get_R(q1(4:6));
R2 = get_R(q2(4:6));

% qb1 = zeros(6,1);
% qb1(1:3) = q1(1:3);
% qb1(4:6) = get_Rotation_from_R(R1*Rb,q1(4:6));
% x1 = [1;0;0];
% x2 = R1*Rb*[1;0;0];
% qb1(4:6) = get_Rotation_from_2_x_axis(x1,x2);

% qb2 = zeros(6,1);
% qb2(1:3) = q2(1:3);
% qb2(4:6) = get_Rotation_from_R(R2*Rb,qb1(4:6));
% qb2(4:6) = q2(4:6) + R2 * phib;
% x1 = [1;0;0];
% x2 = R2*Rb*[1;0;0];
% qb2(4:6) = get_Rotation_from_2_x_axis(x1,x2);

% qb = [qb1;qb2];

r0b1 = q1(1:3);
r0b2 = q2(1:3);
r0b = [r0b1;r0b2];

Rb1 = R1*Rb;
Rb2 = R2*Rb;
R = [Rb1;Rb2];
%%
dq1 = CrossSectionNode.CrossSection{CrossSectionNr}.dqs{Point1Nr};
dq2 = CrossSectionNode.CrossSection{CrossSectionNr}.dqs{Point2Nr};

dqb1 = zeros(6,1);
dqb1(1:3) = dq1(1:3);
dqb1(4:6) = Rb' * dq1(4:6);

dqb2 = zeros(6,1);
dqb2(1:3) = dq2(1:3);
dqb2(4:6) = Rb' * dq2(4:6);

dqb = [dqb1;dqb2];
%%
Tcs1 = CrossSectionNode.CrossSection{CrossSectionNr}.Ts{Point1Nr};
Tcs2 = CrossSectionNode.CrossSection{CrossSectionNr}.Ts{Point2Nr};

Tb1 = T_b_cs * Tcs1;
Tb2 = T_b_cs * Tcs2;

Tb = [Tb1;Tb2];
%%
dTcs1dt = CrossSectionNode.CrossSection{CrossSectionNr}.dTs{Point1Nr};
dTcs2dt = CrossSectionNode.CrossSection{CrossSectionNr}.dTs{Point2Nr};

dTb1dt = T_b_cs * dTcs1dt;
dTb2dt = T_b_cs * dTcs2dt;

dTbdt = [dTb1dt;dTb2dt];
%%
[CrossSectionBeamMass,CrossSectionBeamForce] = ...
	SuperTrussElement_TimoshenkoBeam_MassForce(...
	r0b,R,dqb,g,Body_Parameter);
%%
CrossSectionBeamForce = Tb' * (CrossSectionBeamMass * dTbdt * dqe + ...
	CrossSectionBeamForce);
CrossSectionBeamMass = Tb' * CrossSectionBeamMass * Tb;


end
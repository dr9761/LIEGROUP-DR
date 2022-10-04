function [ModelParameter] = Calc_LatticeBoomCrane_InitialCoordinate(...
	MainBoomAngle,deltaL,ModelParameter)
% MainBoomAngle = 95;
% deltaL = 0;
MainBoomAngle = 180 - MainBoomAngle;
%%
BodyElementParameter = ModelParameter.BodyElementParameter;
Joint_Parameter = ModelParameter.Joint_Parameter;
q0 = ModelParameter.InitialState.q0;
q = zeros(size(ModelParameter.InitialState.q0));
gx = [1;0;0];
gy = [0;1;0];
gz = [0;0;1];
%% Body 1 Base
BodyNr = 1;
BodyParameter1 = BodyElementParameter{BodyNr};
GlobalCoordinate1 = BodyParameter1.GlobalCoordinate;

qe1 = zeros(6,1);

q(GlobalCoordinate1) = qe1;
%% Body 2 Main Boom
BodyNr = 2;
BodyParameter2 = BodyElementParameter{BodyNr};
GlobalCoordinate2 = BodyParameter2.GlobalCoordinate;
% qe0 = q0(GlobalCoordinate2);
L2 = BodyParameter2.Truss_Parameter.TrussLength;

r01 = zeros(3,1);
phi1 = -deg2rad(MainBoomAngle)*gy;
r02 = r01 + get_R(phi1)*gx*L2;
phi2 = phi1;
qe2 = [r01;phi1;r02;phi2];

q(GlobalCoordinate2) = qe2;
%% Body 3,4,5,6 Main Boom
for BodyNr = 3:6
	BodyParameter = BodyElementParameter{BodyNr};
	GlobalCoordinate = BodyParameter.GlobalCoordinate;
	qe0 = q0(GlobalCoordinate);
	L = BodyParameter.Truss_Parameter.TrussLength;
	
	r01 = r02;
	phi1 = -deg2rad(MainBoomAngle)*gy;
	r02 = r01 + get_R(phi1)*gx*L;
	phi2 = phi1;
	qe = [r01;phi1;r02;phi2];
	
	q(GlobalCoordinate) = qe;
end
%% Body 7 Main Boom
BodyNr = 7;
BodyParameter7 = BodyElementParameter{BodyNr};
GlobalCoordinate7 = BodyParameter7.GlobalCoordinate;
qe0 = q0(GlobalCoordinate7);

r01 = r02;
phi1 = -deg2rad(MainBoomAngle)*gy;
qe7 = [r01;phi1];

q(GlobalCoordinate7) = qe7;
%% Body 8,9,10 Sub Boom
BodyNr = 8;
BodyParameter8 = BodyElementParameter{BodyNr};
GlobalCoordinate8 = BodyParameter8.GlobalCoordinate;
qe0 = q0(GlobalCoordinate8);
qe8 = qe0;
q(GlobalCoordinate8) = qe8;

BodyNr = 9;
BodyParameter9 = BodyElementParameter{BodyNr};
GlobalCoordinate9 = BodyParameter9.GlobalCoordinate;
qe0 = q0(GlobalCoordinate9);
qe9 = qe0;
q(GlobalCoordinate9) = qe9;

BodyNr = 10;
BodyParameter10 = BodyElementParameter{BodyNr};
GlobalCoordinate10 = BodyParameter10.GlobalCoordinate;
qe0 = q0(GlobalCoordinate10);
qe10 = qe0;
q(GlobalCoordinate10) = qe10;
%% Body 11,12 Strut Tie
BodyNr = 11;
BodyParameter11 = BodyElementParameter{BodyNr};
GlobalCoordinate11 = BodyParameter11.GlobalCoordinate;
qe0 = q0(GlobalCoordinate11);
r01 = qe7(1:3)+get_R(qe7(4:6))*Joint_Parameter{7}.Joint{3}.r;
nx = (qe10(7:9) - r01) / norm(qe10(7:9) - r01);
r02 = r01 + nx*BodyParameter11.L;
qe11 = [r01;r02];
q(GlobalCoordinate11) = qe11;

BodyNr = 12;
BodyParameter12 = BodyElementParameter{BodyNr};
GlobalCoordinate12 = BodyParameter12.GlobalCoordinate;
qe0 = q0(GlobalCoordinate12);
r01 = r02;
r02 = r01 + nx*BodyParameter12.L;
qe12 = [r01;r02];
q(GlobalCoordinate12) = qe12;
%% Body 13 Changeable Rope
BodyNr = 13;
BodyParameter13 = BodyElementParameter{BodyNr};
GlobalCoordinate13 = BodyParameter13.GlobalCoordinate;
qe0 = q0(GlobalCoordinate13);
r01 = qe10(7:9);
r02 = qe12(4:6);
phi1 = -atan2(r02(3)-r01(3),r02(1)-r01(1))*gy;
phi2 = phi1;
dr01dt = 1;
dr02dt = 1;
qe13 = [r01;phi1;dr01dt;r02;phi2;dr02dt];
BodyElementParameter{BodyNr}.L = norm(r02-r01);
q(GlobalCoordinate13) = qe13;
%% Body 14 Unchangeable Rope
BodyNr = 14;
BodyParameter14 = BodyElementParameter{BodyNr};
GlobalCoordinate14 = BodyParameter14.GlobalCoordinate;
qe0 = q0(GlobalCoordinate14);
qe14 = qe0;
q(GlobalCoordinate14) = qe14;
%% Body 15 Lifting Rope
BodyNr = 15;
BodyParameter15 = BodyElementParameter{BodyNr};
GlobalCoordinate15 = BodyParameter15.GlobalCoordinate;
qe0 = q0(GlobalCoordinate15);
r01 = qe7(1:3)+get_R(qe7(4:6))*Joint_Parameter{7}.Joint{4}.r;
r02 = r01 - gz*(BodyParameter15.L-deltaL);
phi1 = pi/2*gy;
phi2 = phi1;
dr01dt = 1;
dr02dt = 1;
qe15 = [r01;phi1;dr01dt;r02;phi2;dr02dt];
BodyElementParameter{BodyNr}.L = norm(r02-r01);
q(GlobalCoordinate15) = qe15;
%% Body 16 Load
BodyNr = 16;
BodyParameter16 = BodyElementParameter{BodyNr};
GlobalCoordinate16 = BodyParameter16.GlobalCoordinate;
qe0 = q0(GlobalCoordinate16);
r01 = r02;
phi1 = phi2;
qe16 = [r01;phi1];
q(GlobalCoordinate16) = qe16;
%%
ModelParameter.InitialState.q0 = q;
ModelParameter.InitialState.x0 = ...
	[ModelParameter.InitialState.q0;ModelParameter.InitialState.dq0];
ModelParameter.BodyElementParameter = BodyElementParameter;
end
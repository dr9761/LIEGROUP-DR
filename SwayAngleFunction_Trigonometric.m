function [theta,dthetadt,ddthetadtdt] = SwayAngleFunction_Trigonometric(t,T1,T2,lambda)
if nargin < 4
	lambda = 1;
end

if t>=0 && t<=1/3*T1
	theta = sin(3*pi/T1*t)-3*pi/T1*t;
	dthetadt = 3*pi/T1*cos(3*pi/T1*t)-3*pi/T1;
	ddthetadtdt = -3*pi/T1*3*pi/T1*sin(3*pi/T1*t);
elseif t>1/3*T1 && t<=2/3*T1
	theta = 2*sin(3*pi/T1*t)-pi;
	dthetadt = 2*3*pi/T1*cos(3*pi/T1*t);
	ddthetadtdt = -2*3*pi/T1*3*pi/T1*sin(3*pi/T1*t);
elseif t>2/3*T1 && t<=T1
	theta = sin(3*pi/T1*t)+3*pi/T1*t-3*pi;
	dthetadt = 3*pi/T1*cos(3*pi/T1*t)+3*pi/T1;
	ddthetadtdt = -3*pi/T1*3*pi/T1*sin(3*pi/T1*t);
elseif t>T1 && t<=T1+T2
	theta = 0;
	dthetadt = 0;
	ddthetadtdt = 0;
elseif t>T1+T2 && t<=4/3*T1+T2
	theta = -sin(3*pi/T1*(t-T1-T2))+3*pi/T1*(t-T1-T2);
	dthetadt = -3*pi/T1*cos(3*pi/T1*(t-T1-T2))+3*pi/T1;
	ddthetadtdt = 3*pi/T1*3*pi/T1*sin(3*pi/T1*(t-T1-T2));
elseif t>4/3*T1+T2 && t<=5/3*T1+T2
	theta = -2*sin(3*pi/T1*(t-T1-T2))+pi;
	dthetadt = -2*3*pi/T1*cos(3*pi/T1*(t-T1-T2));
	ddthetadtdt = 2*3*pi/T1*3*pi/T1*sin(3*pi/T1*(t-T1-T2));
elseif t>5/3*T1+T2 && t<=2*T1+T2
	theta = -sin(3*pi/T1*(t-T1-T2))-3*pi/T1*(t-T1-T2)+3*pi;
	dthetadt = -3*pi/T1*cos(3*pi/T1*(t-T1-T2))-3*pi/T1;
	ddthetadtdt = 3*pi/T1*3*pi/T1*sin(3*pi/T1*(t-T1-T2));
else
	theta = 0;
	dthetadt = 0;
	ddthetadtdt = 0;
end

lambda = lambda/180*pi/5;
theta = lambda*theta;
dthetadt = lambda*dthetadt;
ddthetadtdt = lambda*ddthetadtdt;
end
function [s,v,a] = ...
	TrapezoidalVelocity_ThreeStage_Func_2(t,s0,t0,t1,t3)
%%
if t1 < 0
	t1 = 0;
elseif t3 < 0
	t3 = 0;
end
%%
if t1 > t0
	t1 = t0;
	t3 = 0;
elseif (t1+t3) > t0
	t3 = t0 - t1;
end
%%
t2 = t0 - t1 - t3;
a1 = 2*s0/t1/(2*t0-t1-t3);
a3 = -2*s0/t3/(2*t0-t1-t3);
vmax = a1*t1;
s1 = 1/2*a1*t1^2;
s2 = vmax*t2;
%%
if t < t1
	s = 1/2*a1*t^2;
	v = a1*t;
	a = a1;
elseif t >= t1 && t <= (t0-t3)
	s = s1 + vmax*(t-t1);
	v = vmax;
	a = 0;
elseif t > (t0-t3)
	s = s1 + s2 + vmax*(t-t1-t2) + 1/2*a3*(t-t1-t2)^2;
	v = vmax + a3 * (t-t1-t2);
	a = a3;	
end

end
function [s,v,a] = ThreeStage_PolyFunc_2(t,s0,t0,t1,t3)
if t > t0
	t = t0;
elseif t < 0
	t = 0;
end
%%
if t1 < 0
	t1 = 0;
end
if t3 < 0
	t3 = 0;
end
t2 = t0 - t1 - t3;
if t2 < 0
	t3 = t0 - t1;
	t2 = 0;
end
%%
v0 = s0 / (t0 - 1/2*t1 - 1/2*t3);
%%
[s,v,a] = ThreeStage_PolyFunc(t,t1,t2,t3,v0);
end
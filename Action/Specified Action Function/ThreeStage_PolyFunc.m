function [s,v,a] = ThreeStage_PolyFunc(t,t1,t2,t3,v0)
%%
if t >= 0 && t <= t1
	s=v0*t^3*(t1-1/2*t)/t1^3;
	v=v0*t^2*(3*t1-2*t)/t1^3;
	a=6*v0*t*(t1-t)/t1^3;
elseif t > t1 && t<= t1+t2
	s=1/2*v0*t1+v0*(t-t1);
	v=v0;
	a=0;
elseif t > t1+t2 && t <= t1+t2+t3
	s=1/2*v0*t1+v0*t2+v0*((t-t1-t2)-(t3*(t-t1-t2)^3-1/2*(t-t1-t2)^4)/t3^3);
	v=v0*(t1+t2+t3-t)^2*(t3+2*t-2*t1-2*t2)/t3^3;
	a=v0*6*(t1+t2-t)*(t1+t2+t3-t)/t3^3;
elseif t > t1+t2+t3
	s=v0*(1/2*t1 + t2 + 1/2*t3);
	v=0;
	a=0;
else
	s=0;
	v=0;
	a=0;
end

end
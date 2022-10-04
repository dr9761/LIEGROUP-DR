function plot_CubicSpline_Test_Postprocessing(...
	t_set,x_set,BodyParameter)

t_old = 0;
for TimeNr = 1:numel(t_set)-1
	t = t_set(TimeNr);
	if t - t_old > 0.01
		x = x_set(TimeNr,:);
		x = x';
		qe = x(1:numel(x)/2);
		
		fprintf('t = %d\n',t);
		plot_CubicSplineBeam(qe,20,BodyParameter,'r.-');
		axis([-15,15,-20,10,-20,10]);
		view(0,0);%x-z
		pause(t_set(TimeNr+1) - t_set(TimeNr));
		
		t_old = t;
	end
end

end
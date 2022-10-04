function plot_Mechanism_PostProcessing(x_set,t_set, ...
	ModelParameter,SolverParameter,FinalResultFigure)
%%
hold(FinalResultFigure,'off');
TimeSlotQuantity = numel(t_set);
Min_Time_Interval_for_Plot = 0.02;
Plotted_Time = -inf;
Animation_Interval_Factor = 10;
plot_q_set = [];
plot_t_set = [];
for TimeNr = 1:TimeSlotQuantity
	t = t_set(TimeNr);
	if t - Plotted_Time > Min_Time_Interval_for_Plot
		q = x_set(TimeNr,1:size(x_set,2)/2)';
		plot_q_set = [plot_q_set,q];
		plot_t_set = [plot_t_set,t];
		fprintf('t = %f\n',t_set(TimeNr));
		plot_Mechanism(q,ModelParameter,SolverParameter, ...
			FinalResultFigure);
		if TimeNr < TimeSlotQuantity
			deltat = (t_set(TimeNr+1) - t_set(TimeNr)) * ...
				Animation_Interval_Factor;
			pause(deltat);
		end
		Plotted_Time = t;
	end
end
end
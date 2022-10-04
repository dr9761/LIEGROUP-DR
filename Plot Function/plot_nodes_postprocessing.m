function plot_nodes_postprocessing(x,t,BodyElementParameter)

close all;figure(1);hold off;
for i = 1:(size(x,1)-1)
	q_plot = x(i,1:size(x,2)/2);
	fprintf('t = %f\n',t(i));
	plot_nodes(q_plot,BodyElementParameter);
	
	deltat = t(i+1) - t(i);
	pause(deltat);
end

end
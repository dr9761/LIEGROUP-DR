t_set = 0:0.1:100;
s1_set = zeros(size(t_set));v1_set = zeros(size(t_set));a1_set = zeros(size(t_set));
s2_set = zeros(size(t_set));v2_set = zeros(size(t_set));a2_set = zeros(size(t_set));
s3_set = zeros(size(t_set));v3_set = zeros(size(t_set));a3_set = zeros(size(t_set));
for TimeNr = 1:numel(t_set)
	t = t_set(TimeNr);
	[s1,v1,a1] = ThreeStage_PolyFunc_2(t,20,100,2,2);
	[s2,v2,a2] = ThreeStage_PolyFunc_2(t-25,45,50,10,10);
	[s3,v3,a3] = ThreeStage_PolyFunc_2(t-50,5,50,2,2);
	
	s1_set(TimeNr) = s1;v1_set(TimeNr) = v1;a1_set(TimeNr) = a1;
	s2_set(TimeNr) = s2;v2_set(TimeNr) = v2;a2_set(TimeNr) = a2;
	s3_set(TimeNr) = s3;v3_set(TimeNr) = v3;a3_set(TimeNr) = a3;
end
%%
ActionFigure = figure('Name','Action Function Test');
s_axes = subplot(3,1,1,'Parent',ActionFigure);
v_axes = subplot(3,1,2,'Parent',ActionFigure);
a_axes = subplot(3,1,3,'Parent',ActionFigure);
%
plot(s_axes,t_set,[s1_set;s2_set;s3_set]);
plot(v_axes,t_set,[v1_set;v2_set;v3_set]);
plot(a_axes,t_set,[a1_set;a2_set;a3_set]);
%
legend(s_axes,'  u_1','  u_2','  u_3','location','bestoutside');
legend(v_axes,' du_1',' du_2',' du_3','location','bestoutside');
legend(a_axes,'ddu_1','ddu_2','ddu_3','location','bestoutside');
%
axis(s_axes,[0,100,0,60]);
axis(v_axes,[0,100,0,1.5]);
axis(a_axes,[0,100,-0.2,0.2]);
%
title(s_axes,'u-t');
title(v_axes,'dudt-t');
title(a_axes,'ddudtdt-t');
%
xlabel(s_axes,'Time');
xlabel(v_axes,'Time');
xlabel(a_axes,'Time');
%
ylabel(s_axes,'u');
ylabel(v_axes,'du');
ylabel(a_axes,'ddu');
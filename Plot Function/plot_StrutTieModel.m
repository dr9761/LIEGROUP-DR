function plot_StrutTieModel(qe,PlotStyle,FigureObj)
%%
r1 = qe(1:3);
r2 = qe(4:6);
r = [r1,r2];
%%
x = r(1,:);
y = r(2,:);
z = r(3,:);
%%
plot3(FigureObj,x,y,z,PlotStyle);
end
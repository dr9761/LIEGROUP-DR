function [A,b,c,r] = Load_Implicit_RungeKutta_Parameter(Name,s)
%%
% c1 | a11 ... a1s
% :  |  :  ...  :
% cs | as1 ... ass
% ------------------
%    |  b1 ...  bs
%%
switch Name
	case 'Lobatto'
		%%
		r = 4;
		b = [1/12,5/12,5/12,1/12];
		A = [ ...
			0,			0,				0,				0;
			11+sqrt(5),	25-sqrt(5),		25-13*sqrt(5),	-1+sqrt(5);
			11-sqrt(5),	25+13*sqrt(5),	25+5*sqrt(5),	-1-sqrt(5);
			10,			50,				50,				10] ...
			/ 120;
		c = [0,(5-sqrt(5))/10,(5+sqrt(5))/10,1];
	case 'Radau'
		%%
		r = 3;
		b = [16-sqrt(6),16+sqrt(6),4] / 36;
		A = [ ...
			440-35*sqrt(6),		296-169*sqrt(6),	-16+24*sqrt(6);
			296+169*sqrt(6),	440+35*sqrt(6),		-16-24*sqrt(6);
			800-50*sqrt(6),		800+50*sqrt(6),		200] ...
			/ 1800;
		c = [4-sqrt(6),4+sqrt(6),10] / 10;
	case 'Gauss'
		%%
		r = 3;
		b = [5,8,5] / 18;
		A = [ ...
			50,				80-24*sqrt(15),	50-12*sqrt(15);
			50+15*sqrt(15),	80,				50-15*sqrt(6);
			50-12*sqrt(15),	80+24*sqrt(15),	50] ...
			/ 360;
		c = [5-sqrt(15),5,5+sqrt(15)] / 10;
	case 'Kutta 4'
		%%
		r = 4;
		b = [1,3,3,1] / 8;
		A = [ ...
			0,		0,	0,	0;
			1/3,	0,	0,	0;
			-1/3,	1,	0,	0;
			1,		-1,	1,	0];
		c = [0,1,2,3] / 3;
end

end
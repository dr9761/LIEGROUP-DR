function plot_nodes(q,BodyElementParameter)
q = reshape(q,[numel(q),1]);
n = numel(q)/6;
x = [];y = [];z = [];
plot_Sequence{1} = [1,2];
plot_Sequence{2} = [1,2];
plot_Sequence{3} = [1,2];

for BodyNr = 1:numel(BodyElementParameter)
% 	qe = q(6*(BodyNr-1)+1:6*(BodyNr-1)+6);
	
	%%
	DoFQuantity = numel(BodyElementParameter{BodyNr}.DoF);
	qe  = zeros(6*DoFQuantity,1);
	dqe = zeros(6*DoFQuantity,1);
	mq = cell(1,DoFQuantity);
	for DoFNr = 1:DoFQuantity
		GeneralizedCoordinationNr = BodyElementParameter{BodyNr}.DoF(DoFNr);
		mq{DoFNr}  = 6*(GeneralizedCoordinationNr-1) + [1:6];
		mqe = 6*(DoFNr-1) + [1:6];
		qe(mqe)  = q(mq{DoFNr});
	end
	%%
	Body{BodyNr}.Joint = set_Joint(qe,dqe,BodyElementParameter,BodyNr);
	for j = 1:numel(plot_Sequence{BodyNr})
		r = Body{BodyNr}.Joint{plot_Sequence{BodyNr}(j)}.r;
		x = [x,r(1)];y = [y,r(2)];z = [z,r(3)];
	end
	
	if BodyNr == 1
		hold off;
	else
		hold on;
	end
	plot3(x,y,z);
% 	plot(x,y);
	x = [];y = [];z = [];
end

% plot3(x,y,z,'r.-');
% axis([-sum(L),sum(L),-sum(L),sum(L),-sum(L),sum(L)]);
axis([-2,2,-2,2,-2,2]);
xlabel('x');ylabel('y');zlabel('z');
grid on;

% plot(x,z,'r.-');
% axis([-sum(L),sum(L),-sum(L),sum(L)]);
% xlabel('x');ylabel('y');
end
function [q0,dq0] = set_Initial_State(...
	BodyElementParameter,ExcelFilePath)
[~,~,InitialStateTableRaw] = ...
	xlsread(ExcelFilePath,'Initial State');
BodyQuantity = numel(BodyElementParameter);

% GeneralizedCoordinationQuantity = 0;
q0 = [];dq0 = [];
for BodyNr = 1:BodyQuantity
	switch InitialStateTableRaw{2,BodyNr+3}
		case 'Rigid Body'
			q0 = [q0; ...
				[InitialStateTableRaw{2+[1:6],BodyNr+3}]'];
			dq0 = [dq0; ...
				[InitialStateTableRaw{12+2+[1:6],BodyNr+3}]'];
		case 'Timoshenko Beam'
			q0 = [q0; ...
				[InitialStateTableRaw{2+[1:12],BodyNr+3}]'];
			dq0 = [dq0; ...
				[InitialStateTableRaw{12+2+[1:12],BodyNr+3}]'];
		case 'Super Truss Element'
			q0 = [q0; ...
				[InitialStateTableRaw{2+[1:12],BodyNr+3}]'];
			dq0 = [dq0; ...
				[InitialStateTableRaw{12+2+[1:12],BodyNr+3}]'];
		case 'Strut Tie Model'
			q0 = [q0; ...
				[InitialStateTableRaw{[2+[1:3],8+[1:3]],BodyNr+3}]'];
			dq0 = [dq0; ...
				[InitialStateTableRaw{12+[2+[1:3],8+[1:3]],BodyNr+3}]'];
		case 'Strut Tie Rope Model'
			q0 = [q0; ...
				[InitialStateTableRaw{[2+[1:3],8+[1:3]],BodyNr+3}]'];
			dq0 = [dq0; ...
				[InitialStateTableRaw{12+[2+[1:3],8+[1:3]],BodyNr+3}]'];
		case 'Cubic Spline Beam'
			q0 = [q0; ...
				[InitialStateTableRaw{2+[1:6],BodyNr+3}]'];
			q0 = [q0; ...
				[InitialStateTableRaw{27,BodyNr+3}]'];
			q0 = [q0; ...
				[InitialStateTableRaw{2+[7:12],BodyNr+3}]'];
			q0 = [q0; ...
				[InitialStateTableRaw{29,BodyNr+3}]'];

			dq0 = [dq0; ...
				[InitialStateTableRaw{12+2+[1:6],BodyNr+3}]'];
			dq0 = [dq0; ...
				[InitialStateTableRaw{28,BodyNr+3}]'];
			dq0 = [dq0; ...
				[InitialStateTableRaw{12+2+[7:12],BodyNr+3}]'];
			dq0 = [dq0; ...
				[InitialStateTableRaw{30,BodyNr+3}]'];
		case 'Cubic Spline Rope'
			q0 = [q0; ...
				[InitialStateTableRaw{2+[1:6],BodyNr+3}]'];
			q0 = [q0; ...
				[InitialStateTableRaw{27,BodyNr+3}]'];
			q0 = [q0; ...
				[InitialStateTableRaw{2+[7:12],BodyNr+3}]'];
			q0 = [q0; ...
				[InitialStateTableRaw{29,BodyNr+3}]'];

			dq0 = [dq0; ...
				[InitialStateTableRaw{12+2+[1:6],BodyNr+3}]'];
			dq0 = [dq0; ...
				[InitialStateTableRaw{28,BodyNr+3}]'];
			dq0 = [dq0; ...
				[InitialStateTableRaw{12+2+[7:12],BodyNr+3}]'];
			dq0 = [dq0; ...
				[InitialStateTableRaw{30,BodyNr+3}]'];
        case 'Lie Group Beam'
            q0 = [q0; ...
                []]
		otherwise
			pause;
	end
% 	GeneralizedCoordinationQuantity = GeneralizedCoordinationQuantity + ...
% 		numel(BodyElementParameter{BodyNr}.DoF);
end
%%
% x0 = [q0;dq0];
end
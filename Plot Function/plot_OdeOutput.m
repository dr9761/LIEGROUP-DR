function status = plot_OdeOutput(t,y,flag, ...
	ModelParameter,SolverParameter, ...
	StateFigure,StateAxis, ...
	CalcMechanismAxesSet)

status = 0;         % Assume stop button wasn't pushed.
callbackDelay = 1;  % Check Stop button every 1 sec.

% support odeplot(t,y) [v5 syntax]
if nargin < 3 || isempty(flag)
	flag = '';
elseif isstring(flag) && isscalar(flag)
	flag = char(flag);
end

switch(flag)
	case ''    % odeplot(t,y,'')
		StateTimeData = get(StateFigure,'UserData');
		if StateTimeData.stop == 1  % Has stop button been pushed?
			status = 1;
		else
			for i = 1:length(StateTimeData.anim)
				addpoints(StateTimeData.anim(i),t,y(i));
			end
			if etime(clock,StateTimeData.callbackTime) < callbackDelay
				drawnow update;
			else
				%
				q = y(1:numel(y)/2);
				plot_Mechanism(q,ModelParameter,SolverParameter,CalcMechanismAxesSet.xz);
				plot_Mechanism(q,ModelParameter,SolverParameter,CalcMechanismAxesSet.xy);
				plot_Mechanism(q,ModelParameter,SolverParameter,CalcMechanismAxesSet.yz);
				plot_Mechanism(q,ModelParameter,SolverParameter,CalcMechanismAxesSet.normal);
				
				view(CalcMechanismAxesSet.xz,0,0);%x-z
				view(CalcMechanismAxesSet.xy,0,90);%x-y
				view(CalcMechanismAxesSet.yz,90,0);%y-z
				%
				StateTimeData.callbackTime = clock;
				set(StateFigure,'UserData',StateTimeData);
				drawnow;
			end
		end
		
		
	case 'init'    % odeplot(tspan,y0,'init')
		StateTimeData.lines = plot(t(1),y,'.-','Parent',StateAxis);
		for i = 1:numel(y)
			StateTimeData.anim(i) = animatedline(t(1),y(i),'Parent',StateAxis,...
				'Color',get(StateTimeData.lines(i),'Color'),...
				'Marker',get(StateTimeData.lines(i),'Marker'));
		end
		set(StateAxis,'XLim',[min(t) max(t)]);
		% Set Stop Button
		StopButtonPos = get(0,'DefaultUicontrolPosition');
		StopButtonPos(1) = 5;
		StopButtonPos(2) = 5;
		StopButtonCallbackHandle = @(src,event)StopButtonCallback(...
			src,event,StateFigure);
		uicontrol( ...
			'Style','pushbutton', ...
			'String',getString(message('MATLAB:odeplot:ButtonStop')), ...
			'Position',StopButtonPos, ...
			'Parent',StateFigure, ...
			'Callback',StopButtonCallbackHandle, ...
			'Tag','stop');
		StateTimeData.stop = 0;
		% Set figure data
		StateTimeData.callbackTime = clock;
		set(StateFigure,'UserData',StateTimeData);
		%
		q = y(1:numel(y)/2);
		plot_Mechanism(q,ModelParameter,SolverParameter,CalcMechanismAxesSet.xz);
		plot_Mechanism(q,ModelParameter,SolverParameter,CalcMechanismAxesSet.xy);
		plot_Mechanism(q,ModelParameter,SolverParameter,CalcMechanismAxesSet.yz);
		plot_Mechanism(q,ModelParameter,SolverParameter,CalcMechanismAxesSet.normal);
		
		view(CalcMechanismAxesSet.xz,0,0);%x-z
		view(CalcMechanismAxesSet.xy,0,90);%x-y
		view(CalcMechanismAxesSet.yz,90,0);%y-z
		% fast update
		drawnow update;
		
	case 'done'    % odeplot([],[],'done')
		
	otherwise
		error(message('MATLAB:odeplot:UnrecognizedFlag', flag));
end  % switch flag

end  % odeplot

% --------------------------------------------------------------------------
% Sub-function
%
function StopButtonCallback(src,event,StateFigure)
ud = get(StateFigure,'UserData');
ud.stop = 1;
set(StateFigure,'UserData',ud);
end  % StopButtonCallback
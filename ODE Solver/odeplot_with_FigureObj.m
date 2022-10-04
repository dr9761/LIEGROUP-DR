function status = odeplot_with_FigureObj(t,y,flag, ...
	TARGET_FIGURE,TARGET_AXIS)

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

        if (isempty(TARGET_FIGURE) || isempty(TARGET_AXIS))

            error(message('MATLAB:odeplot:NotCalledWithInit'));

        elseif (ishghandle(TARGET_FIGURE) && ishghandle(TARGET_AXIS))  % figure still open

            try
                ud = get(TARGET_FIGURE,'UserData');
                if ud.stop == 1  % Has stop button been pushed?
                    status = 1;
                else
                    for i = 1 : length(ud.anim)
                        addpoints(ud.anim(i),t,y(i,:));
                    end
                    if etime(clock,ud.callbackTime) < callbackDelay
                        drawnow update;
                    else
                        ud.callbackTime = clock;
                        set(TARGET_FIGURE,'UserData',ud);
                        drawnow;
                    end
                end
            catch ME
                error(message('MATLAB:odeplot:ErrorUpdatingWindow', ME.message));
            end

        end

      case 'init'    % odeplot(tspan,y0,'init')

%         f = figure(gcf);
%         TARGET_FIGURE = f;
%         TARGET_AXIS = gca;
        ud = get(TARGET_FIGURE,'UserData');

        % Initialize lines
        if ~ishold || ~isfield(ud,'lines')
            ud.lines = plot(t(1),y,'-','Parent',TARGET_AXIS);
        end
        for i = 1 : length(y)
            ud.anim(i) = animatedline(t(1),y(i),'Parent',TARGET_AXIS,...
                                      'Color',get(ud.lines(i),'Color'),...
                                      'Marker',get(ud.lines(i),'Marker'));
        end

        if ~ishold
            set(TARGET_AXIS,'XLim',[min(t) max(t)]);
        end

        % The STOP button
        h = findobj(TARGET_FIGURE,'Tag','stop');
        if isempty(h)
            pos = get(0,'DefaultUicontrolPosition');
            pos(1) = pos(1) - 15;
            pos(2) = pos(2) - 15;
            uicontrol( ...
                'Style','pushbutton', ...
                'String',getString(message('MATLAB:odeplot:ButtonStop')), ...
                'Position',pos, ...
				'Parent',TARGET_FIGURE, ...
                'Callback',@StopButtonCallback, ...
                'Tag','stop');
            ud.stop = 0;
        else
            % make sure it's visible
            set(h,'Visible','on');
            % don't change old ud.stop status
            if ~ishold || ~isfield(ud,'stop')
                ud.stop = 0;
            end
        end

        % Set figure data
        ud.callbackTime = clock;
        set(TARGET_FIGURE,'UserData',ud);

        % fast update
        drawnow update;

      case 'done'    % odeplot([],[],'done')

%         f = TARGET_FIGURE;
%         TARGET_FIGURE = [];
        ta = TARGET_AXIS;
%         TARGET_AXIS = [];

        if ishghandle(TARGET_FIGURE)
            ud = get(TARGET_FIGURE,'UserData');
            if ishghandle(ta)
                for i = 1 : length(ud.anim)
                    [tt,yy] = getpoints(ud.anim(i));
                    np = get(ta,'NextPlot');
                    set(ta,'NextPlot','add');
                    ud.lines(i) = plot(tt,yy,'Parent',ta,...
                                       'Color',get(ud.anim(i),'Color'),...
                                       'Marker',get(ud.anim(i),'Marker'));
                    set(ta,'NextPlot',np);
                    delete(ud.anim(i));
                end
            end
            set(TARGET_FIGURE,'UserData',rmfield(ud,{'anim','callbackTime'}));
            if ~ishold
                set(findobj(TARGET_FIGURE,'Tag','stop'),'Visible','off');
                if ishghandle(ta)
                    set(ta,'XLimMode','auto');
                end
            end
        end

        % full update
        drawnow;

      otherwise

        error(message('MATLAB:odeplot:UnrecognizedFlag', flag));

    end  % switch flag

end  % odeplot

% --------------------------------------------------------------------------
% Sub-function
%

function StopButtonCallback(~,~)
    ud = get(gcbf,'UserData');
    ud.stop = 1;
    set(gcbf,'UserData',ud);
end  % StopButtonCallback

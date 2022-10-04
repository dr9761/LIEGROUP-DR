function Save_Video(t_set,x_set,ModelParameter,SolverParameter, ...
	VideoName,VideoFrameRate)
%%
if nargin < 6
	VideoFrameRate = 30;
end
%%
VideoObj = VideoWriter(['Video\', ...
	VideoName,datestr(now,'yyyymmdd_HHMM'), ...
	'.avi']);

VideoFigure = figure('Name','Video');
VideoAxes = axes(VideoFigure);
VideoObj.FrameRate = VideoFrameRate;
VideoRate = VideoObj.FrameRate;
VideoTimeInterval = 1/VideoRate;

open(VideoObj);
%%
TimeNrSet_Video = [];
t_set_Video = [];
Temp_FrameMaxCount = floor(t_set(end) / VideoTimeInterval) + 1;
for Temp_FrameCount = 0:Temp_FrameMaxCount
	TimeNr = find(t_set >= Temp_FrameCount*VideoTimeInterval);
	if ~isempty(TimeNr)
		t = t_set(TimeNr);
		TimeNrSet_Video = [TimeNrSet_Video;TimeNr(1)];
		t_set_Video = [t_set_Video;t(1)];
	end
end
%%
for TimeNr_Video = 1:numel(TimeNrSet_Video)
	
	TimeNr = TimeNrSet_Video(TimeNr_Video);
	t = t_set(TimeNr);
	
% 	SolverParameter.PlotConfiguration.Azimuth = t/t_set(end)*90;%-37.5000
% 	SolverParameter.PlotConfiguration.Elevation = 0;%30
	
	q = x_set(TimeNr,1:size(x_set,2)/2)';
	plot_Mechanism(q,ModelParameter,SolverParameter, ...
		VideoAxes);
	drawnow;
	
	frame = getframe(VideoFigure);
	writeVideo(VideoObj,frame);
	fprintf('%4.0f/%4.0f Frame has been written\n', ...
		TimeNr_Video,numel(TimeNrSet_Video));
end
%%
close(VideoObj);
end
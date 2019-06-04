function topoCurrentSourceAvailableListener_Callback(src, event, hObject, handles)
%currentSourceAvailableListener_Callback This function is called when new
%estimated current source is available.
%
%   This function is a member of VisualizationSubView/TopoPlot.m controller file.
%
%   This function will be call when the listener is notified of
%   'CurrentSourceAvailable' event.
%
%   'CurrentSourceAvailable' event happens when 
%   'CorticalCurrentSourceEstimator' object successfully estimates current
%   source using 'vb_current_calc' function by invoking 'FeedEEG' method.
%
%   This function plot topographic map of estimated current source to 
%   topographic axes axes in the GUI.

disp('Topographic plot has received current source from estimator')
% global EEGBuffer;

% CCSChannelList = handles.CCSEstimator.CurrentProfile.CCSChannelName;
% handles.CCSChannelListbox.String = CCSChannelList;

% TopoWindow_data = guidata(handles.TopoWindowHandle);
handles.topoPlotProfileNameText.String = handles.mainWindowHandles.CCSEstimator.CurrentProfile.Name;
plotTopographic(handles.topographicAxes, ...
    event.Current, ...
    handles.mainWindowHandles.CCSEstimator.CurrentProfile, ...
    char(handles.topoplotOrientationPopupmenu.String(handles.topoplotOrientationPopupmenu.Value)), ...
    true, ...
    str2double(handles.topoplotThresholdEdit.String), ...
    [str2double(handles.topoplotLowerRangeEdit.String), str2double(handles.topoplotUpperRangeEdit.String)]);

end


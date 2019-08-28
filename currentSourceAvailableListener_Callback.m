function currentSourceAvailableListener_Callback(src, event, hObject, handles)
%currentSourceAvailableListener_Callback This function is called when new
%estimated current source is available.
%
%   This function is a member of REC.m controller file.
%
%   This function will be call when the listener is notified of
%   'CurrentSourceAvailable' event.
%
%   'CurrentSourceAvailable' event happens when 
%   'CorticalCurrentSourceEstimator' object successfully estimates current
%   source using 'vb_current_calc' function by invoking 'FeedEEG' method.
%
%   This function plot estimated current source to Current Source axes in
%   the GUI, and update any GUI elements related to current source
%   properties.

disp('Main program has received current source from estimator')
global EEGBuffer;

%% Update GUI elements
CCSChannelList = handles.CCSEstimator.CurrentProfile.CCSChannelName;
handles.CCSChannelListbox.String = CCSChannelList;

%% Plot current source to CCS axes
plotToAxes(handles.CCSAxes, ...
    event.Current(handles.CCSChannelListbox.Value,:), ...
    CCSChannelList(handles.CCSChannelListbox.Value,:), ...
    EEGBuffer.Frequency, ...
    EEGBuffer.BufferLength, ...
    str2double(handles.CCSScalePopupmenu.String(handles.CCSScalePopupmenu.Value)), ...
    str2double(handles.CCSPeriodPopupmenu.String(handles.CCSPeriodPopupmenu.Value)));

% if ~isempty(handles.TopoWindowHandle)
%     TopoWindow_data = guidata(handles.TopoWindowHandle);
%     handles.topoPlotProfileNameText.String = handles.mainWindowHandles.CCSEstimator.CurrentProfile.Name;
%     plotTopographic(handles.topographicAxes, ...
%         event.Current, ...
%         handles.mainWindowHandles.CCSEstimator.CurrentProfile, ...
%         char(handles.topoplotOrientationPopupmenu.String(handles.topoplotOrientationPopupmenu.Value)), ...
%         true, ...
%         str2double(handles.topoplotThresholdEdit.String), ...
%         [str2double(handles.topoplotLowerRangeEdit.String), str2double(handles.topoplotUpperRangeEdit.String)]);
% end
end


function inputBufferDataAvailableListener_Callback(src, event, hObject, handles)
%EEGInputListener_Callback This function is called when a new input buffer
%data is available.
%
%   This function is a member of REC.m controller file.
%
%   This function will be call when the listener is notified of
%   'InputBufferDataAvailable' event.
%
%   'InputBufferDataAvailable' event happens when descendant of 'RECInputBuffer' 
%   abstract class successfully read data from external sensor by invokeing
%   'ReadBuffer' method.
%
%   This function appends newly read data to 'EEGBuffer' object. Then it
%   plots the data currently available in 'EEGBuffer' object into EEG axes
%   on GUI. Finally, it feed the data currently available in 'EEGBuffer'
%   object to 'CorticalCurrentSourceEstimator' object by invoking the
%   object's 'FeedEEG' method.

global EEGBuffer;
global isEstimating;
global plotFilteredSignal;
global plotAverageSignal;
global plotReferencedSignal;
global plotTriggers;
global plotPotential;

disp('Main program has recieved data from input buffer');

%% Append new data to EEG buffer
if isa(event, 'MarkedEEGData')
    EEGBuffer = EEGBuffer.AppendDataWithFrequency(event.RawData.EEG, event.Header.Fs);
    EEGBuffer = EEGBuffer.AppendTriggerSignals(event.RawData.Trigger);
    EEGBuffer.DataLabels = event.Header.EEGLabel;
    EEGBuffer.TriggerLabels = event.Header.TriggerLabel;
    handles.displayAveragePotentialCheckbox.Enable = 'on';
    
    triggerSignals = EEGBuffer.TriggerSignals;
    [xCor, values] = handles.inputBuffer.TriggerDecoder.Decode(triggerSignals);
    EEGBuffer = EEGBuffer.UpdateCurrentTriggerState(xCor, values);
    EEGBuffer = EEGBuffer.PushEEGChannelsToPotentialCacheForTrigger(str2double(handles.TriggerValueEdit.String));
else
    EEGBuffer = EEGBuffer.AppendDataWithFrequency(event.RawData, event.Header.Fs);
    EEGBuffer.DataLabels = event.Header.label;
    handles.displayAveragePotentialCheckbox.Enable = 'off';
end
%% Plot data to EEG axes
handles.frequencyText.String = num2str(event.Header.Fs);
handles.numberOfChannelsText.String = num2str(EEGBuffer.NumberOfDataChannels);
handles.EEGChannelListbox.String = EEGBuffer.DataLabels;
handles.EEGReferenceListbox.String = EEGBuffer.DataLabels;
handles.applyReferenceChannelButton.Enable = 'on';
if isa(event, 'MarkedEEGData')
    handles.displayTriggersCheckbox.Enable = 'on';
    handles.TriggerListbox.Enable = 'on';
    handles.TriggerListbox.String = EEGBuffer.TriggerLabels;
else
    handles.displayTriggersCheckbox.Enable = 'off';
    handles.TriggerListbox.Enable = 'off';
end

ymode = 1;

if plotFilteredSignal == true
    try
        plottingData = EEGBuffer.FilteredData(handles.EEGChannelListbox.Value);
    catch
        handles.EEGChannelListbox.Value = 1;
        plottingData = EEGBuffer.FilteredData(handles.EEGChannelListbox.Value);
    end
else
    try
        plottingData = EEGBuffer.Data(handles.EEGChannelListbox.Value,:);
    catch
        handles.EEGChannelListbox.Value = 1;
        plottingData = EEGBuffer.Data(handles.EEGChannelListbox.Value,:);
    end
end

if plotAverageSignal == true
    try
        plottingLabels = {'Avg'};
        if size(plottingData, 1) ~= 1
            plottingData = mean(plottingData);
        end
    catch
        disp('Plot average error occurs')
        msgbox('Unable to plot average EEG', 'Plot Error', 'error');
        plotAverageSignal = false;
    end
else
    plottingLabels = EEGBuffer.DataLabels(handles.EEGChannelListbox.Value,:);
end

if plotPotential == true
    disp('Trigger Detected.');
    try
        if handles.EEGPeriodPopupmenu.Value > 3
            handles.EEGPeriodPopupmenu.Value = 1;
        end
        handles.EEGPeriodPopupmenu.String = {'3', '1.5', '0.3'};
        plottingLabels = {'Ptn.'};
        
        if plotFilteredSignal == true
            plottingData = EEGBuffer.FilteredAverageEEGPotentialSegment;
        elseif plotReferencedSignal == true
            plottingData = EEGBuffer.ReferencedAverageEEGPotentialSegment;
        elseif plotReferencedSignal == true && plotFilteredSignal == true
            plottingData = EEGBuffer.FilteredReferencedAverageEEGPotentialSegment;
        else
            plottingData = EEGBuffer.AverageEEGPotentialSegment;
        end
        
        if strcmp(handles.EEGPeriodPopupmenu.String(handles.EEGPeriodPopupmenu.Value), '3')
            plottingLength = EEGBuffer.PotentialCacheLength;
            plottingPeriod = EEGBuffer.PotentialCacheLength;
            markerPosition = EEGBuffer.Frequency;
        elseif strcmp(handles.EEGPeriodPopupmenu.String(handles.EEGPeriodPopupmenu.Value), '1.5')
            if length(plottingData) >= EEGBuffer.Frequency * 3
                plottingData = plottingData(EEGBuffer.Frequency * 0.5:EEGBuffer.Frequency * 2);
            end
            plottingLength = str2double(handles.EEGPeriodPopupmenu.String(handles.EEGPeriodPopupmenu.Value));
            plottingPeriod = str2double(handles.EEGPeriodPopupmenu.String(handles.EEGPeriodPopupmenu.Value));
            markerPosition = EEGBuffer.Frequency * 0.5;
        elseif strcmp(handles.EEGPeriodPopupmenu.String(handles.EEGPeriodPopupmenu.Value), '0.3')
            triggerPosition = EEGBuffer.Frequency * 1;
            if length(plottingData) >= EEGBuffer.Frequency * 3
                plottingData = plottingData(triggerPosition - floor(EEGBuffer.Frequency * 0.1):triggerPosition + floor(EEGBuffer.Frequency * 0.2));
            end
            plottingLength = str2double(handles.EEGPeriodPopupmenu.String(handles.EEGPeriodPopupmenu.Value));
            plottingPeriod = str2double(handles.EEGPeriodPopupmenu.String(handles.EEGPeriodPopupmenu.Value));
            markerPosition = floor(EEGBuffer.Frequency * 0.1);
        end
        if size(plottingData, 1) == 1
            ymode = 2;
        end
    catch
        disp('Plot potential error occurs')
        msgbox('Unable to plot EEG potential', 'Plot Error', 'error');
    end
else
    handles.EEGPeriodPopupmenu.String = strread(num2str(fliplr(1:EEGBuffer.BufferLength)),'%s');
    plottingLength = EEGBuffer.BufferLength;
    plottingPeriod = str2double(handles.EEGPeriodPopupmenu.String(handles.EEGPeriodPopupmenu.Value));
end

if ~isempty(plottingData)
    plotToAxes(handles.EEGAxes, ...
        plottingData, ...
        plottingLabels, ...
        EEGBuffer.Frequency, ...
        plottingLength, ...
        str2double(handles.EEGScalePopupmenu.String(handles.EEGScalePopupmenu.Value)), ...
        plottingPeriod, ...
        ymode);
end

if plotTriggers == true
    try
        triggerSignals = EEGBuffer.TriggerSignals;
        [xCor, values] = handles.inputBuffer.TriggerDecoder.Decode(triggerSignals);
        if ~isempty(xCor) && ~isempty(values)
            plotTriggerToAxes(handles.EEGAxes, xCor, values);
        end
    catch
        disp('Plot triggers error occurs')
        msgbox('Unable to plot triggers', 'Plot Error', 'error');
        plotTriggers = false;
        handles.displayTriggersCheckbox.Value = 0;
    end
end

if plotPotential == true
    line(handles.EEGAxes, [markerPosition markerPosition], handles.EEGAxes.YLim, 'LineStyle' ,'--', 'Color', 'Red');
end
drawnow;

%% Feed data to current source estimator
if isEstimating == true
    handles.CCSEstimator.FeedEEG(EEGBuffer.DataForFilterInput(handles.CCSEstimator.CurrentProfile.EEGChannelNumber));
end

%% Warped Phase Coherence
%handles.warpedPhaseDecoder.FeedEEG(EEGBuffer.Data(handles.EEGChannelListbox.Value,:));
end


function stopReadingInputBufferListener_Callback(src, event, hObject, handles)
%stopReadingInputBufferListener_Callback This function is called when
%input stops reading data from external sensor.
%
%   This function is a member of REC.m controller file.
%
%   This function will be call when the listener is notified of
%   'StopReadingInputBuffer' event.
%
%   'StopReadingInputBuffer' event happens when descendant of 'RECInputBuffer' 
%   abstract class successfully stop reading data from external sensor by 
%   invokeing 'StopReadBuffer' method.
%
%   This function updates GUI related to input buffer according to current
%   state of the program.

global isReadingInputBuffer;
global plotTriggers;
global plotPotential;
isReadingInputBuffer = false;
plotTriggers = false;
plotPotential = false;
handles.eegReadButton.String = 'Start Buffer';
handles.inputModePopupmenu.Enable = 'on';
handles.applyReferenceChannelButton.Enable = 'off';
if handles.inputModePopupmenu.Value ~= 2
    handles.bufferSettingPushbutton.Enable = 'on';
end

handles.displayTriggersCheckbox.Enable = 'off';
handles.displayTriggersCheckbox.Value = 0;
handles.TriggerListbox.Enable = 'off';
handles.displayAveragePotentialCheckbox.Value = 0;

end


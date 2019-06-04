function startReadingInputBufferListener_Callback(src, event, hObject, handles)
%startReadingInputBufferListener_Callback This function is called when
%input starts reading data from external sensor.
%
%   This function is a member of REC.m controller file.
%
%   This function will be call when the listener is notified of
%   'StartReadingInputBuffer' event.
%
%   'StartReadingInputBuffer' event happens when descendant of 'RECInputBuffer' 
%   abstract class successfully start reading data from external sensor by 
%   invokeing 'StartReadBuffer' method.
%
%   This function updates GUI related to input buffer according to current
%   state of the program.

global isReadingInputBuffer;
global EEGBuffer;
isReadingInputBuffer = true;
handles.eegReadButton.String = 'Stop Buffer';
handles.bufferSettingPushbutton.Enable = 'off';
handles.inputModePopupmenu.Enable = 'off';
EEGBuffer = EEGBuffer.ClearPotentialCache();
end


function inputBufferDataUnavailableListener_Callback(src, event, hObject, handles)
%EEGInputError_Callback This function is called when error has occured
%while trying to read data from sensor.
%
%   This function is a member of REC.m controller file.
%
%   This function will be call when the listener is notified of
%   'InputBufferDataUnavailable' event.
%
%   'InputBufferDataUnavailable' event happens when descendant of 'RECInputBuffer' 
%   abstract class failed to read data from external sensor by invokeing
%   'ReadBuffer' method.
%
%   This function cut connection with the external sensor and display a pop
%   up window to inform the user.

disp('EEG input error occurs')
handles.inputBuffer.StopReadBuffer;
msgbox('Unable to read data from input buffer', 'Input Buffer Error', 'error');
end


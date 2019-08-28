function currentSourceUnavailableListener_Callback(src, event, hObject, handles)
%currentSourceUnavailableListener_Callback This function is called when
%'CorticalCurrentSourceEstimator' object failed to properly perform current
%source estimation.
%
%   This function is a member of REC.m controller file.
%
%   This function will be call when the listener is notified of
%   'CurrentSourceUnavailable' event.
%
%   'CurrentSourceUnavailable' event happens when 
%   'CorticalCurrentSourceEstimator' object failed to estimate current
%   source using 'vb_current_calc' function or and unspecified error by 
%   invoking 'FeedEEG' method.
%
%   This function will reset any GUI elements related to current source
%   estimation, and notify the user by showing a pop-up error window.

disp('CCS error occurs')
global isEstimating;
isEstimating = false;
handles.estimatorButton.String = 'Start Estimator';
msgbox('Inverse filter incompatible with incoming EEG', 'Inverse Filter Error', 'error');
end


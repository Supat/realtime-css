function currentProfileSetListener_Callback(src, event, hObject, handles)
%currentProfileSetListener_Callback This function is called when a new profile is set.
%
%   This function is a member of REC.m controller file.
%
%   This function will be call when the listener is notified of
%   'CurrentProfileSet' event.
%
%   'CurrentProfileSet' event happens when 'CorticalCurrentSourceEstimator'
%   object successfully invokes 'ApplyCurrentProfile' method.
%
%   This function updates CCS estimator profile related GUI elements
%   according to 'CorticalCurrentSourceEstimator' object's 'CurrentProfile'
%   property. It also enable 'Start Estimator' button in case the button is
%   being disabled.

handles.currentFilterText.String = handles.CCSEstimator.CurrentProfile.Name;
handles.filterEEGChannelText.String = num2str(handles.CCSEstimator.CurrentProfile.EEGChannelNumber);
handles.filterCCSChannelText.String = num2str(handles.CCSEstimator.CurrentProfile.CCSChannelNumber);
handles.estimatorButton.Enable = 'on';
end


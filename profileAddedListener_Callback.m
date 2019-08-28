function profileAddedListener_Callback(src, event, hObject, handles)
%filterAddedListener_Callback This function is called when a new profile
%file is imported into the program
%
%   This function is a member of REC.m controller file.
%
%   This function will be call when the listener is notified of
%   'NewProfileAdded' event.
%
%   'NewProfileAdded' event happeds when 'CorticalCurrentSourceEstimator'
%   object successfully invokes 'AddProfile' method.
%
%   This function update GUI elements related to profile files stored
%   insisde the program.

disp('New profile added')
if isempty(handles.filterListbox.String)
    handles.filterListbox.String = handles.CCSEstimator.ProfileList(end).Name;
else
    handles.filterListbox.String = char(handles.filterListbox.String, handles.CCSEstimator.ProfileList(end).Name);
end

if ~isempty(handles.filterListbox.String)
    handles.filterListbox.Enable = 'on';
    handles.applyFilterButton.Enable = 'on';
end  
end


function varargout = REC(varargin)
% REC MATLAB code for REC.fig
%      REC, by itself, creates a new REC or raises the existing
%      singleton*.
%
%      H = REC returns the handle to a new REC or the handle to
%      the existing singleton*.
%
%      REC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REC.M with the given input arguments.
%
%      REC('Property','Value',...) creates a new REC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before REC_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to REC_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help REC

% Last Modified by GUIDE v2.5 08-Aug-2018 20:40:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @REC_OpeningFcn, ...
                   'gui_OutputFcn',  @REC_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before REC is made visible.
function REC_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to REC (see VARARGIN)

% Choose default command line output for REC

% Initailize parameter
handles.output = hObject;

handles.TopoWindowHandles = [];
handles.FieldTripSettingHandles = [];
handles.ActiviewSettingHandles = [];

handles.inputBuffer = FieldTripBuffer('localhost', '1972');
handles.startReadingInputBufferListener = addlistener(handles.inputBuffer, 'StartReadingInputBuffer', @(src, event)startReadingInputBufferListener_Callback(src, event, hObject, handles));
handles.stopReadingInputBufferListener = addlistener(handles.inputBuffer, 'StopReadingInputBuffer', @(src, event)stopReadingInputBufferListener_Callback(src, event, hObject, handles));
handles.inputBufferDataAvailableListener = addlistener(handles.inputBuffer, 'InputBufferDataAvailable', @(src, event)inputBufferDataAvailableListener_Callback(src, event, hObject, handles));
handles.inputBufferDataUnavailableListener = addlistener(handles.inputBuffer, 'InputBufferDataUnavailable', @(src, event)inputBufferDataUnavailableListener_Callback(src, event, hObject, handles));
handles.CCSEstimator = CorticalCurrentSourceEstimator();
handles.profileAddedListener = addlistener(handles.CCSEstimator, 'NewProfileAdded', @(src, event)profileAddedListener_Callback(src, event, hObject, handles));
handles.currentProfileSetListener = addlistener(handles.CCSEstimator, 'CurrentProfileSet', @(src, event)currentProfileSetListener_Callback(src, event, hObject, handles));
handles.warpedPhaseDecoder = WarpedPhaseCoherenceDecoder();
%% Temp
handles.phaseLockingValueAvailableListener = addlistener(handles.warpedPhaseDecoder, 'PhaseLockingValueAvailable', @(src, event)phaseLockingValueAvailableListener_Callback(src, event, hObject, handles));
%%
% add paths to subviews
addpath(strcat(pwd, '/VisualizationSubViews'));
addpath(strcat(pwd, '/SettingSubViews'));
addpath(strcat(pwd, '/HelperFunctions'));

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes REC wait for user response (see UIRESUME)
% uiwait(handles.mainFigure);


% --- Outputs from this function are returned to the command line.
function varargout = REC_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in eegReadButton.
function eegReadButton_Callback(hObject, eventdata, handles)
% hObject    handle to eegReadButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('eegReadButton pressed')
global isReadingInputBuffer;
global EEGBuffer;
if isReadingInputBuffer == false
    try
        bufferSize = 10;
        EEGBuffer = EEGSignalBuffer(bufferSize);
        handles.EEGPeriodPopupmenu.String = strread(num2str(fliplr(1:bufferSize)),'%s');
        handles.CCSPeriodPopupmenu.String = strread(num2str(fliplr(1:bufferSize)),'%s');
        handles.EEGReferenceChannelText.String = 'None';
        handles.inputBuffer.StartReadBuffer;
    catch
        disp('Cannot establish EEG buffer');
    end
else
    handles.inputBuffer.StopReadBuffer;
end
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function eegReadButton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eegReadButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global isReadingInputBuffer;
hObject.String = 'Start Buffer';
isReadingInputBuffer = false;



function addressEdit_Callback(hObject, eventdata, handles)
% hObject    handle to addressEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of addressEdit as text
%        str2double(get(hObject,'String')) returns contents of addressEdit as a double


% --- Executes during object creation, after setting all properties.
function addressEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to addressEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.addressString = hObject.String;
guidata(hObject, handles);



function portEdit_Callback(hObject, eventdata, handles)
% hObject    handle to portEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of portEdit as text
%        str2double(get(hObject,'String')) returns contents of portEdit as a double


% --- Executes during object creation, after setting all properties.
function portEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to portEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.portString = hObject.String;
guidata(hObject, handles);


% --- Executes on button press in addFilterButton.
function addFilterButton_Callback(hObject, eventdata, handles)
% hObject    handle to addFilterButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[profileFileName, profilePathName] = uigetfile('*.mat','Select an inverse filter file'); 
if ~isequal(profilePathName, 0) && ~isequal(profileFileName, 0)
    [~, profileName, ~] = fileparts(profileFileName);
    try
        profileVariable = load(strcat(profilePathName, profileFileName), 'profile');
        estimatorProfile = EstimatorProfile(profileName, profileVariable.profile);
        handles.CCSEstimator = handles.CCSEstimator.AddProfile(estimatorProfile);
    catch
        msgbox('Invalid file format for estimator profile', 'Profile Import Error', 'error');
    end
end
guidata(hObject, handles);


% --- Executes on button press in applyFilterButton.
function applyFilterButton_Callback(hObject, eventdata, handles)
% hObject    handle to applyFilterButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.CCSEstimator = handles.CCSEstimator.ApplyCurrentProfile(handles.filterListbox.Value);
guidata(hObject, handles);


% --- Executes on selection change in filterListbox.
function filterListbox_Callback(hObject, eventdata, handles)
% hObject    handle to filterListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns filterListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from filterListbox


% --- Executes during object creation, after setting all properties.
function filterListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filterListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
if isequal(hObject.String, 0)
    hObject.Enable = 'off';
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function applyFilterButton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to applyFilterButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
hObject.Enable = 'off';
guidata(hObject, handles);


% --- Executes on button press in estimatorButton.
function estimatorButton_Callback(hObject, eventdata, handles)
% hObject    handle to estimatorButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of estimatorButton
global isEstimating;
if isEstimating == false
    isEstimating = true;
    handles.estimatorButton.String = 'Stop Estimator';
    handles.currentSourceAvailableListener = addlistener(handles.CCSEstimator, 'CurrentSourceAvailable', @(src, event)currentSourceAvailableListener_Callback(src, event, hObject, handles));
    handles.currentSourceUnavailableListener = addlistener(handles.CCSEstimator, 'CurrentSourceUnavailable', @(src, event)currentSourceUnavailableListener_Callback(src, event, hObject, handles));
else
    isEstimating = false;
    handles.estimatorButton.String = 'Start Estimator';
    delete(handles.currentSourceAvailableListener);
    delete(handles.currentSourceUnavailableListener);
end
guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function estimatorButton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to estimatorButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global isEstimating;
isEstimating = false;
hObject.Enable = 'off';
guidata(hObject, handles);


% --- Executes on selection change in CCSChannelListbox.
function CCSChannelListbox_Callback(hObject, eventdata, handles)
% hObject    handle to CCSChannelListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns CCSChannelListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from CCSChannelListbox


% --- Executes during object creation, after setting all properties.
function CCSChannelListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CCSChannelListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in CCSSelectAllPushbutton.
function CCSSelectAllPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to CCSSelectAllPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.CCSChannelListbox.Value = 1:length(handles.CCSChannelListbox.String);


% --- Executes on selection change in CCSScalePopupmenu.
function CCSScalePopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to CCSScalePopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns CCSScalePopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from CCSScalePopupmenu


% --- Executes during object creation, after setting all properties.
function CCSScalePopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CCSScalePopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in EEGChannelListbox.
function EEGChannelListbox_Callback(hObject, eventdata, handles)
% hObject    handle to EEGChannelListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns EEGChannelListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from EEGChannelListbox


% --- Executes during object creation, after setting all properties.
function EEGChannelListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EEGChannelListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in EEGSelectAllPushbutton.
function EEGSelectAllPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to EEGSelectAllPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.EEGChannelListbox.Value = 1:length(handles.EEGChannelListbox.String);

% --- Executes on selection change in EEGScalePopupmenu.
function EEGScalePopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to EEGScalePopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns EEGScalePopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from EEGScalePopupmenu


% --- Executes during object creation, after setting all properties.
function EEGScalePopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EEGScalePopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object deletion, before destroying properties.
function mainFigure_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to mainFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close mainFigure.
function mainFigure_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to mainFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
global isReadingInputBuffer;
if isReadingInputBuffer
    handles.inputBuffer.StopReadBuffer;
end
if ~isempty(handles.TopoWindowHandles)
    delete(handles.TopoWindowHandles);
end
if ~isempty(handles.FieldTripSettingHandles)
    delete(handles.FieldTripSettingHandles);
end
if ~isempty(handles.ActiviewSettingHandles)
    delete(handles.ActiviewSettingHandles);
end
delete(hObject);


% --- Executes on selection change in CCSPeriodPopupmenu.
function CCSPeriodPopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to CCSPeriodPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns CCSPeriodPopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from CCSPeriodPopupmenu


% --- Executes during object creation, after setting all properties.
function CCSPeriodPopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CCSPeriodPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in EEGPeriodPopupmenu.
function EEGPeriodPopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to EEGPeriodPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns EEGPeriodPopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from EEGPeriodPopupmenu


% --- Executes during object creation, after setting all properties.
function EEGPeriodPopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EEGPeriodPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in EEGReferenceListbox.
function EEGReferenceListbox_Callback(hObject, eventdata, handles)
% hObject    handle to EEGReferenceListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns EEGReferenceListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from EEGReferenceListbox


% --- Executes during object creation, after setting all properties.
function EEGReferenceListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EEGReferenceListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in applyReferenceChannelButton.
function applyReferenceChannelButton_Callback(hObject, eventdata, handles)
% hObject    handle to applyReferenceChannelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of applyReferenceChannelButton
global EEGBuffer;
EEGBuffer.ReferenceChannels = handles.EEGReferenceListbox.Value;
referenceChannelString = char(handles.EEGReferenceListbox.String(EEGBuffer.ReferenceChannels(1)));
for i=2:length(EEGBuffer.ReferenceChannels)
    referenceChannelString = strcat(referenceChannelString, ', ', char(handles.EEGReferenceListbox.String(EEGBuffer.ReferenceChannels(i))));
end
handles.EEGReferenceChannelText.String = referenceChannelString;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function applyReferenceChannelButton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to applyReferenceChannelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
hObject.Enable = 'off';
guidata(hObject, handles);


% --- Executes on selection change in inputModePopupmenu.
function inputModePopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to inputModePopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns inputModePopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from inputModePopupmenu
handles.bufferSettingPushbutton.Enable = 'on';
switch hObject.Value
    case 1
        handles.inputBuffer = FieldTripBuffer('localhost', '1972');
        if ~isempty(handles.FieldTripSettingHandles)
            FTBufferSetting_data = guidata(handles.FieldTripSettingHandles);
            FTBufferSetting_data.addressEdit.String = handles.inputBuffer.Address;
            FTBufferSetting_data.portEdit.String = handles.inputBuffer.Port;
            guidata(handles.FieldTripSettingHandles, FTBufferSetting_data);
        end
    case 2
        handles.bufferSettingPushbutton.Enable = 'off';
        handles.inputBuffer = LSLInputBuffer();
    case 3
        handles.inputBuffer = ActiviewInputBuffer('127.0.0.1', 8888, 4, true, false, false, false, false, 4096);
        if ~isempty(handles.ActiviewSettingHandles)
            ActiviewSetting_data = guidata(handles.ActiviewSettingHandles);
            ActiviewSetting_data.addressEdit.String = handles.inputBuffer.Address;
            ActiviewSetting_data.portEdit.String = num2str(handles.inputBuffer.Port);
            ActiviewSetting_data.channelCountEdit.String = num2str(handles.inputBuffer.ChannelCount);
            ActiviewSetting_data.frequencyEdit.String = num2str(handles.inputBuffer.Frequency);
            guidata(handles.ActiviewSettingHandles, ActiviewSetting_data);
        end
end
handles.startReadingInputBufferListener = addlistener(handles.inputBuffer, 'StartReadingInputBuffer', @(src, event)startReadingInputBufferListener_Callback(src, event, hObject, handles));
handles.stopReadingInputBufferListener = addlistener(handles.inputBuffer, 'StopReadingInputBuffer', @(src, event)stopReadingInputBufferListener_Callback(src, event, hObject, handles));
handles.inputBufferDataAvailableListener = addlistener(handles.inputBuffer, 'InputBufferDataAvailable', @(src, event)inputBufferDataAvailableListener_Callback(src, event, hObject, handles));
handles.inputBufferDataUnavailableListener = addlistener(handles.inputBuffer, 'InputBufferDataUnavailable', @(src, event)inputBufferDataUnavailableListener_Callback(src, event, hObject, handles));
    
guidata(hObject, handles);



function EEGLowCutoffEdit_Callback(hObject, eventdata, handles)
% hObject    handle to EEGLowCutoffEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EEGLowCutoffEdit as text
%        str2double(get(hObject,'String')) returns contents of EEGLowCutoffEdit as a double
global EEGBuffer;
EEGBuffer.LowPassband = str2double(hObject.String);

% --- Executes during object creation, after setting all properties.
function EEGLowCutoffEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EEGLowCutoffEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EEGHighCutoffEdit_Callback(hObject, eventdata, handles)
% hObject    handle to EEGHighCutoffEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EEGHighCutoffEdit as text
%        str2double(get(hObject,'String')) returns contents of EEGHighCutoffEdit as a double
global EEGBuffer;
EEGBuffer.HighPassband = str2double(hObject.String);


% --- Executes during object creation, after setting all properties.
function EEGHighCutoffEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EEGHighCutoffEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plotFilteredCheckbox.
function plotFilteredCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to plotFilteredCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotFilteredCheckbox
global plotFilteredSignal;
if hObject.Value == 0 
    plotFilteredSignal = false;
else
    plotFilteredSignal = true;
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function plotFilteredCheckbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotFilteredCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global plotFilteredSignal;
hObject.Value = 0;
plotFilteredSignal = false;
guidata(hObject, handles);


% --- Executes on button press in topographicButton.
function topographicButton_Callback(hObject, eventdata, handles)
% hObject    handle to topographicButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of topographicButton
if isempty(handles.TopoWindowHandles)
    handles.TopoWindowHandles = TopoPlot;
    TopoWindow_data = guidata(handles.TopoWindowHandles);
    TopoWindow_data.RECWindowHandle = hObject.Parent;
    guidata(handles.TopoWindowHandles, TopoWindow_data);
%     handles.topoCurrentSourceAvailableListener = addlistener(handles.CCSEstimator, 'CurrentSourceAvailable', @(src, event)topoCurrentSourceAvailableListener_Callback(src, event, hObject, handles));
end

% if ~isempty(handles.TopoWindowHandles)
% %     TopoWindow_data = guidata(handles.TopoWindowHandles);
% %     TopoWindow_data.text2.String = 'Aha';   
% end

guidata(hObject, handles);


% --- Executes on button press in bufferSettingPushbutton.
function bufferSettingPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to bufferSettingPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch handles.inputModePopupmenu.Value
    case 1
        if isempty(handles.FieldTripSettingHandles)
            handles.FieldTripSettingHandles = FieldTripSetting;
            FTBufferSetting_data = guidata(handles.FieldTripSettingHandles);
            FTBufferSetting_data.RECWindowHandle = hObject.Parent;
            guidata(handles.FieldTripSettingHandles, FTBufferSetting_data);
        end
    case 3
        if isempty(handles.ActiviewSettingHandles)
            handles.ActiviewSettingHandles = ActiviewSetting;
            ActiviewSetting_data = guidata(handles.ActiviewSettingHandles);
            ActiviewSetting_data.RECWindowHandle = hObject.Parent;
            guidata(handles.ActiviewSettingHandles, ActiviewSetting_data);
        end
        
end
guidata(hObject, handles);


% --- Executes on button press in displayAverageCheckbox.
function displayAverageCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to displayAverageCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of displayAverageCheckbox
global plotAverageSignal;
if hObject.Value == 0 
    plotAverageSignal = false;
else
    plotAverageSignal = true;
end
guidata(hObject, handles);


% --- Executes on selection change in TriggerListbox.
function TriggerListbox_Callback(hObject, eventdata, handles)
% hObject    handle to TriggerListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns TriggerListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from TriggerListbox


% --- Executes during object creation, after setting all properties.
function TriggerListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TriggerListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in displayTriggersCheckbox.
function displayTriggersCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to displayTriggersCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of displayTriggersCheckbox
global plotTriggers;
if hObject.Value == 0 
    plotTriggers = false;
else
    plotTriggers = true;
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function displayAverageCheckbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to displayAverageCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global plotAverageSignal;
hObject.Value = 0;
plotAverageSignal = false;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function displayTriggersCheckbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to displayTriggersCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global plotTriggers;
hObject.Value = 0;
hObject.Enable = 'off';
plotTriggers = false;
guidata(hObject, handles);



function TriggerValueEdit_Callback(hObject, eventdata, handles)
% hObject    handle to TriggerValueEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TriggerValueEdit as text
%        str2double(get(hObject,'String')) returns contents of TriggerValueEdit as a double


% --- Executes during object creation, after setting all properties.
function TriggerValueEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TriggerValueEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
hObject.String = 0;
guidata(hObject, handles);


% --- Executes on button press in displayAveragePotentialCheckbox.
function displayAveragePotentialCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to displayAveragePotentialCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of displayAveragePotentialCheckbox
global plotPotential;
if hObject.Value == 0 
    plotPotential = false;
else
    plotPotential = true;
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function displayAveragePotentialCheckbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to displayAveragePotentialCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global plotPotential;
hObject.Value = 0;
hObject.Enable = 'off';
plotPotential = false;
guidata(hObject, handles);


% --- Executes on button press in plotReferencedCheckbox.
function plotReferencedCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to plotReferencedCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotReferencedCheckbox
global plotReferencedSignal;
if hObject.Value == 0 
    plotReferencedSignal = false;
else
    plotReferencedSignal = true;
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function plotReferencedCheckbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotReferencedCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global plotReferencedSignal;
hObject.Value = 0;
hObject.Enable = 'on';
plotReferencedSignal = false;
guidata(hObject, handles);

function varargout = ActiviewSetting(varargin)
% ACTIVIEWSETTING MATLAB code for ActiviewSetting.fig
%      ACTIVIEWSETTING, by itself, creates a new ACTIVIEWSETTING or raises the existing
%      singleton*.
%
%      H = ACTIVIEWSETTING returns the handle to a new ACTIVIEWSETTING or the handle to
%      the existing singleton*.
%
%      ACTIVIEWSETTING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ACTIVIEWSETTING.M with the given input arguments.
%
%      ACTIVIEWSETTING('Property','Value',...) creates a new ACTIVIEWSETTING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ActiviewSetting_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ActiviewSetting_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ActiviewSetting

% Last Modified by GUIDE v2.5 02-Aug-2018 15:14:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ActiviewSetting_OpeningFcn, ...
                   'gui_OutputFcn',  @ActiviewSetting_OutputFcn, ...
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


% --- Executes just before ActiviewSetting is made visible.
function ActiviewSetting_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ActiviewSetting (see VARARGIN)

% Choose default command line output for ActiviewSetting
handles.output = hObject;

RECFigure = findobj(0, 'tag', 'mainFigure');
RECWindowHandles = guidata(RECFigure);
handles.mainWindowHandles = RECWindowHandles;
handles.addressEdit.String = RECWindowHandles.inputBuffer.Address;
handles.portEdit.String = num2str(RECWindowHandles.inputBuffer.Port);
handles.channelCountPopupmenu.Value = RECWindowHandles.inputBuffer.ChannelOption;
handles.frequencyEdit.String = num2str(RECWindowHandles.inputBuffer.Frequency);
handles.triggerBitLengthEdit.String = num2str(RECWindowHandles.inputBuffer.TriggerBitLength);

if RECWindowHandles.inputBuffer.UsingEXChannel
    handles.EXCheckbox.Value = 1;
else
    handles.EXCheckbox.Value = 0;
end
if RECWindowHandles.inputBuffer.UsingSensorsChannel
    handles.sensorsCheckbox.Value = 1;
else
    handles.sensorsCheckbox.Value = 0;
end
if RECWindowHandles.inputBuffer.UsingJazzChannel
    handles.jazzCheckbox.Value = 1;
else
    handles.jazzCheckbox.Value = 0;
end
if RECWindowHandles.inputBuffer.UsingAIBChannel
    handles.AIBCheckbox.Value = 1;
else
    handles.AIBCheckbox.Value = 0;
end
if RECWindowHandles.inputBuffer.UsingTriggerChannel
    handles.triggerCheckbox.Value = 1;
else
    handles.triggerCheckbox.Value = 0;
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ActiviewSetting wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ActiviewSetting_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



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



function channelCountPopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to channelCountPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of channelCountPopupmenu as text
%        str2double(get(hObject,'String')) returns contents of channelCountPopupmenu as a double


% --- Executes during object creation, after setting all properties.
function channelCountPopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channelCountPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function frequencyEdit_Callback(hObject, eventdata, handles)
% hObject    handle to frequencyEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frequencyEdit as text
%        str2double(get(hObject,'String')) returns contents of frequencyEdit as a double


% --- Executes during object creation, after setting all properties.
function frequencyEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frequencyEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in savePushbutton.
function savePushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to savePushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.mainWindowHandles.inputBuffer.Address = handles.addressEdit.String;
handles.mainWindowHandles.inputBuffer.Port = str2double(handles.portEdit.String);
handles.mainWindowHandles.inputBuffer.ChannelOption = handles.channelCountPopupmenu.Value;
handles.mainWindowHandles.inputBuffer.Frequency = str2double(handles.frequencyEdit.String);
handles.mainWindowHandles.inputBuffer.TriggerBitLength = str2double(handles.triggerBitLengthEdit.String);

if handles.EXCheckbox.Value == 1
    handles.mainWindowHandles.inputBuffer.UsingEXChannel = true;
else
    handles.mainWindowHandles.inputBuffer.UsingEXChannel = false;
end
if handles.sensorsCheckbox.Value == 1
    handles.mainWindowHandles.inputBuffer.UsingSensorsChannel = true;
else
    handles.mainWindowHandles.inputBuffer.UsingSensorsChannel = false;
end
if handles.jazzCheckbox.Value == 1
    handles.mainWindowHandles.inputBuffer.UsingJazzChannel = true;
else
    handles.mainWindowHandles.inputBuffer.UsingJazzChannel = false;
end
if handles.AIBCheckbox.Value == 1
    handles.mainWindowHandles.inputBuffer.UsingAIBChannel = true;
else
    handles.mainWindowHandles.inputBuffer.UsingAIBChannel = false;
end
if handles.triggerCheckbox.Value == 1
    handles.mainWindowHandles.inputBuffer.UsingTriggerChannel = true;
else
    handles.mainWindowHandles.inputBuffer.UsingTriggerChannel = false;
end



% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
RECFigure = findobj(0, 'tag', 'mainFigure');
RECWindowHandles = guidata(RECFigure);
RECWindowHandles.ActiviewSettingHandles = [];
guidata(RECFigure, RECWindowHandles);
delete(hObject);


% --- Executes on button press in EXCheckbox.
function EXCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to EXCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of EXCheckbox


% --- Executes on button press in sensorsCheckbox.
function sensorsCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to sensorsCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sensorsCheckbox


% --- Executes on button press in jazzCheckbox.
function jazzCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to jazzCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of jazzCheckbox


% --- Executes on button press in AIBCheckbox.
function AIBCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to AIBCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AIBCheckbox


% --- Executes on button press in triggerCheckbox.
function triggerCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to triggerCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of triggerCheckbox



function triggerBitLengthEdit_Callback(hObject, eventdata, handles)
% hObject    handle to triggerBitLengthEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of triggerBitLengthEdit as text
%        str2double(get(hObject,'String')) returns contents of triggerBitLengthEdit as a double


% --- Executes during object creation, after setting all properties.
function triggerBitLengthEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to triggerBitLengthEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

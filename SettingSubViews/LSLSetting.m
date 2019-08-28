function varargout = LSLSetting(varargin)
% LSLSETTING MATLAB code for LSLSetting.fig
%      LSLSETTING, by itself, creates a new LSLSETTING or raises the existing
%      singleton*.
%
%      H = LSLSETTING returns the handle to a new LSLSETTING or the handle to
%      the existing singleton*.
%
%      LSLSETTING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LSLSETTING.M with the given input arguments.
%
%      LSLSETTING('Property','Value',...) creates a new LSLSETTING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LSLSetting_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LSLSetting_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LSLSetting

% Last Modified by GUIDE v2.5 28-Aug-2019 20:26:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LSLSetting_OpeningFcn, ...
                   'gui_OutputFcn',  @LSLSetting_OutputFcn, ...
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


% --- Executes just before LSLSetting is made visible.
function LSLSetting_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LSLSetting (see VARARGIN)

% Choose default command line output for LSLSetting
handles.output = hObject;

RECFigure = findobj(0, 'tag', 'mainFigure');
RECWindowHandles = guidata(RECFigure);
handles.mainWindowHandles = RECWindowHandles;
handles.triggerBitLengthEdit.String = num2str(RECWindowHandles.inputBuffer.TriggerBitLength);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LSLSetting wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LSLSetting_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in savePushbutton.
function savePushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to savePushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.mainWindowHandles.inputBuffer.TriggerBitLength = str2double(handles.triggerBitLengthEdit.String);



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


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
RECFigure = findobj(0, 'tag', 'mainFigure');
RECWindowHandles = guidata(RECFigure);
RECWindowHandles.LSLSettingHandles = [];
guidata(RECFigure, RECWindowHandles);
delete(hObject);

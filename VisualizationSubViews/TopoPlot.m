function varargout = TopoPlot(varargin)
% TOPOPLOT MATLAB code for TopoPlot.fig
%      TOPOPLOT, by itself, creates a new TOPOPLOT or raises the existing
%      singleton*.
%
%      H = TOPOPLOT returns the handle to a new TOPOPLOT or the handle to
%      the existing singleton*.
%
%      TOPOPLOT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TOPOPLOT.M with the given input arguments.
%
%      TOPOPLOT('Property','Value',...) creates a new TOPOPLOT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TopoPlot_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TopoPlot_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TopoPlot

% Last Modified by GUIDE v2.5 09-Nov-2017 15:06:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TopoPlot_OpeningFcn, ...
                   'gui_OutputFcn',  @TopoPlot_OutputFcn, ...
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


% --- Executes just before TopoPlot is made visible.
function TopoPlot_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TopoPlot (see VARARGIN)

% Choose default command line output for TopoPlot
handles.output = hObject;

RECFigure = findobj(0, 'tag', 'mainFigure');
RECWindowHandles = guidata(RECFigure);
handles.mainWindowHandles = RECWindowHandles;
handles.topoCurrentSourceAvailableListener = addlistener(RECWindowHandles.CCSEstimator, 'CurrentSourceAvailable', @(src, event)topoCurrentSourceAvailableListener_Callback(src, event, hObject, handles));

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TopoPlot wait for user response (see UIRESUME)
% uiwait(handles.topographicFigure);


% --- Outputs from this function are returned to the command line.
function varargout = TopoPlot_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object deletion, before destroying properties.
function topographicFigure_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to topographicFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% RECFigure = findobj(0, 'tag', 'mainFigure');
% RECWindowHandle = guidata(RECFigure);
% RECWindowHandle.TopoWindowHandle = [];
% guidata(RECFigure, RECWindowHandle);
guidata(hObject, handles);



function topoplotLowerRangeEdit_Callback(hObject, eventdata, handles)
% hObject    handle to topoplotLowerRangeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of topoplotLowerRangeEdit as text
%        str2double(get(hObject,'String')) returns contents of topoplotLowerRangeEdit as a double


% --- Executes during object creation, after setting all properties.
function topoplotLowerRangeEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to topoplotLowerRangeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function topoplotUpperRangeEdit_Callback(hObject, eventdata, handles)
% hObject    handle to topoplotUpperRangeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of topoplotUpperRangeEdit as text
%        str2double(get(hObject,'String')) returns contents of topoplotUpperRangeEdit as a double


% --- Executes during object creation, after setting all properties.
function topoplotUpperRangeEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to topoplotUpperRangeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in topoplotOrientationPopupmenu.
function topoplotOrientationPopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to topoplotOrientationPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns topoplotOrientationPopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from topoplotOrientationPopupmenu


% --- Executes during object creation, after setting all properties.
function topoplotOrientationPopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to topoplotOrientationPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function topoplotThresholdEdit_Callback(hObject, eventdata, handles)
% hObject    handle to topoplotThresholdEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of topoplotThresholdEdit as text
%        str2double(get(hObject,'String')) returns contents of topoplotThresholdEdit as a double


% --- Executes during object creation, after setting all properties.
function topoplotThresholdEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to topoplotThresholdEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close topographicFigure.
function topographicFigure_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to topographicFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
RECFigure = findobj(0, 'tag', 'mainFigure');
RECWindowHandles = guidata(RECFigure);
RECWindowHandles.TopoWindowHandles = [];
guidata(RECFigure, RECWindowHandles);
delete(handles.topoCurrentSourceAvailableListener);
delete(hObject);

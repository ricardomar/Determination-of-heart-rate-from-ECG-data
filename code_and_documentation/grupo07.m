function varargout = grupo07(varargin)

global fullpath;

% GRUPO07 M-file for grupo07.fig
%      GRUPO07, by itself, creates a new GRUPO07 or raises the existing
%      singleton*.
%
%      H = GRUPO07 returns the handle to a new GRUPO07 or the handle to
%      the existing singleton*.
%
%      GRUPO07('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GRUPO07.M with the given input arguments.
%
%      GRUPO07('Property','Value',...) creates a new GRUPO07 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before grupo07_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to grupo07_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help grupo07

% Last Modified by GUIDE v2.5 02-Jan-2008 11:12:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @grupo07_OpeningFcn, ...
                   'gui_OutputFcn',  @grupo07_OutputFcn, ...
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


% --- Executes just before grupo07 is made visible.
function grupo07_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to grupo07 (see VARARGIN)

% Choose default command line output for grupo07
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes grupo07 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = grupo07_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text8,'String','');
set(handles.text9,'String','');
set(handles.text10,'String','');



[name,path]=uigetfile('*.dat');
global fullpath;
fullpath = [path,name];
set(handles.text13,'String',fullpath);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global fullpath;
[duracao,numBatimentos,ritmo]=offline(fullpath);
set(handles.text8,'String',num2str(duracao));
set(handles.text9,'String',num2str(numBatimentos));
set(handles.text10,'String',num2str(ritmo));



% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global fullpath;
online(fullpath);

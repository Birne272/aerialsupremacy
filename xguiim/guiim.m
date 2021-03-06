function varargout = guiim(varargin)
% GUIIM MATLAB code for guiim.fig
%      GUIIM, by itself, creates a new GUIIM or raises the existing
%      singleton*.
%
%      H = GUIIM returns the handle to a new GUIIM or the handle to
%      the existing singleton*.
%
%      GUIIM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIIM.M with the given input arguments.
%
%      GUIIM('Property','Value',...) creates a new GUIIM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guiim_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guiim_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guiim

% Last Modified by GUIDE v2.5 08-Jun-2012 22:47:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guiim_OpeningFcn, ...
                   'gui_OutputFcn',  @guiim_OutputFcn, ...
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


% --- Executes just before guiim is made visible.
function guiim_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guiim (see VARARGIN)

% Choose default command line output for guiim
handles.output = hObject;

pause on;
clc;
%resources 
addpath(genpath('resources/'))

%char encoding
slCharacterEncoding('ISO-8859-1');


%RotateButton
I=imread('rot90.png');
set(handles.rotm90button,'CData',I);
I=imread('rotm90.png');
set(handles.rot90button,'CData',I);
  

  
%Side HEADER
axes(handles.sider);
%I=imread('sidergraksa.png');
I=imread('sideroff.png');
imshow(I);


%Initializing Survelliance
axes(handles.image);
handles.imdata = rgb2gray(imread('square.png'));
handles.imdataOrig = handles.imdata;
%handles.imHandle = imshow(handles.imdata);
imshow(handles.imdata);



% Update handles structure
guidata(hObject, handles);

% UIWAIT makes guiim wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guiim_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function fnamesel_Callback(hObject, eventdata, handles)
% hObject    handle to fnamesel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fnamesel as text
%        str2double(get(hObject,'String')) returns contents of fnamesel as a double


% --- Executes during object creation, after setting all properties.
function fnamesel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fnamesel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in fnamebutton.
function fnamebutton_Callback(hObject, eventdata, handles)
% hObject    handle to fnamebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fname = get(handles.fnamesel, 'String');
% keyboard;
fp= fopen([fname]);
if (fp > 0)
	fclose(fp);
	handles.imdata = imageFromFile(fname);
	handles.imdataOrig = handles.imdata;
	imshow(handles.imdata);
end

guidata(hObject, handles);

% --- Executes on slider movement.
function bslider_Callback(hObject, eventdata, handles)
% hObject    handle to bslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
axes(handles.image);
contrast=(get(handles.cslider,'Value')-5)/5;
brightness=(get(handles.bslider,'Value')-5)/5;
handles.imdata = changeBrightness(handles.imdataOrig,contrast,brightness);
imshow(handles.imdata);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function bslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in hebutton.
function hebutton_Callback(hObject, eventdata, handles)
% hObject    handle to hebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.image);
handles.imdata=adapthisteq(handles.imdata);
imshow(handles.imdata);

guidata(hObject, handles);


% --- Executes on slider movement.
function cslider_Callback(hObject, eventdata, handles)
% hObject    handle to cslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
axes(handles.image);
contrast=(get(handles.cslider,'Value')-5)/5;
brightness=(get(handles.bslider,'Value')-5)/5;
handles.imdata = changeBrightness(handles.imdataOrig,contrast,brightness);
imshow(handles.imdata);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function cslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes on button press in savebutton.
function savebutton_Callback(hObject, eventdata, handles)
% hObject    handle to savebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] =  uiputfile({'*.png'},'Save as');
fname = [pathname filename];
imwrite(handles.imdata,fname,'png');

% --- Executes on button press in imreset.
function imreset_Callback(hObject, eventdata, handles)
% hObject    handle to imreset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.image);
handles.imdata = handles.imdataOrig;
imshow(handles.imdata);
set(handles.cslider,'Value',5)
set(handles.bslider,'Value',5)
guidata(hObject, handles);


% --- Executes on button press in rot90button.
function rot90button_Callback(hObject, eventdata, handles)
% hObject    handle to rot90button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.image);
%keyboard;
handles.imdata = imrotate(handles.imdata,90,'bilinear');
handles.imdataOrig = imrotate(handles.imdataOrig,90,'bilinear');
imshow(handles.imdata);
guidata(hObject, handles);


% --- Executes on button press in rotm90button.
function rotm90button_Callback(hObject, eventdata, handles)
% hObject    handle to rotm90button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.image);
%keyboard;
handles.imdata = imrotate(handles.imdata,-90,'bilinear');
handles.imdataOrig = imrotate(handles.imdataOrig,-90,'bilinear');
imshow(handles.imdata);
guidata(hObject, handles);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over fnamesel.
function fnamesel_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to fnamesel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] =  uigetfile({'*.log';'*.*'},'Select surveillance log');
set(handles.fnamesel, 'String', [ pathname filename]);
%keyboard;

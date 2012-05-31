function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 30-May-2012 02:14:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)
% Choose default command line output for gui
handles.output = hObject;

pause on;

%resources 
addpath(genpath('resources/'))

%char encoding
slCharacterEncoding('ISO-8859-1');


%global
handles.isrunning = 0;

%terminal 

enquestr('',1,9,'termbuf');

%Initializing Realterm Active X Server
handles.hrealterm=actxserver('realterm.realtermintf'); 
handles.hrealterm.baud=9600;
handles.hrealterm.caption='Matlab Realterm Server';
handles.hrealterm.windowstate=0; 
handles.hrealterm.halfduplex=1;
handles.hrealterm.displayas= 0;
handles.isConnected = 0;
%0 normal 1 minimized


%Initializing Survelliance
axes(handles.image);
handles.imdata = rgb2gray(imread('square.png'));
%handles.imHandle = imshow(handles.imdata);
imshow(handles.imdata);
set(handles.debug,'string',enquestr('Survelliance Initialized'));
set(handles.ImageStatus,'string','0.0%');
set(handles.imtime,'string','0.00');

%Initializing Compas
%set(gcf,'renderer','opengl');
opengl software;
axes(handles.compass);
handles.cmpd = imread('cmpd.png');
cmps = imread('cmps.png');

hold on;
handles.cmps = imshow(handles.cmpd);
H2=imshow(cmps);
hold off;
%keyboard;
[row col c] = size(cmps);
AMap = ones(row,col);
x=0;
for i=1:row
	for j=1:col
		if ((cmps(i,j,1)==0)&&(cmps(i,j,2)==168)&&(cmps(i,j,3)==89))
			AMap(i,j) = 0;
		end
	end
end
set(H2, 'AlphaData', AMap);
axis image;
set(handles.debug,'string',enquestr('Compass Initialized'));
%keyboard;

%Initializing AccGraph
axes(handles.acc);
handles.ncell = 200;
handles.accX = zeros(handles.ncell ,1);  
handles.accY = zeros(handles.ncell ,1);
handles.accZ = zeros(handles.ncell ,1);
hold on;
handles.HX = plot (handles.accX,'r-');   
handles.HY = plot (handles.accY,'g-'); 
handles.HZ = plot (handles.accZ,'b-');  
hold off;
%legend('AccX','AccY','AccZ'); 

%MAX AXIS
handles.maxY = 10;
axis([0 handles.ncell -handles.maxY handles.maxY]);

set(gca,'XTickMode','manual');
set(gca,'XTick',getTickX(handles.ncell,5));
set(gca,'YTickMode','manual');
%-500 250 0 250 500
set(gca,'YTick',getTickY(handles.maxY, 2));

xlabel('Time (x10 ms)');
ylabel('Acceleration (x0.1 m/s^2)'); 
grid on;

set(handles.debug,'string',enquestr('Acceleration Graph Initialized'));


%Initializing Model 3D
axes(handles.model3d);
[F, V, C] = rndread('roket.stl');
handles.rpatch = patch('faces', F, 'vertices' ,V);
set(handles.rpatch, 'facec', 'r');              % Set the face color (force it)
set(handles.rpatch, 'facec', 'flat');            % Set the face color flat
set(handles.rpatch, 'FaceVertexCData', C);       % Set the color (from file)
%set(handles.rpatch, 'facealpha',.4)             % Use for transparency
set(handles.rpatch, 'EdgeColor','none');         % Set the edge color
%set(handles.rpatch, 'EdgeColor',[1 0 0 ]);      % Use to see triangles, if needed.
light;                               % add a default light
daspect([1 1 1]) ;                   % Setting the aspect ratio
view(3);                            % Isometric view
set(gca,'xtick',[]);  
set(gca,'ytick',[]); 
set(gca,'ztick',[]); 
V = V';
V = [V(1,:); V(2,:); V(3,:); ones(1,length(V))];
vsize = maxv(V); %attempt to determine the maximum xyz vertex. 
drawnow;
axis([-vsize vsize -vsize vsize -vsize vsize]);
V=V*1.5;
%V=rx(90)*V;
set(handles.rpatch,'Vertices',V(1:3,:)');   
drawnow;
handles.roketvertex=V;

set(handles.debug,'string',enquestr('Model 3D Initialized'));

%xlabel('X'),ylabel('Y'),zlabel('Z')

%keyboard;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
	strtemp=sprintf('Trying to close program... ');
	set(handles.debug,'string',enquestr(strtemp));
	if (handles.isConnected)
		error('COM port still opened');
	end
	strtemp=sprintf('Trying to close realterm... ');
	set(handles.debug,'string',enquestr(strtemp));
	invoke(handles.hrealterm,'close'); 
	strtemp=sprintf('Success !');
	set(handles.debug,'string',enquestr(strtemp));
	%delete(handles.hrealterm);
	a=fix(clock);
	fname = sprintf('ter%02d%02d_%02d%02d.log',a(3),a(2),a(4),a(5));
	copyfile('termbuf',fname);
	movefile(fname,'log\term\');
	strtemp=sprintf('Terminal log saved as log/cam/%s',fname);
	set(handles.debug,'string',enquestr(strtemp));
	
	enquestr('','','','','');
	
	% Hint: delete(hObject) closes the figure
	delete(hObject);
catch ex
	strtemp=sprintf('ERROR : %s',ex.message);
	set(handles.debug,'string',enquestr(strtemp));
end; %try





function comport_Callback(hObject, eventdata, handles)
% hObject    handle to comport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of comport as text
%        str2double(get(hObject,'String')) returns contents of comport as a double


% --- Executes during object creation, after setting all properties.
function comport_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in commandlist.
function commandlist_Callback(hObject, eventdata, handles)
% hObject    handle to commandlist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns commandlist contents as cell array
%        contents{get(hObject,'Value')} returns selected item from commandlist


% --- Executes during object creation, after setting all properties.
function commandlist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to commandlist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in commandlist.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to commandlist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns commandlist contents as cell array
%        contents{get(hObject,'Value')} returns selected item from commandlist


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to commandlist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in commandbutton.
function commandbutton_Callback(hObject, eventdata, handles)
% hObject    handle to commandbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
	if (~handles.isConnected)
		error('Not connected to any COM port');
	end
catch ex
	strtemp=sprintf('ERROR : %s',ex.message);
	set(handles.debug,'string',enquestr(strtemp));
end

	command_list = get(handles.commandlist,'String');
	command_val = get(handles.commandlist,'Value');
	command_cur=command_list{command_val};
	strtemp=sprintf('Trying to send Command [%s]... ',command_cur);
	set(handles.debug,'string',enquestr(strtemp));
	%  command_val
	% 1 Start Atittude Monitoring Mode
	% 2 Start Surveillance Mode
	% 3 Halt All Data Transmission
	handles.isrunning = 1;
	guidata(hObject, handles);	
	switch command_val
		case 1
			% Atittude Monitoring Mode
			invoke(handles.hrealterm,'ClearTerminal');
			handles.hrealterm.PutString('bbbbb');
			strtemp=sprintf('Success! Command [%s] sent. ',command_cur);
			set(handles.debug,'string',enquestr(strtemp));
			
			tic;
			AtMon(hObject, eventdata, handles);
			
		case 2
			% Surveillance Mode
			invoke(handles.hrealterm,'ClearTerminal'); 
			handles.hrealterm.PutString('aaaaa');
			strtemp=sprintf('Success! Command [%s] sent. ',command_cur);
			set(handles.debug,'string',enquestr(strtemp));
			drawnow;
			
			tic;
			ImageCapture(hObject, eventdata, handles);
			
		case 3
			handles.isrunning = 0;
			guidata(hObject, handles);	
			% Halt All Data Transmission 
			invoke(handles.hrealterm,'ClearTerminal');
			handles.hrealterm.PutString('#####');	
			strtemp=sprintf('Success! Command [%s] sent. ',command_cur);
			set(handles.debug,'string',enquestr(strtemp));
			
	end
	%handles.isrunning = 0;	
	%guidata(hObject, handles);	




% --- Executes on button press in rot90button.
function rot90button_Callback(hObject, eventdata, handles)
% hObject    handle to rot90button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.image);
%keyboard;
handles.imdata = imrotate(handles.imdata,90,'bilinear');
imshow(handles.imdata);

strtemp=sprintf('Picture has been rotated by -90 degrees');
set(handles.debug,'string',enquestr(strtemp));

guidata(hObject, handles);

% --- Executes on button press in rotm90button.
function rotm90button_Callback(hObject, eventdata, handles)
% hObject    handle to rotm90button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.image);
%keyboard;
handles.imdata = imrotate(handles.imdata,-90,'bilinear');
imshow(handles.imdata);

strtemp=sprintf('Picture has been rotated by 90 degrees');
set(handles.debug,'string',enquestr(strtemp));

guidata(hObject, handles);

% --- Executes on button press in savebutton.
function savebutton_Callback(hObject, eventdata, handles)
% hObject    handle to savebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=fix(clock);
fname = sprintf('cam%02d%02d_%02d%02d.png',a(3),a(2),a(4),a(5));
imwrite(handles.imdata,fname,'png');
movefile(fname,'savedpic\')
strtemp=sprintf('Picture saved as savedpic/%s',fname);
set(handles.debug,'string',enquestr(strtemp));



% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in connect_button.
function connect_button_Callback(hObject, eventdata, handles)
% hObject    handle to connect_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
	TargetPort = get(handles.comport,'String');
	[portVal, status] = str2num(TargetPort);
	if(~status)
		error('COM Port not valid');
	end
	if(portVal<0)
		error('COM Port must be an integer');
	end
		
	if(~handles.isConnected)
		strtemp=sprintf('Trying to open COM%d..',portVal);
		set(handles.debug,'string',enquestr(strtemp));
		handles.TargetPort = portVal;
		handles.hrealterm.Port = sprintf('%d',handles.TargetPort);
		handles.hrealterm.PortOpen=1; 
		handles.isConnected = (handles.hrealterm.PortOpen~=0);
		strtemp=sprintf('Success!');
		set(handles.debug,'string',enquestr(strtemp));
	else
		strtemp=sprintf('Trying to close COM%d..',portVal);
		set(handles.debug,'string',enquestr(strtemp));
		if(handles.isrunning)
			error('COM port in use.');
		end		
		handles.hrealterm.PortOpen=0; 
		handles.isConnected = (handles.hrealterm.PortOpen~=0);
		strtemp=sprintf('Success!');
		set(handles.debug,'string',enquestr(strtemp));
	end
	
catch ex
	handle.isConnected = 0;
	%keyboard;
	if(~isempty(strfind(ex.message,'comport doesn''t exist')))
		strtemp='ERROR : COM port doesn''t exist';
	elseif(~isempty(strfind(ex.message,'device already open')))
		strtemp='ERROR : COM port already in use';
	else
		strtemp=sprintf('ERROR : %s',ex.message);
	end
	set(handles.debug,'string',enquestr(strtemp));
end

if (handles.isConnected)
	set(handles.comport,'Enable','off')
	set(handles.comstatus,'String','Connected');
	set(handles.comstatus,'ForeGroundcolor','green');
	set(hObject,'String','Disconnect');
else
	set(handles.comport,'Enable','off');
	set(handles.comstatus,'String','Not Connected');
	set(handles.comstatus,'ForeGroundcolor','red');
	set(handles.comport,'Enable','on');
	set(hObject,'String','Connect');
end

guidata(hObject, handles);

% --- Executes on slider movement.
function AccSlider_Callback(hObject, eventdata, handles)
% hObject    handle to AccSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
AccSliderCB( hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function AccSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AccSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

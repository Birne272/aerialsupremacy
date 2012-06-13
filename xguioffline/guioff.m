function varargout = guioff(varargin)
% GUIOFF MATLAB code for guioff.fig
%      GUIOFF, by itself, creates a new GUIOFF or raises the existing
%      singleton*.
%
%      H = GUIOFF returns the handle to a new GUIOFF or the handle to
%      the existing singleton*.
%
%      GUIOFF('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIOFF.M with the given input arguments.
%
%      GUIOFF('Property','Value',...) creates a new GUIOFF or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guioff_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guioff_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guioff

% Last Modified by GUIDE v2.5 09-Jun-2012 20:52:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guioff_OpeningFcn, ...
                   'gui_OutputFcn',  @guioff_OutputFcn, ...
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


% --- Executes just before guioff is made visible.
function guioff_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guioff (see VARARGIN)

% Choose default command line output for guioff
handles.output = hObject;

pause on;
clc;
%resources 
addpath(genpath('resources/'))

%char encoding
slCharacterEncoding('ISO-8859-1');

axes(handles.sideheader);
I=imread('sideratmonlog.png');
imshow(I);

%Initializing Compas
%set(gcf,'renderer','opengl');
opengl software;
axes(handles.compass);
%handles.cmpd = imread('cmpd.png');

hold on;
[handles.cmpd, map, alpha] = imread('cmpd.png'); 
handles.cmps = imshow(handles.cmpd);
set(handles.cmps, 'AlphaData', alpha);

[cmps, map, alpha] = imread('cmps.png'); 
H2=imshow(cmps);
set(H2, 'AlphaData', alpha);

hold off;
%keyboard;
axis image;


set(handles.fslider,'enable','off');

%Initializing AccGraph
axes(handles.acc);
handles.ncell = 500;
handles.accX = zeros(handles.ncell ,1);  
handles.accY = zeros(handles.ncell ,1);
handles.accZ = zeros(handles.ncell ,1);
hold on;
dtime=((1:500)*50)/100;
handles.HX = plot (handles.accX,'r-');   
handles.HY = plot (handles.accY,'g-'); 
handles.HZ = plot (handles.accZ,'b-');  
hold off;
legend1 = legend('AccX','AccY','AccZ'); 
set(legend1,'Orientation','horizontal','Units','characters',...
	'Position',[26.4782505910165 20.1460683760684 50.7044917257683 1.74153846153846]);

%MAX AXIS
handles.maxY = 10;
axis([0 handles.ncell -handles.maxY handles.maxY]);
set(gca,'XTickMode','manual');
set(gca,'XTick',getTickX(handles.ncell,12));
set(gca,'XTickLabel',{'0','2','4','6','8','10','12','14','16','18','20','24'});
xlabel('Time (s)');

set(gca,'YTickMode','manual');
%-500 250 0 250 500
set(gca,'YTick',getTickY(handles.maxY, 5));

ylabel('Acceleration (m/s^2)'); 
grid on;



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
V=V*1.2;
%V=rx(90)*V;
set(handles.rpatch,'Vertices',V(1:3,:)');   
drawnow;
handles.roketvertex=rx(90)*V;




% Update handles structure
guidata(hObject, handles);

% UIWAIT makes guioff wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guioff_OutputFcn(hObject, eventdata, handles) 
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


% --- Executes on button press in openbutton.
function openbutton_Callback(hObject, eventdata, handles)
% hObject    handle to openbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fname = get(handles.fnamesel, 'String');
% keyboard;
fp= fopen([fname]);
if (fp > 0)
	fclose(fp);
	rawdata = dlmread(fname);
	handles.dmaxframe = length(rawdata);
	handles.dcurframe = 1;
	handles.dminframe = 1;
	set(handles.dtime,'string',sprintf('%3.2f',(((handles.dcurframe-1)*50)/1000)));
	
	set(handles.curFrame,'String',handles.dcurframe);
	set(handles.maxFrame,'String',handles.dmaxframe);
	
	set(handles.fslider,'value',handles.dminframe);
	set(handles.fslider,'min',handles.dminframe);
	set(handles.fslider,'max',handles.dmaxframe);
	set(handles.fslider,'sliderstep',([(1/(handles.dmaxframe-1)) (1/(handles.dmaxframe-1))]));
	
	set(handles.HX,'YData',zeros(1,500));
	set(handles.HY,'YData',zeros(1,500));
	set(handles.HZ,'YData',zeros(1,500));
	
	filteron = get(handles.filteron,'value');
	if filteron
		H = fir1(3, 0.2, 'low');
		rtfilter([1 1 1],H);
	end
	
	
	handles.data = zeros(handles.dmaxframe,6);
	for i = 1:handles.dmaxframe
		handles.data(i,:) = dataProcessor(rawdata(i,2:6));
		if filteron
			handles.data(i,1:3)= rtfilter(handles.data(i,1:3));
		end
	end
	set(handles.fslider,'enable','on');
	%keyboard;
end

guidata(hObject, handles);

% --- Executes on slider movement.
function fslider_Callback(hObject, eventdata, handles)
% hObject    handle to fslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
current = floor(get(hObject,'Value'));
handles.dcurframe = current;
%fprintf('val: %d, min: %d, max: %d\n',handles.dcurframe,get(hObject,'Min'),get(hObject,'Max'));
set(handles.curFrame,'String',handles.dcurframe);
set(handles.dtime,'string',sprintf('%3.2f',(((handles.dcurframe-1)*50)/1000)));

yaw   = handles.data(current,4);
pitch = handles.data(current,5);
roll  = handles.data(current,6);

nv = handles.roketvertex;
nv = ry(-roll)*nv;
nv = rx(-pitch)*nv;
nv = rz(-yaw)*nv;

set(handles.rpatch,'Vertices',nv(1:3,:)'); 

%compass
C= imrotate(handles.cmpd,yaw,'crop');
set(handles.cmps,'CData',C);

%keyboard;
if (handles.dcurframe < 500)
	a = zeros(1,500-handles.dcurframe );
	b = handles.data(1:handles.dcurframe,1);
	
	%keyboard;
	dataX = [b' a];
	b = handles.data(1:handles.dcurframe,2);
	dataY = [b' a];
	b = handles.data(1:handles.dcurframe,3);
	dataZ = [b' a];
else
	%b = handles.data(handles.dcurframe-500:handles.dcurframe,1);
end

set(handles.droll,	'string', roll);
set(handles.dpitch,	'string', pitch);
set(handles.dyaw,	'string', yaw);
set(handles.daccx,	'string', handles.data(handles.dcurframe,1));
set(handles.daccy,	'string', handles.data(handles.dcurframe,2));
set(handles.daccz,	'string', handles.data(handles.dcurframe,3));


set(handles.HX,'YData',dataX);
set(handles.HY,'YData',dataY);
set(handles.HZ,'YData',dataZ);
		
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function fslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end




% --- Executes during object creation, after setting all properties.
function AccSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AccSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over fnamesel.
function fnamesel_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to fnamesel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] =  uigetfile({'*.log';'*.*'},'Select attitude monitoring log');
set(handles.fnamesel, 'String', [ pathname filename]);


% --- Executes on slider movement.
function AccSlider_Callback(hObject, eventdata, handles)
% hObject    handle to AccSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
AccSliderCB( hObject, eventdata, handles);


% --- Executes on button press in filteron.
function filteron_Callback(hObject, eventdata, handles)
% hObject    handle to filteron (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of filteron


% --- Executes on button press in debug.
function debug_Callback(hObject, eventdata, handles)
% hObject    handle to debug (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
keyboard;

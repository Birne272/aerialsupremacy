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

% Last Modified by GUIDE v2.5 22-May-2012 00:40:52

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

handles.hrealterm=actxserver('realterm.realtermintf'); % start Realterm as a server
handles.hrealterm.baud=9600;
handles.hrealterm.caption='Matlab Realterm Server';
handles.hrealterm.windowstate=0; 
handles.hrealterm.halfduplex=1;
handles.hrealterm.displayas= 0;
%0 normal 1 minimized
handles.isConnected = 0;

axes(handles.image);
handles.imdata = rgb2gray(imread('square.png'));
imshow(handles.imdata);

axes(handles.compass);
handles.compassimg = imread('compass.png');
handle.compassg = imshow(handles.compassimg);

axes(handles.acc);
handles.ncell = 700;
handles.accX = zeros(handles.ncell ,1);  
handles.accY = zeros(handles.ncell ,1);
handles.accZ = zeros(handles.ncell ,1);
hold on;
handles.HandleAccX = plot (handles.accX,'r-');   
handles.HandleAccY = plot (handles.accY,'g-'); 
handles.HandleAccZ = plot (handles.accZ,'b-');  
legend('AccX','AccY','AccZ'); 
axis([0 700 -500 500]);

set(gca,'XTickMode','manual');
set(gca,'XTick',[0 100 200 300 400 500 600 700]);
set(gca,'YTickMode','manual');
set(gca,'YTick',[-500 -250 0 250 500]);

xlabel('Time (x10 ms)');
ylabel('Acceleration (m/s^2)'); 

accX(1) = 0;
accX(2) = 0;
grid on;

axes(handles.model3d);
[F, V, C] = rndread('roket.stl');
p = patch('faces', F, 'vertices' ,V);
set(p, 'facec', 'r');              % Set the face color (force it)
set(p, 'facec', 'flat');            % Set the face color flat
set(p, 'FaceVertexCData', C);       % Set the color (from file)
%set(p, 'facealpha',.4)             % Use for transparency
set(p, 'EdgeColor','none');         % Set the edge color
%set(p, 'EdgeColor',[1 0 0 ]);      % Use to see triangles, if needed.
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
V=rx(90)*V;
set(p,'Vertices',V(1:3,:)');   
drawnow;
handles.roketvertex=V;
%xlabel('X'),ylabel('Y'),zlabel('Z')

keyboard;

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
	if (handles.isConnected)
		error('COM port still opened');
	end
	fprintf('Trying to close realterm... ');
	invoke(handles.hrealterm,'close'); 
	fprintf('Success !\n');
	%delete(handles.hrealterm);
	% Hint: delete(hObject) closes the figure
	delete(hObject);
catch ex
	fprintf('ERROR : %s\n',ex.message);
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
	command_list = get(handles.commandlist,'String');
	command_val = get(handles.commandlist,'Value');
	command_cur=command_list{command_val};
	fprintf('Trying to send Command [%s]... \n',command_cur);
	%  command_val
	% 1 Start Atittude Monitoring Mode
	% 2 Start Surveillance Mode
	% 3 Halt All Data Transmission
	switch command_val
		case 1
			invoke(handles.hrealterm,'ClearTerminal');
			handles.hrealterm.PutString('77777');
			fprintf('Success! Command [%s] sent. \n',command_cur);
			% Atittude Monitoring Mode
			
		case 2
			invoke(handles.hrealterm,'ClearTerminal'); 
			handles.hrealterm.PutString('aaaaa');
			fprintf('Success! Command [%s] sent. \n',command_cur);
			% Surveillance Mode
			tic;
			ImageCapture(hObject, eventdata, handles);
		case 3
			invoke(handles.hrealterm,'ClearTerminal');
			handles.hrealterm.PutString('#####');	
			fprintf('Success! Command [%s] sent. \n',command_cur);
			% Halt All Data Transmission 
			
	end
	
catch ex
	fprintf('ERROR : %s\n',ex.message);
end


function ImageCapture(hObject, eventdata, handles)
	%Current Directory
	handles.hrealterm.CaptureFile=strcat(cd,'\imagebuffer.txt');
	invoke(handles.hrealterm,'startcapture'); 
	
	%disable image function
	set(handles.rot90button,'Enable','off');
	set(handles.rotm90button,'Enable','off');
	set(handles.savebutton,'Enable','off');

	f1 = fopen('imagebuffer.txt');

	axes(handles.image);
	horizontal_length=200;
	vertical_length=200;
	imdata = cast(zeros(vertical_length,horizontal_length),'uint8');
	imHandle = imshow(imdata);
		
	fprintf('Waiting for data..\n');
	% tunggu sampai ada karakter di RX
	while(handles.hrealterm.charcount==0)
	end
	char_minimum=0;
	current_row=1;
	
	while (current_row<vertical_length)
		inc char_minimum;
		value_read=0;%dummy
		starterror=-2;
		while(value_read~=255)
			while (handles.hrealterm.charcount<char_minimum)
			%tunggu sampai ada char available
			end
			try
				inc starterror;
				value_read=cast(fscanf(f1,'%c',1),'uint8');
			catch ex
				fprintf('ERROR : %s\n',ex.message);
				value_read=0;
			end
			inc char_minimum;
		end

		if(starterror>0)
			fprintf('0xFF Error Received : %d at line : %d\n',starterror,current_row);
		end

		char_minimum=char_minimum+202;%jumlah graycode
		%watchdog=0;
		while (handles.hrealterm.charcount<char_minimum)
			pause(1E-6);
			%inc watchdog;
			%if(watchdog>1000)
			%	break;
			%end
		end


		try
			headerbyte1=cast(fscanf(f1,'%c',1),'uint8');
			while (headerbyte1==255)
				headerbyte1=cast(fscanf(f1,'%c',1),'uint8');
				inc char_minimum;
			end
			headerbyte2=cast(fscanf(f1,'%c',1),'uint8');
			headerbyte3=cast(fscanf(f1,'%c',1),'uint8');
			headerstr = strcat(headerbyte1,headerbyte2,headerbyte3);
			[headerval, status] = str2num(headerstr);
			if(status)
				if (headerval==current_row)
					%fprintf('Header Matched  line - %d\n',current_row);
					if (headerval==1)
						x=toc;
						fprintf('Header line 1 received at %3.2f seconds\n',x);
					end
				else
					error('Header Mismatch line %d, got %d\n',current_row, headerval);
				end
			else
				error('Header Error : %s',headerstr);
			end	
		catch ex
			fprintf('ERROR : %s\n',ex.message);
			value_read=0;
		end

		while (handles.hrealterm.charcount<char_minimum)
			pause(1E-6);
			%inc watchdog;
			%if(watchdog>1000)
			%	break;
			%end
		end

		current_col=1;
		while (current_col<horizontal_length)	
			try
				value_read=cast(fscanf(f1,'%c',1),'uint8');
				if (isempty(value_read))
					error('Empty Value');
				end
			catch ex
				fprintf('ERROR : %s\n',ex.message);
				value_read=1;
			end
			imdata(current_row,current_col) = value_read;
			inc current_col;
		end

		inc current_row;

		set(handles.ImageStatus,'String',sprintf('%2.1f%%',current_row/2));
		if (not(mod(current_row,2)))
			set(imHandle, 'CData', imdata);
			drawnow;
		end
	end
	
	x=toc;
	fprintf('Image capture success at %3.2f seconds\n',x); 
	%keyboard;
	
	fclose(f1);
	invoke(handles.hrealterm,'stopcapture');
	
	% simpan data ke global
	handles.imdata=imdata;
	
	a=fix(clock);
	fname = sprintf('cam%02d%02d_%02d%02d.txt',a(3),a(2),a(4),a(5));
	copyfile('imagebuffer.txt',fname)
	fprintf('Data saved as %s\n',fname);
	
	%enable image function
	set(handles.rot90button,'Enable','on');
	set(handles.rotm90button,'Enable','on');
	set(handles.savebutton,'Enable','on');
	
guidata(hObject, handles);

% --- Executes on button press in rot90button.
function rot90button_Callback(hObject, eventdata, handles)
% hObject    handle to rot90button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.image);
handles.imdata = imrotate(handles.imdata,90,'bilinear');
imshow(handles.imdata);

guidata(hObject, handles);

% --- Executes on button press in rotm90button.
function rotm90button_Callback(hObject, eventdata, handles)
% hObject    handle to rotm90button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.image);
handles.imdata = imrotate(handles.imdata,-90,'bilinear');
imshow(handles.imdata);

guidata(hObject, handles);

% --- Executes on button press in savebutton.
function savebutton_Callback(hObject, eventdata, handles)
% hObject    handle to savebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=fix(clock);
fname = sprintf('cam%02d%02d_%02d%02d.png',a(3),a(2),a(4),a(5));
imwrite(handles.imdata,fname,'png');
fprintf('Picture saved as %s\n',fname);

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
		fprintf('Trying to open COM%d..',portVal);
		handles.TargetPort = portVal;
		handles.hrealterm.Port = sprintf('%d',handles.TargetPort);
		handles.hrealterm.PortOpen=1; 
		handles.isConnected = (handles.hrealterm.PortOpen~=0);
		fprintf('Success!\n');
	else
		fprintf('Trying to close COM%d..',portVal);
		handles.hrealterm.PortOpen=0; 
		handles.isConnected = (handles.hrealterm.PortOpen~=0);
		fprintf('Success!\n');
	end
	
catch ex
	handle.isConnected = 0;
	fprintf('ERROR : %s\n',ex.message);
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
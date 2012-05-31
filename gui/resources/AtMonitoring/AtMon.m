function AtMon(hObject, eventdata, handles)

%sub function
function [readval] = SerialReadVal()
	%keyboard;
	char_minimum = ftell(f1)+4;
	watchdog=0;
	dataexist=1;
	while (handles.hrealterm.charcount<char_minimum)
		pause(1E-6);
		inc watchdog;
		if(watchdog>100)
			dataexist=0;
			break;
		end
	end
	
	%keyboard;
	if (dataexist)
		readval = fscanf(f1,'%d',1);
		if (isempty(readval))
			readval = -1;	
		end
		
	else
		readval = -1;	
	end
	%keyboard;
end


%%HEADER GRAKSA (303)
myheader = 303;

%%%%%%%%%% FILTER
H = fir1(15, 0.2, 'low');
%%filter stat 
% 0 unfiltered 
% 1 acc saja 
% 2 semua
filterstat = 1;
switch filterstat 		
	case 1
		rtfilter([1 1 1],H);
	case 2
		rtfilter([1 1 1 1 1 1],H);
end

%update tiap xdivisor sample
xdivisor = 2;
imbuffer = 'sbuf';
handles.hrealterm.CaptureFile=strcat(cd,'\',imbuffer);
invoke(handles.hrealterm,'startcapture'); 	

f1 = fopen(imbuffer);

axes(handles.acc);
dataX = handles.accX;
dataY = handles.accY;
dataZ = handles.accZ;
set(handles.HX,'YData',dataX);
set(handles.HY,'YData',dataY);
set(handles.HZ,'YData',dataZ);
drawnow

strtemp=sprintf('Waiting for data..');
set(handles.debug,'string',enquestr(strtemp));

while(handles.hrealterm.charcount==0)
	pause(1E-6);
end

x=toc;
strtemp=sprintf('Data received at %3.2f seconds',x);
set(handles.debug,'string',enquestr(strtemp));

char_minimum=0;
rawdata = zeros(1,5);
ProcessedData = zeros(1,6);
cur_sample=0;

while(1)
	%  1234567890123456789012345678901234567890
	%  123 456 789 456 123 456\ 
	
	header=SerialReadVal();
	while((header~=myheader)&&(header~=-1))
		header=SerialReadVal();
	end
	
	if(header==-1)
		break;
	end
	
	inc cur_sample;
	if (cur_sample>handles.ncell)
		cur_sample=1;
		dataX = handles.accX;
		dataY = handles.accY;
		dataZ = handles.accZ;
	end
	
	rawdata(1) = SerialReadVal();
	rawdata(2) = SerialReadVal();
	rawdata(3) = SerialReadVal();
	rawdata(4) = SerialReadVal();
	rawdata(5) = SerialReadVal();
	


	ProcessedData = dataProcessor(rawdata);
	
	switch filterstat 		
	case 1
		ProcessedData(1:3)= rtfilter(ProcessedData(1:3));
	case 2
		ProcessedData= rtfilter(ProcessedData);
	end

	
	strtemp=sprintf('acc: %3.2f %3.2f %3.2f eul: %3.2f %3.2f %3.2f ',ProcessedData(1),ProcessedData(2),ProcessedData(3),ProcessedData(4),ProcessedData(5),ProcessedData(6));
	set(handles.debug,'string',enquestr(strtemp));
	%data = rtfilter(rawdata(2:4));
	%data(3) = rawdata(4);
	%data(2)=rtfilter(rawdata(2))+300;
	%fprintf('%d -- %d\n',data(2),rawdata(2));

	dataX(cur_sample)=ProcessedData(1);
	dataY(cur_sample)=ProcessedData(2);
	dataZ(cur_sample)=ProcessedData(3);
	
	%if(mod(cur_sample,xdivisor)==0)
		
		%model3d
		%              roll pitch yaw
		%ProcessedData(4-6)
		%%%%%%  ini yang boleh diganti
		nv = rx(ProcessedData(4))*handles.roketvertex;
		nv = ry(ProcessedData(5))*nv;
		nv = rz(ProcessedData(6))*nv;

		set(handles.rpatch,'Vertices',nv(1:3,:)');       
	
		
		%compass
		C= imrotate(handles.cmpd,ProcessedData(6),'crop');
		set(handles.cmps,'CData',C);	
		
		%Acc
		set(handles.HX,'YData',dataX);
		set(handles.HY,'YData',dataY);
		set(handles.HZ,'YData',dataZ);
		
		
		drawnow
	%end;
end

fclose(f1);
invoke(handles.hrealterm,'stopcapture');

handles.isrunning = 0;	

a=fix(clock);
fname = sprintf('atmon%02d%02d_%02d%02d.log',a(3),a(2),a(4),a(5));
copyfile(imbuffer,fname);
movefile(fname,'log\atmon\');
strtemp=sprintf('Data saved as log/atmon/%s',fname);
set(handles.debug,'string',enquestr(strtemp));
guidata(hObject, handles);

end



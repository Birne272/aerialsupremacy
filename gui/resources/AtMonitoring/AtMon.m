function AtMon(hObject, eventdata, handles)

%FILTER
H = fir1(30, 0.205, 'low');
rtfilter([1 1 1],H);

%update tiap xdivisor sample
xdivisor = 4;
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
cur_sample=0;
dataexist=1;
while(dataexist)
	%  1234567890123456789012345678901234567890
	%  123 456 789 456 123 456\ 
	char_minimum=char_minimum + 23;
	watchdog=0;
	while (handles.hrealterm.charcount<char_minimum)
		%tunggu sampai ada char available
		pause(1E-6);
		inc watchdog;
		if(watchdog>10)
			dataexist=0;
			break;
		end
	end 
	if(~dataexist)
		break;
	end
	
	try
		rawdata = fscanf(f1,'%d',4);
		data = rtfilter(rawdata(2:4));
		data(3) = rawdata(4);
		%data(2)=rtfilter(rawdata(2))+300;
		%fprintf('%d -- %d\n',data(2),rawdata(2));
		
		inc cur_sample;
		if (cur_sample>handles.ncell)
			cur_sample=1;
			dataX = handles.accX;
			dataY = handles.accY;
			dataZ = handles.accZ;
		end
		dataX(cur_sample)=data(1);
		dataY(cur_sample)=data(2);
		dataZ(cur_sample)=data(3);
		if(mod(cur_sample,xdivisor)==0)
			set(handles.HX,'YData',dataX);
			set(handles.HY,'YData',dataY);
			set(handles.HZ,'YData',dataZ);
			drawnow
		end;
		%keyboard;
	catch ex
		strtemp=sprintf('ERROR : %s',ex.message);
		set(handles.debug,'string',enquestr(strtemp));
	end
	
end

fclose(f1);
invoke(handles.hrealterm,'stopcapture');

handles.isrunning = 0;	

a=fix(clock);
fname = sprintf('data%02d%02d_%02d%02d.log',a(3),a(2),a(4),a(5));
copyfile(imbuffer,fname);
movefile(fname,'log\');
strtemp=sprintf('Data saved as log/%s',fname);
set(handles.debug,'string',enquestr(strtemp));
guidata(hObject, handles);

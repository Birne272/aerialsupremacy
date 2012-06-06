function ImageCapture(hObject, eventdata, handles)
%sub function
	% Timer utk Elapsed Time
	T = timer();
	T.ExecutionMode = 'fixedRate';
	T.Period = 0.01;
	T.TimerFcn = {@ImUpdateTime, hObject, eventdata, handles};
	start(T);
	
	imbuffer = 'sbuf';
	handles.hrealterm.CaptureFile=strcat(cd,'\',imbuffer);
	invoke(handles.hrealterm,'startcapture'); 	
	
	%disable image function
	set(handles.rot90button,'Enable','off');
	set(handles.rotm90button,'Enable','off');
	set(handles.savebutton,'Enable','off');

	f1 = fopen(imbuffer);

	axes(handles.image);
	horizontal_length=201;
	vertical_length=200;
	imdata = cast(zeros(vertical_length,horizontal_length),'uint8');
	%set(handles.imHandle, 'CData', imdata);
	imHandle = imshow(imdata);
	drawnow;
		
	strtemp=sprintf('Waiting for data..');
	set(handles.debug,'string',enquestr(strtemp));
	% tunggu sampai ada karakter di RX
	while(handles.hrealterm.charcount==0)
		pause(1E-6);
	end
	char_minimum=1;
	
	try
		%keyboard;
		HeaderID = [];
		HeaderTemp = ' ';
		while (HeaderTemp~=(255))
			if (HeaderTemp~=14)
				HeaderID = [HeaderID HeaderTemp];
			end
			while (handles.hrealterm.charcount<char_minimum)
				pause(1E-6);
				%tunggu sampai ada char available
			end
			HeaderTemp=fscanf(f1,'%c',1);
			inc char_minimum;
		end
		strtemp=sprintf('Identification received : %s', HeaderID);
		set(handles.debug,'string',enquestr(strtemp));
	catch ex
		fprintf('%s\n',ex.message);
	end
	
	
	current_row=1;
	
	while (current_row<=vertical_length)
		inc char_minimum;
		value_read=0;%dummy
		starterror=-1;
		while(value_read~=255)
			
			while (handles.hrealterm.charcount<char_minimum)
				pause(1E-6);
				%tunggu sampai ada char available
			end
			
			try
				inc starterror;
				value_read=cast(fscanf(f1,'%c',1),'uint8');
			catch ex
				strtemp=sprintf('ERROR : %s',ex.message);
				set(handles.debug,'string',enquestr(strtemp));
				value_read=0;
			end
			inc char_minimum;
		end

		if ((starterror>0)&&(current_row>1))
			strtemp=sprintf('0xFF Error Received : %d at line : %d',starterror,current_row);
			set(handles.debug,'string',enquestr(strtemp));
		end

		char_minimum=char_minimum+206;%jumlah data setelah FF
		watchdog=0;
		while (handles.hrealterm.charcount<char_minimum)
			pause(1E-6);
			inc watchdog;
			if(watchdog>30)
				break;
			end
		end


		try
			headerbyte1=cast(fscanf(f1,'%c',1),'uint8');
			headerbyte2=cast(fscanf(f1,'%c',1),'uint8');
			headerbyte3=cast(fscanf(f1,'%c',1),'uint8');
			headerstr = strcat(headerbyte1,headerbyte2,headerbyte3);
			[headerval, status] = str2num(headerstr);
			if(status)
				if (headerval==current_row)
					strtemp=sprintf('Header Matched  line - %d',current_row);
					set(handles.debug,'string',enquestr(strtemp));
					if (headerval==1)
						x=toc;
						strtemp=sprintf('Header line 1 received at %3.2f seconds',x);
						set(handles.debug,'string',enquestr(strtemp));
					end
				else
					x = current_row;
					current_row = headerval;
					error('Header Mismatch expected %d, got %d',x, headerval);					
				end
				%final%strtemp=sprintf('Got header for line %d',current_row);
				%final%set(handles.debug,'string',enquestr(strtemp));
			else
				error('Header Error : %s',headerstr);
			end	
		catch ex
			strtemp=sprintf('ERROR : %s',ex.message);
			set(handles.debug,'string',enquestr(strtemp));
			value_read=0;
		end

		current_col=1;
		while (current_col<horizontal_length)	
			try
				value_read=cast(fscanf(f1,'%c',1),'uint8');
				if (isempty(value_read))
					error('Empty Value');
				end
			catch ex
				strtemp=sprintf('ERROR : %s',ex.message);
				set(handles.debug,'string',enquestr(strtemp));
				value_read=1;
			end
			imdata(current_row,current_col) = value_read;
			if (current_row==1&&current_col<10)
				%keyboard;
				fprintf('(%d,%d) <- %d\n',current_row,current_col,value_read);
			end
			inc current_col;
		end
		
		
		%%COMPASS READING
		try
			value_read=cast(fscanf(f1,'%c',1),'uint8');
			x=0;
			while(value_read~=255)
				inc char_minimum;
				inc x;
				value_read=cast(fscanf(f1,'%c',1),'uint8');
            end
            %fprintf('%d --> %d\n',current_row, x);
			if (x>(200-horizontal_length+1))
				strtemp=sprintf('PANIC FF HEADER COMPASS NOT READ at line %d',current_row);
				set(handles.debug,'string',enquestr(strtemp));
			end
			
			compassbyte1=cast(fscanf(f1,'%c',1),'uint8');
			compassbyte2=cast(fscanf(f1,'%c',1),'uint8');
			compassbyte3=cast(fscanf(f1,'%c',1),'uint8');
			compasstr = strcat(compassbyte1,compassbyte2,compassbyte3);
			[compasval, status] = str2num(compasstr);
			
			if(status)
				C= imrotate(handles.cmpd,compasval,'crop');
				set(handles.cmps,'CData',C);
				drawnow;				
			else
				strtemp=sprintf('PANIC COMPASS invalid at %d read : %s',current_row,compasstr);
				set(handles.debug,'string',enquestr(strtemp));
			end	
		catch ex
			strtemp=sprintf('ERROR : %s',ex.message);
			set(handles.debug,'string',enquestr(strtemp));
			value_read=0;
		end
		

		set(handles.ImageStatus,'String',sprintf('%2.1f%%',current_row/2));
		if (not(mod(current_row,2)))
			set(imHandle, 'CData', imdata);
			drawnow;
		end
		
		inc current_row;

		
	end
	stop(T);
	x=toc;
	strtemp=sprintf('Image capture success at %3.2f seconds',x); 
	set(handles.debug,'string',enquestr(strtemp));
	%keyboard;

	
	fclose(f1);
	invoke(handles.hrealterm,'stopcapture');
	
	% simpan data ke global
	handles.imdata=imdata;

	
	a=fix(clock);
	fname = sprintf('cam%02d%02d_%02d%02d.log',a(3),a(2),a(4),a(5));
	copyfile(imbuffer,fname);
	movefile(fname,'log\cam\');
	strtemp=sprintf('Data saved as log/cam/%s',fname);
	set(handles.debug,'string',enquestr(strtemp));
	
	%enable image function
	set(handles.rot90button,'Enable','on');
	set(handles.rotm90button,'Enable','on');
	set(handles.savebutton,'Enable','on');
	%keyboard;
	
	handles.isrunning = 0;		
	guidata(hObject,handles);

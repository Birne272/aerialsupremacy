
horizontal_length=200;
vertical_length=200;

imagedata = cast(zeros(vertical_length,horizontal_length),'uint8');

imHandle =  imshow(imagedata);
set (imHandle,'Erase','xor'); 
shg;


% tunggu sampai ada karakter di RX
while(hrealterm.charcount==0)
end
char_minimum=0;
current_row=1;
while (current_row<vertical_length)
	inc char_minimum;
	value_read=0;%dummy
	starterror=-2;
	while(value_read~=255)
		while (hrealterm.charcount<char_minimum)
		%tunggu sampai ada char available
		end
		try
			inc starterror;
			value_read=cast(fscanf(s1,'%c',1),'uint8');
			
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
	while (hrealterm.charcount<char_minimum)
		pause(1E-6);
		%inc watchdog;
		%if(watchdog>1000)
		%	break;
		%end
	end
	
		
	try
		headerbyte1=cast(fscanf(s1,'%c',1),'uint8');
		while (headerbyte1==255)
			headerbyte1=cast(fscanf(s1,'%c',1),'uint8');
			inc char_minimum;
		end
		headerbyte2=cast(fscanf(s1,'%c',1),'uint8');
		headerbyte3=cast(fscanf(s1,'%c',1),'uint8');
		headerstr = strcat(headerbyte1,headerbyte2,headerbyte3);
		[headerval, status] = str2num(headerstr);
		if(status)
			if (headerval==current_row)
				%fprintf('Header Matched  line - %d\n',current_row);
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
	
	while (hrealterm.charcount<char_minimum)
		pause(1E-6);
		%inc watchdog;
		%if(watchdog>1000)
		%	break;
		%end
	end
	
	if(current_row==1)
		fprintf('Header 1 Received : ');toc;
	end
		
	current_col=1;
	while (current_col<horizontal_length)	
		try
			value_read=cast(fscanf(s1,'%c',1),'uint8');
			if (isempty(value_read))
				error('Empty Value');
			end
		catch ex
			fprintf('ERROR : %s\n',ex.message);
			value_read=1;
		end
		imagedata(current_row,current_col) = value_read;
		inc current_col;
	end
	
	inc current_row;
	if (not(mod(current_row,2)))
		set(imHandle, 'CData', imagedata);
		drawnow;
	end
end
fprintf('Reconstruction Completed : ');toc;
imagedata= imrotate(imagedata,90);
imagedata = adapthisteq(imagedata);
set(imHandle, 'CData', imagedata);
drawnow;


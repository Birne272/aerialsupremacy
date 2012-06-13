function [ imdata ] = imageFromFile( fname )
%IMAGEFROMFILER Summary of this function goes here
%   Detailed explanation goes here

	horizontal_length=201;
	vertical_length=200;
	imdata = cast(zeros(vertical_length,horizontal_length-1),'uint8');
	f1 = fopen (fname);
	
	
	HeaderID = [];
	HeaderTemp = ' ';
	while (HeaderTemp~=(255))
		if (HeaderTemp~=14)
			HeaderID = [HeaderID HeaderTemp];
		end
		HeaderTemp=fscanf(f1,'%c',1);
	end
	
	
	current_row=1;
	while (current_row<=vertical_length)
		value_read=0;
		while(value_read~=255)	
			value_read=cast(fscanf(f1,'%c',1),'uint8');
		end
		
		headerbyte1=cast(fscanf(f1,'%c',1),'uint8');
		headerbyte2=cast(fscanf(f1,'%c',1),'uint8');
		headerbyte3=cast(fscanf(f1,'%c',1),'uint8');
		headerstr = strcat(headerbyte1,headerbyte2,headerbyte3);
		[headerval, status] = str2num(headerstr);
		
		current_col=1;
		while (current_col<horizontal_length)	
			value_read=cast(fscanf(f1,'%c',1),'uint8');
			if (isempty(value_read))
				value_read = 1;
			end
			imdata(current_row,current_col) = value_read;
			inc current_col;
		end
		
		%%COMPASS READING
		value_read=cast(fscanf(f1,'%c',1),'uint8');
		x=0;
		while(value_read~=255)
			inc x;
			value_read=cast(fscanf(f1,'%c',1),'uint8');
		end
		
		compassbyte1=cast(fscanf(f1,'%c',1),'uint8');
		compassbyte2=cast(fscanf(f1,'%c',1),'uint8');
		compassbyte3=cast(fscanf(f1,'%c',1),'uint8');
		compasstr = strcat(compassbyte1,compassbyte2,compassbyte3);
		[compasval, status] = str2num(compasstr);
			
		
		inc current_row;

		
	end
	
end


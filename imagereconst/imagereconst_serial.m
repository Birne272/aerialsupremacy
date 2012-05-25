
h_pxl=200;v_pxl=201;
i=1;j=1;
idx=0;datadata=[];
readfail = [];readfailidx=0;

imagedata = cast(zeros(v_pxl,h_pxl),'uint8');
imHandle =  imshow(imagedata);
set (imHandle,'Erase','xor'); 

shg;

while (j<v_pxl)
	
	temp=cast(fscanf(s1,'%c',1),'uint8');
	idx = idx+1;datadata(idx)=temp;
	k=0;
	while (temp~=255)
		k=k+1;
		temp=cast(fscanf(s1,'%c',1),'uint8');
		idx = idx+1;datadata(idx)=temp;
	end
	if(k>1)
		fprintf('error awal : %d\n',k);
		fprintf('FF start received -%d\n',j);
	end
	
	temp1=cast(fscanf(s1,'%c',1),'uint8');
	idx = idx+1;datadata(idx)=temp1;
	temp2=cast(fscanf(s1,'%c',1),'uint8');
	idx = idx+1;datadata(idx)=temp2;
	temp3=cast(fscanf(s1,'%c',1),'uint8');
	idx = idx+1;datadata(idx)=temp3;
	
	tempstr=strcat(temp1,temp2,temp3);
	[tempx, status] = str2num(tempstr);
	
	if (status == 1)
		if (tempx ~=j)
			fprintf('header #%d error\n',j);
			fprintf('--- header %s\n', tempstr);
		else
			fprintf('header #%d received\n',j);
		end
	else
		fprintf('header #%d error stat\n',j);
		fprintf('--- header %s\n', tempstr);
	end
	
	while (i<h_pxl)	
		temp=cast(fscanf(s1,'%c',1),'uint8');
		
		if(isempty(temp))
			%temp=255;
			temp = datadata(idx);
			readfailidx=readfailidx+1;readfail(readfailidx) = idx;
			fprintf('byte ga kebaca di - %d\n', idx);
		end
		idx = idx+1;datadata(idx)=temp;
		imagedata(j,i) = temp;
		
		i=i+1;
	end
	
	j=j+1;
	i=1;
	
	if (not(mod(j,2)))
		set(imHandle, 'CData', imagedata);
		drawnow;
	end
	
end
pause(1.0);

%imagedata= imrotate(imagedata,90);
%set(imHandle, 'CData', imagedata);
%drawnow;
%pause(1.0);
%imagedata = adapthisteq(imagedata);
%pause(1.0);
%subplot(1,2,2),imshow(imagedata);
set(imHandle, 'CData', imagedata);
drawnow;



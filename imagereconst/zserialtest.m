i = 0;
j = 0;
data = zeros (1, 41000);
while (s1.BytesAvailable==0)
end
tic;
while (s1.BytesAvailable>0)
while (s1.BytesAvailable>0)
	temp=cast(fscanf(s1,'%c',1),'uint8');
	if(~isempty(temp))
		i=i+1;
		data(i) = temp;
		if(mod(i,1000)==0)
			fprintf('-- %d\n',i);
		end
	else
		j=j+1;
	end
end
pause(1E-6);
end
fprintf('char read = %d \n', i);
toc;
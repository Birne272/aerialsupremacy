% s1 = serial ('COM9','BaudRate',9600);
% fopen(s1);
% s1 = fopen('raw.txt');
s1 = fopen('../datarekaman1/kamera8');

i = 0;
datafile = zeros (1, 41000);
fprintf('data open\n');
tic;
while ~feof(s1)
while ~feof(s1)
	temp=cast(fscanf(s1,'%c',1),'uint8');
	if(~isempty(temp))
		i=i+1;
		datafile(i) = temp;
		if(mod(i,1000)==0)
			fprintf('-- %d\n',i);
		end
	end
end
end
fprintf('char read = %d \n', i);
toc;

fclose(s1);
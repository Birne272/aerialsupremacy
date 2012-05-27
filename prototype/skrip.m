countingtable=zeros(1,256);
i=1;
while(i<length(readfail))
	countingtable(datafile(readfail(i))+1)=countingtable(datafile(readfail(i))+1)+1;
	i=i+1;
end
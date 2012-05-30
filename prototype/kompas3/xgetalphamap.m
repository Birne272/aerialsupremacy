AMap = ones(199,199);
x=0;
for i=1:199
	for j=1:199
		if ((roket(i,j,1)==0)&&(roket(i,j,2)==168)&&(roket(i,j,3)==89))
			AMap(i,j) = 0;
		end
	end
end
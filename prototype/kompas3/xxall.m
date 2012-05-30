bulet = imread('bulet.png');
roket = imread('roket.png');
H=imshow(bulet);
hold on;
H2=imshow(roket);
hold off;

AMap = ones(199,199);
x=0;
for i=1:199
	for j=1:199
		if ((roket(i,j,1)==0)&&(roket(i,j,2)==168)&&(roket(i,j,3)==89))
			AMap(i,j) = 0;
		end
	end
end

set(H2, 'AlphaData', AMap);

tic;
for i=0:900
	C= imrotate(bulet,i,'crop');
	set(H,'CData',C);
	drawnow;
end
for i=900:-1:1
	C= imrotate(bulet,i,'crop');
	set(H,'CData',C);
	drawnow;
end
toc;

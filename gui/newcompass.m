%a=imread('compass.jpg');
%compass=imshow(a);

tic;
shg;
for i=1:1000
	yaw=i;
	if(abs(last-yaw)>5)
		b = imrotate(a,yaw,'nearest','crop');
		c = ~imrotate(true(size(a)),yaw,'nearest','crop');
		b(c&~imclearborder(c)) = 255;
		set(compass,'CData',b);
		%imshow(b(24:136,24:136,1:3))
		drawnow;
		last=yaw;
	end
end
toc;
tic;
		b = imrotate(a,yaw,'nearest','crop');
		c = ~imrotate(true(size(a)),yaw,'crop');
		b(c&~imclearborder(c)) = 255;
set(compass,'CData',b);
drawnow;
last=yaw;
toc;
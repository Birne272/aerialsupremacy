nSample = 500;
nMul = 40;

px = zeros (255,1);
py = px;
pz = px;

euler = [px px px];
iroll = px;ipitch = px; iyaw = px;

for i = 2:nSample
	px(i) = (i/nSample) * nMul;
	py(i) = (i/nSample) * nMul;
	pz(i) = sin((i/nSample)*pi)* nMul;
	
	dx = px(i) - px(i-1);
	dy = py(i) - py(i-1);
	dz = pz(i) - pz(i-1);
	
	iroll(i) = atan(dy/dz);
	ipitch(i) = atan(dx/dz);
	ipitch(i) = atan(dx/dy);
	
end

trajectory3(px,py,pz,iroll, ipitch, ipitch, 1.0 , 25, 'komurindo');




trajectory3(data(:,1),data(:,2),data(:,3),data(:,5), data(:,6), data(:,3), 1.0 , 25, 'komurindo');




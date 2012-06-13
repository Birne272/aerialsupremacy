function [ out ] = getTickY( maxY , nTick )
%GETTICKY Summary of this function goes here
%   Detailed explanation goes here
temp = [];
for i=-nTick:nTick;
	temp(nTick+i+1) = maxY * (i/nTick); 
end
%keyboard;
if (maxY>=5)
	out = fix(temp);
else
	out = temp;
end
end


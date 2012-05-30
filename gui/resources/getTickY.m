function [ out ] = getTickY( maxY , nTick )
%GETTICKY Summary of this function goes here
%   Detailed explanation goes here
temp = [];
for i=-nTick:nTick;
	temp(nTick+i+1) = maxY * (i/nTick); 
end
%keyboard;
out = fix(temp);
end


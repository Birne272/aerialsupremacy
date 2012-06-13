function [ out ] = getTickX( maxX , nTick )
%GETTICKY Summary of this function goes here
%   Detailed explanation goes here
temp = [];
for i=0:nTick;
	temp(i+1) = maxX * (i/nTick); 
end
%keyboard;
out = fix(temp);
end


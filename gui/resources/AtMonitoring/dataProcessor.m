function [data] = dataProcessor( rawdata )
%DATAPROCESSOR Summary of this function goes here
%   Detailed explanation goes here
% 0    1    2    3    4     5
% accx accy accz roll pitch yaw
	data(1) = (rawdata(1) * 4 -2000)/250 * 9.82;
	data(2) = (rawdata(2)  * 4 -2000)/250 * 9.82;
	data(3) = (rawdata(3)  * 4 -2000)/250 * 9.82;
	data(4) = floor(rawdata(4) /10)*4;
	data(5) = mod(rawdata(4) ,10)*10+floor(rawdata(5) /100)*4;
	data(6) = mod(rawdata(5) ,100)*4;
	%keyboard;
end


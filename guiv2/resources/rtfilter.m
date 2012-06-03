function [ filtered_data ] = rtfilter( input_data , filter_coef )
%RTFILTER Summary of this function goes here
%   Detailed explanation goes here
	persistent xfilter buffer orde linput;
	switch nargin
		case 2
			xfilter = filter_coef;
			orde= length(xfilter);
			%buffer= zeros(1,orde);
			linput = length(input_data);
			buffer = zeros(linput,orde);
			%fprintf('Filter Orde %d berhasil diload\n',orde);
		case 1
			for i=orde:-1:2
				for j=1:linput
					buffer(j,i) = buffer(j,i-1);
				end
			end
			for j=1:linput
				buffer(j,1)=input_data(j);
			end
			temp = zeros(1,linput);
			for n=1:orde
				for j=1:linput
					temp(j) = temp(j) + buffer(j,n)* xfilter(n);
				end
			end
			filtered_data = temp;
		otherwise
			error('Parameter tidak sesuai');        
	end
end
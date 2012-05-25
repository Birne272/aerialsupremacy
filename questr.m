function [ vstr ] = questr( str , xcur, xmaxr);
%QUESTR Summary of this function goes here
%   Detailed explanation goes here
persistent maxr cur strarr ;
switch nargin
    case 1
        if(isempty(maxr))
            maxr=5;
            strarr = [];
        end
        if(isempty(cur))
            cur=1;
        end
    case 2
        cur = xcur;
        strarr = [];
    case 3
        cur = xcur;
        maxr = xmaxr;
        strarr = [];
end;


fprintf('cur= %d maxr= %d \n',cur, maxr);



end


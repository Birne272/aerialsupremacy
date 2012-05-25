function [ vstr ] = enquestr( str , xts, xmaxr);
%QUESTR Summary of this function goes here
%   Detailed explanation goes here
persistent maxr qstr ts;
switch nargin
    case 1
        if(ts)
            a=fix(clock);
            timestamp = sprintf('[%2.2d:%2.2d:%2.2d] ',a(4),a(5),a(6));
            %temp = strcat(timestamp,str);
            temp = [timestamp str];
        else
            temp = str;
        end
        
    case 2
        %if (ts)
        a=fix(clock);
        timestamp = sprintf('[%2.2d:%2.2d:%2.2d] ',a(4),a(5),a(6));
        temp = strcat(timestamp,str);
        %else
        %    temp = str;
        %end
        
    case 3
        maxr = xmaxr;
        ts = xts;
        qstr = cell(maxr,1);
        fprintf('maxr= %d \n', maxr);
        temp = 'Terminal Initialized';
end;

for j=maxr-1:-1:1
    qstr(j+1)=qstr(j);
end
qstr(1)={temp};
vstr=qstr;

end


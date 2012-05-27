function [ vstr ] = enquestr( str , xts, xmaxr, fname,close);
%QUESTR Summary of this function goes here
%   Detailed explanation goes here
persistent maxr qstr ts log;
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
    case 4
		log = fopen(fname,'w');
        maxr = xmaxr;
        ts = xts;
        qstr = cell(maxr,1);
        a=fix(clock);
        timestamp = sprintf('[%2.2d:%2.2d:%2.2d] ',a(4),a(5),a(6));
		msg = sprintf('Terminal Initialized and logged at %s',fname);
        temp = [timestamp msg];	
		
	case 5
		fclose(log);
		return;
		
	otherwise
		error('Parameter tidak sesuai');
		
end;
%keyboard;
fprintf(log,'%s\n',temp);
for j=1:maxr-1
    qstr(j)=qstr(j+1);
end
qstr(maxr)={temp};
vstr=qstr;

end


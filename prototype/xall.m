
% Only use these 3 lines to see what properties and methods realterm has.....
fprintf(1,'\nProperties of Realterm\n\n');
get(hrealterm) %List all properties.

try
  set(hrealterm); %In later versions of matlab, this will show you what possible values the enumerations can take
catch
end
 
fprintf(1,'\n\nMethods of Realterm\n\n');
invoke(hrealterm); %List all functions
hrealterm.WindowState=0;
hrealterm.halfduplex=1;
hrealterm.displayas= 0;
hrealterm.baud=9600;
hrealterm.caption='Matlab Realterm Server';
hrealterm.Port='9';
hrealterm.PortOpen=1; %open the comm port
is_open=(hrealterm.PortOpen~=0); %check that it opened OK
hrealterm.CaptureFile='E:\komukomu\imagereconst\datacapture';
invoke(hrealterm,'startcapture'); %start capture
tic;
hrealterm.PutString('aaaa');
s1 = fopen('datacapture');
run('E:\komukomu\imagereconst\imagereconstv2.m')

fclose(s1);

invoke(hrealterm,'stopcapture');

%try %try to close any we can in case they are faulty.
%  invoke(hrealterm,'close'); 
%  delete(hrealterm);
%catch
%  fprintf('unable to close realterm')
%end; %try


function []=RealtermDemo()
% RealtermDemo: Simple test and demo of Realterm
% http://realterm.sourceforge.net
% see also:

% 8:19PM 07/11/2003 SJB $Revision: 1.0 $ $Date: 2003-07-11 21:56:44+12 $

hrealterm=actxserver('realterm.realtermintf'); % start Realterm as a server
 

% Only use these 3 lines to see what properties and methods realterm has.....
fprintf(1,'\nProperties of Realterm\n\n');
get(hrealterm) %List all properties.

try
  set(hrealterm) %In later versions of matlab, this will show you what possible values the enumerations can take
catch
end
 
fprintf(1,'\n\nMethods of Realterm\n\n');
invoke(hrealterm) %List all functions

 

hrealterm.baud=9600;
hrealterm.caption='Matlab Realterm Server';
hrealterm.windowstate=1; %minimized
hrealterm.Port='10';
hrealterm.PortOpen=1; %open the comm port
is_open=(hrealterm.PortOpen~=0); %check that it opened OK
hrealterm.displayas=2; %show hex in terminal window
hrealterm.CaptureFile='E:\komukomu\imagereconst\datacapture';


invoke(hrealterm,'startcapture'); %start capture

%do what you want here
fprintf(1,'\n\nTry what you want here. Type RETURN to end demo and close realterm\n')
keyboard


invoke(hrealterm,'stopcapture');

try %try to close any we can in case they are faulty.
  invoke(hrealterm,'close'); 
  delete(hrealterm);
catch
  fprintf('unable to close realterm')
end; %try




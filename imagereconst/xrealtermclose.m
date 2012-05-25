invoke(hrealterm,'stopcapture');

try %try to close any we can in case they are faulty.
  invoke(hrealterm,'close'); 
  delete(hrealterm);
catch
  fprintf('unable to close realterm')
end; %try




function inc(varname) 
% increments the variable named by the character string in varname 
% usage: plusone x 
% 
% Arguments: (input) 
%  varname - string containing the name of a variable to be 
%            incremented in the caller workspace. 
if (nargin<1) || ~ischar(varname) 
  error('varname must be character name of a variable in caller ws') 
end 
try 
  evalin('caller',[varname '=' varname '+1;']) 
catch 
  error(['Increment to ''',varname,''' failed']) 
end 
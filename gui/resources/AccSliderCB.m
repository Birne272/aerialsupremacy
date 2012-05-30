function AccSliderCB( hObject, eventdata, handles  )
%ACCSLIDERCB Summary of this function goes here
%   Detailed explanation goes here
%fprintf('aaaaaaaaa\n');
%keyboard;
axes(handles.acc);
vals = get(hObject,'Value')+0.01;
maxs = get(hObject,'Max');
handles.maxY = 500*vals;

axis([0 700 -handles.maxY handles.maxY]);
set(gca,'YTick',getTickY(handles.maxY, 5));

guidata(hObject, handles);

end


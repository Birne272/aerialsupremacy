function ImUpdateTime ( obj, event, hObject, eventdata, handles )
%IMUPDATETIME Update Tag
x=toc;
set(handles.imtime,'string',sprintf('%3.2f',x));
end


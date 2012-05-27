for i= 1:1000
end

maxr=5;
oldtext=cell(maxr);


tic;
for i=1:1000
    newtext =cell(size(oldtext));
    newtext(1:maxr-1)=oldtext(2:maxr);
    newtext(end)={'New text to display'};
    oldtext = newtext;
end
toc;
keyboard;

tic;
for i=1:1000
    for j=1:maxr-1
        oldtext(j+1)=oldtext(j);
    end
    oldtext(1)={'New text to display'};
end
toc;
keyboard;

tic;
for i=1:1000;
    a=fix(clock);
end
toc;

tic;
for i=1:1000;
    timestamp = sprintf('[%2.0d:%2.0d:%2.0d]',a(4),a(5),a(6));
end
toc;

tic;
for i=1:1000;
    a=fix(clock);
    timestamp = sprintf('[%2.0d:%2.0d:%2.0d]',a(4),a(5),a(6));
end
toc;


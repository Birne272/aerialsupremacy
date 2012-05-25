%max 5 baris
enquestr(0,0,5);

tic;
for j=1:1000
    enquestr('dummy string lololololololololololo');
end;
toc;
tic;
for j=1:1000
    enquestr('dummy string lololololololololololo',1);
end;
toc;
tic;
for j=1:1000
    enquestr('dummy string lololololololololololo');
end;
toc;
tic;
for j=1:1000
    enquestr('dummy string lololololololololololo',1);
end;
toc;

T = timer();
T.ExecutionMode = 'fixedRate';
T.Period = 1.0;
T.TimerFcn = {@foo, i, i+1, i+5};
start(T);

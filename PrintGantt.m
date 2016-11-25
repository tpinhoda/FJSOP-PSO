function PrintGantt(particle)
    global N_MACHINES;
    global OPERATIONS;
    global N_JOBS;
    global TIME;
    global N_OPERATIONS;
    gantt = zeros(N_MACHINES,2*sum(OPERATIONS));
    gantt_op = cell(N_MACHINES,2*sum(OPERATIONS));
    
    fit = 0;
    machineTime = zeros(1, N_MACHINES);
    jobTime = zeros(1,N_JOBS);
    seq = zeros(length(OPERATIONS),max(OPERATIONS));
    for i=1:N_JOBS
      seq(i,1:OPERATIONS(i))=[sum(OPERATIONS(1:i))-OPERATIONS(i)+1:sum(OPERATIONS(1:i))];
    end
    seq=reshape(seq,[1,length(OPERATIONS)*max(OPERATIONS)]);
    heman = ones(1,N_MACHINES);
    for op=seq
       if op != 0
         machInd=particle(op);
         cost = TIME(op,machInd);
         indJob = JobInd(op);
     
         gantt_op(machInd,(heman(machInd)+1)/2) = ["J" num2str(indJob) "," num2str(op)];
         
         gantt(machInd,heman(machInd))= max(machineTime(machInd),jobTime(indJob));
         gantt(machInd,heman(machInd)+1)= cost + max(machineTime(machInd),jobTime(indJob));
         heman(machInd) = heman(machInd)+2;
         cost = cost + max(machineTime(machInd),jobTime(indJob));
         machineTime(machInd) = cost;
         jobTime(indJob) = cost;
        end 
    end
    Gantt(gantt,gantt_op,N_MACHINES);
 %%   fit = max(max(machineTime,jobTime));
end

function indJob = JobInd (opInd)
    global OPERATIONS;
    cumSum = OPERATIONS(1);
    indJob = 1;
    while cumSum < opInd
        indJob = indJob + 1;
        cumSum = cumSum + OPERATIONS(indJob);
    end     
end

function PrintGantt(particle,schedule)
    global N_MACHINES;
    global OPERATIONS;
    global N_JOBS;
    global TIME;
    global N_OPERATIONS;
    global OPERATIONS_PERJOB;
    global OPERATIONS_ID;
    global JOB_ID;
    
    gantt = zeros(N_MACHINES,2*sum(OPERATIONS));
    gantt_op = cell(N_MACHINES,2*sum(OPERATIONS));
    
    machineTime = zeros(1, N_MACHINES);
    jobTime = zeros(1,N_JOBS);
     
    counter = ones(1,N_JOBS);
    counterMach = ones(1,N_MACHINES);
    ncount = 0;
    schedArray = cell2mat(schedule);
    heman = ones(1,N_MACHINES);
    while ncount < N_OPERATIONS
      for i=1:size(schedArray,2)
        
        op = schedArray(i);
        if (op != 0 && counter(JOB_ID(op)) == OPERATIONS_ID(op))
         machInd= particle(op);
         schedule{machInd}(counterMach(machInd)) = op;
         counterMach(machInd)++;
         
         cost = TIME(op,machInd);
          
         gantt_op(machInd,(heman(machInd)+1)/2) = ["J" num2str(JOB_ID(op)) "," num2str(OPERATIONS_ID(op))];
         gantt(machInd,heman(machInd))= max(machineTime(machInd),jobTime(JOB_ID(op)));
         gantt(machInd,heman(machInd)+1)= cost + max(machineTime(machInd),jobTime(JOB_ID(op)));
         heman(machInd) = heman(machInd)+2;

          cost = cost + max(machineTime(machInd),jobTime(JOB_ID(op)));
          machineTime(machInd) = cost;
          jobTime(JOB_ID(op)) = cost;
          ncount++;
          counter(JOB_ID(op))++;
          schedArray(i) = 0;
        end
      end
    end  
    makespan = max(jobTime);
    disp(schedule);
    Gantt(gantt,gantt_op,N_MACHINES);
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

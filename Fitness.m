function[fit] = Fitness(particleInd)
    global N_MACHINES;
    global OPERATIONS;
    global N_JOBS;
    global POPULATION;
    global TIME;
    global N_OPERATIONS;
    
    fit = 0;
    machineTime = zeros(1, N_MACHINES);
    jobTime = zeros(1,N_JOBS);
    seq = zeros(length(OPERATIONS),max(OPERATIONS));
    for i=1:N_JOBS
      seq(i,1:OPERATIONS(i))=[sum(OPERATIONS(1:i))-OPERATIONS(i)+1:sum(OPERATIONS(1:i))];
    end
    seq=reshape(seq,[1,length(OPERATIONS)*max(OPERATIONS)]);
    for op=seq
       if op != 0
         machInd=POPULATION(particleInd, op);
         cost = TIME(op,machInd);
         indJob = JobInd(op);

         cost = cost + max(machineTime(machInd),jobTime(indJob));
         machineTime(machInd) = cost;
         jobTime(indJob) = cost;
        end 
    end
    fit = max(jobTime);
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

function fit = Fitness(particleInd)
    fit = 0;
    machineTime = zeros(1,N_MACHINES);
    jobTime = zeros(1,N_JOBS);
    
    for machInd=1:N_MACHINES
        opInCell = OpInMach({particleInd},{machInd}).entries
        for opInd=1:length(opInCell)
           op = opInCell(opInd);
           cost = TIME(op,machInd); 
           indJob = JobInd(op);
           cost = cost + max(machineTime(machInd),jobTime(indJob));
           machineTime(machInd) = cost;
           jobTime(indJob) = cost;
        end    
    end
    fit = max(max(machineTime,jobTime));
endfunction

function indJob = JobInd (opInd)
    cumSum = OPERATIONS(1);
    indJob = 1;
    while cumSum < opInd
        indJob = indJob + 1;
        cumSum = cumSum + OPERATIONS(indJob);
        
    end     
endfunction

Fitness(1)

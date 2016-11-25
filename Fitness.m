function [fitness] = Fitness(population)
  parfor particle = 1:size(population,1)
   fitness(particle) = MakeSpan(population(particle,:));
  end
end

function[makespan] = MakeSpan(particle)
    global N_MACHINES;
    global OPERATIONS;
    global N_JOBS;
    global TIME;
    global N_OPERATIONS;
    global OPERATIONS_PERJOB;
    
    machineTime = zeros(1, N_MACHINES);
    jobTime = zeros(1,N_JOBS);
  
    perjob=reshape(OPERATIONS_PERJOB,[1,length(OPERATIONS)*max(OPERATIONS)]);
    for op=perjob
       if op != 0
         machInd= particle(op);
         cost = TIME(op,machInd);
         indJob = JobInd(op);

         cost = cost + max(machineTime(machInd),jobTime(indJob));
         machineTime(machInd) = cost;
         jobTime(indJob) = cost;
        end 
    end
    makespan = max(jobTime);
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


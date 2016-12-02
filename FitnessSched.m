function [fitness] = FitnessSched(particle, schedule)
      fitness = MakeSpanSched(particle, schedule);
end


function[makespan] = MakeSpanSched(particle,schedule)
    global N_MACHINES;
    global OPERATIONS;
    global N_JOBS;
    global TIME;
    global N_OPERATIONS;
    global OPERATIONS_PERJOB;
    global OPERATIONS_ID;
    global JOB_ID;
    
    machineTime = zeros(1, N_MACHINES);
    jobTime = zeros(1,N_JOBS);
     
    counter = ones(1,N_JOBS);
    ncount = 0;
    schedArray = cell2mat(schedule);
    heman = ones(1,N_MACHINES);
    while ncount < N_OPERATIONS
      for i=1:size(schedArray,2)
        
        op = schedArray(i);
        if (op != 0 && counter(JOB_ID(op)) == OPERATIONS_ID(op))
         machInd= particle(op);
         cost = TIME(op,machInd);

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
end

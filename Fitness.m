function[fit] = Fitness(particleInd)
    global N_MACHINES;
    global OPERATIONS;
    global N_JOBS;
    global POPULATION;
    global TIME;
    
    fit = 0;
    machineTime = zeros(1, N_MACHINES);
    jobTime = zeros(1,N_JOBS);
    seq = zeros(max(OPERATIONS),(length(OPERATIONS)));
    for i=1:N_JOBS
      seqaux = [sum(OPERATIONS(1:i))-OPERATIONS(i)+1:sum(OPERATIONS(1:i))];
      if length(seqaux) != length(seq)
        seqaux(length(seqaux)+1:length(seq)) = 0;  
      end 
      seq(:,i)=seqaux;
           
    end
    seq=reshape(seq,[1,length(seq)*length(seq)]);
    heman = ones(1,N_MACHINES);
    for op=seq
       if op != 0
         machInd=POPULATION(particleInd, op);
         cost = TIME(op,machInd);
         indJob = JobInd(op);
         heman(machInd) = heman(machInd)+2;
         cost = cost + max(machineTime(machInd),jobTime(indJob));
         machineTime(machInd) = cost;
         jobTime(indJob) = cost;
        end 
    end
    maxMachine = max(machineTime);
    maxJob = max(jobTime);
    fit = max(maxMachine,maxJob);
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

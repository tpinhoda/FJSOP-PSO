function [fitness] = BuscaLocal(population)

  for p = 1:size(population,1)
    fitness(p) = NeighborhoodSearch(population(p,:),p);
  end  
end

function fitness = NeighborhoodSearch(particle,indexparticle)
    global N_MACHINES;
    global JOB_ID;
    global SCHEDULE;
    global POPULATION;
    
    [pFit SCHEDULE(indexparticle,:) gantt]  = FitnessSched(particle, SCHEDULE(indexparticle,:));
    %%disp(SCHEDULE(50,:));
    machSequence = randperm(N_MACHINES);
    for mach=machSequence
      nSchedule = SCHEDULE(indexparticle,:);
      for i=1:size(nSchedule{mach},2)-1
        for j = i+1:size(nSchedule{mach},2)
          if JOB_ID(nSchedule{mach}(i)) != JOB_ID(nSchedule{mach}(j))
            nSchedule{mach}([i j]) = nSchedule{mach}([j i]);
            [nFit nSchedule] = FitnessSched(particle, nSchedule);
            if(nFit < pFit)
      %%        printf("%d - %d\n",pFit,nFit);
                pFit = nFit;
                SCHEDULE(indexparticle,:) = nSchedule;
            else
                nSchedule = SCHEDULE(indexparticle,:);
            end
          end
        end
      end
    end
    fitness = pFit;
end

function fitness = RemoveCriticalPath(particle,indexparticle)
    global N_MACHINES;
    global JOB_ID;
    global SCHEDULE;
    global POPULATION;
    global N_OPERATIONS;
    global OPERATIONS;
    
    [pFit SCHEDULE(indexparticle,:) gantt]  = FitnessSched(particle, SCHEDULE(indexparticle,:));
    criticalPath = findCritcalPath(particle,indexparticle);
    schedule = SCHEDULE(indexparticle,:);
    for op=1:N_OPERATIONS-1
      if JOB_ID(op)==JOB_ID(op+1) && criticalPath(op)!=0 && criticalPath(op+1) !=0
          mach=particle(op);
          pos=find(schedule{mach}==op);
          pos2=1;
          if size(SCHEDULE{indexparticle,mach},2) > pos
            pos2 = pos+1;
          end  
          if JOB_ID(SCHEDULE{indexparticle,mach}(pos)) != JOB_ID(SCHEDULE{indexparticle,mach}(pos2))
              nSchedule = schedule;
              nSchedule{mach}([pos pos2]) = nSchedule{mach}([pos2 pos]);
              [nFit nSchedule gantt]  = FitnessSched(particle, nSchedule);
              if nFit < pFit
                pFit = nFit;
                schedule = nSchedule;
                SCHEDULE(indexparticle,:) = schedule;
                criticalPath = findCritcalPath(particle,indexparticle);
              end  
          end  
      end  
    end  
    fitness = pFit;   
 end

function [criticalPath] = findCritcalPath(particle,indexparticle)
    global N_JOBS;
    global TIME;
    global N_MACHINES;
    global N_OPERATIONS;
    global OPERATIONS;
    global SCHEDULE;
    global JOB_ID;
    
    [fit SCHEDULE(indexparticle,:) gantt]  = FitnessSched(particle, SCHEDULE(indexparticle,:));
    criticalPath=zeros(1,N_OPERATIONS);
    for op=1:N_OPERATIONS-1
      if JOB_ID(op)==JOB_ID(op+1)
        m1=particle(op);
        pos1=find(SCHEDULE{indexparticle,m1}==op);
        m2=particle(op+1);
        pos2=find(SCHEDULE{indexparticle,m2}==op+1);
        if gantt(m1,(pos1*2)) == gantt(m2,((pos2*2)-1))
          criticalPath([op op+1])=1;
        end  
      end
    end 
end


function [fitness] = SA(particle,indexparticle)
  global SCHEDULE;
  global N_OPERATIONS;
  global JOB_ID;
  [bestSolCost SCHEDULE(indexparticle,:) gantt]  = FitnessSched(particle, SCHEDULE(indexparticle,:));
  bestSol = SCHEDULE(indexparticle,:);
  acceptedSol = SCHEDULE(indexparticle,:);
  acceptedSolCost = bestSolCost;
  iterations = 500;
  minTotalIteration = 50; 
  alpha = 0.85;
  T = 3;
  counter = 0;
  while counter < minTotalIteration
    for i=1:iterations
      counter = counter + 1;
      %%new solution!!
      criticalPath = findCritcalPath(particle,indexparticle);
      op = randi(N_OPERATIONS-1);
      while criticalPath(op)!=1
        op = randi(N_OPERATIONS-1);
      end 
      if (JOB_ID(op) == JOB_ID(op+1) && criticalPath(op)==1 && criticalPath(op+1) ==1)
        %%printf("op %d\n",op);
        mach=particle(op);
        pos=find(SCHEDULE{indexparticle,mach}==op);
        pos2=1;
        if size(SCHEDULE{indexparticle,mach},2) > pos
          pos2 = pos+1;
        end  
        if JOB_ID(SCHEDULE{indexparticle,mach}(pos)) != JOB_ID(SCHEDULE{indexparticle,mach}(pos2))
          nSchedule = SCHEDULE(indexparticle,:);
          %%disp(nSchedule);
          nSchedule{mach}([pos pos2]) = nSchedule{mach}([pos2 pos]);
          [newSolCost newSol gant] = FitnessSched(particle,nSchedule);
      %% end new solution -----------
      
          deltaCost = newSolCost - acceptedSolCost;
          if deltaCost < 0
            SCHEDULE(indexparticle,:) = newSol;
            acceptedSolCost = newSolCost;
          else
            randVal = rand(1);
            p = exp(-1*deltaCost / T);
            if p > randVal
              SCHEDULE(indexparticle,:) = newSol;
              acceptedSolCost = newSolCost;
            end
          end

          % record the cost value in to history
        
          % Update current best value
          if acceptedSolCost < bestSolCost
             bestSol = SCHEDULE(particle,:);
             bestSolCost = acceptedSolCost;
          end
         end
      end 
    end
    T = T * alpha; % cooling
  end
  fitness = bestSolCost
end


function [particle] = swap(particle,i,j)
    particle([i j]) = particle([j i]);
end
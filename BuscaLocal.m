function [fitness] = BuscaLocal(population)
  global N_PARTICLES;
  removeCritcalPath(population(39,:),39);
%  parfor p = 1:size(population,1)
%    fitness(p) = NeighborhoodSearch(population(p,:),p); 
%  end  
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

function [criticalPath] = removeCritcalPath(particle,indexparticle)
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
   disp(criticalPath); 
   
end

function [particle] = swap(particle,i,j)
    particle([i j]) = particle([j i]);
end
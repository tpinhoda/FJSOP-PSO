function [fitness] = BuscaLocal(population)
  global N_PARTICLES;
  parfor p = 1:size(population,1)
    fitness(p) = NeighborhoodSearch(population(p,:),p); 
  end  
end

function fitness = NeighborhoodSearch(particle,indexparticle)
    global N_MACHINES;
    global JOB_ID;
    global SCHEDULE;
    
    pFit = FitnessSched(particle, SCHEDULE(indexparticle,:));
    machSequence = randperm(N_MACHINES);
    for mach=machSequence
      nSchedule = SCHEDULE(indexparticle,:);
      for i=1:size(nSchedule{mach},2)-1
        for j = i+1:size(nSchedule{mach},2)
          if JOB_ID(nSchedule{mach}(i)) != JOB_ID(nSchedule{mach}(j))
            nSchedule{mach}([i j]) = nSchedule{mach}([j i]);
            nFit = FitnessSched(particle, nSchedule);
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

function [particle] = swap(particle,i,j)
    particle([i j]) = particle([j i]);
end
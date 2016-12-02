function [fitness] = BuscaLocal(population)
  global N_PARTICLES;
  parfor p = 1:size(population,1)
    fitness(p) = NeighborhoodSearch(population(p,:)); 
  end  
end

function fitness = NeighborhoodSearch(particle)
    global N_MACHINES;
    global JOB_ID;
    pSchedule = cell(1,N_MACHINES);
    for mach=1:N_MACHINES
      pSchedule(mach) = find(particle==mach);
    end
    pFit = FitnessSched(particle, pSchedule);
    machSequence = randperm(N_MACHINES);
    for mach=machSequence
      nSchedule = pSchedule;
      for i=1:size(nSchedule{mach},2)-1
        for j = i+1:size(nSchedule{mach},2)
          if JOB_ID(nSchedule{mach}(i)) != JOB_ID(nSchedule{mach}(j))
            nSchedule{mach}([i j]) = nSchedule{mach}([j i]);
            nFit = FitnessSched(particle, nSchedule);
            if(nFit < pFit)
              pFit = nFit;
              pSchedule = nSchedule;
            else
              nSchedule = pSchedule;
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
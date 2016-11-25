function BuscaLocal(type,indexParticle)
  
  switch type
    case 1 
      if(rand() <0.5)
        SwappedNeighbors(indexParticle);
      end  
  end  
  
end

function SwappedNeighbors(indexParticle)
    global POPULATION;
    global N_MACHINES;
    particle = POPULATION(indexParticle,:);
    for mach=1:N_MACHINES
      machIndex = find(particle==mach);
      for i=1:length(machIndex)-1
        neighbor = swap(particle,i,i+1);
        neifit = Fitness(neighbor);
        partfit = Fitness(particle);
        printf("nei: %d -- part: %d \n",neifit,partfit);
        if neifit < partfit
            
           particle = neighbor; 
        end
      end
    end
    POPULATION(indexParticle,:) = particle;
end

function [particle] = swap(particle,i,j)
    particle([i j]) = particle([j i]);
end
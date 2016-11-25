function Crossover()
  global POPULATION;
  global N_PARTICLES;
  global N_JOBS;
  global BEST_LOCAL;
  global N_OPERATIONS;
  
  parfor p=1:N_PARTICLES
      if(rand()<0.2)
        particle = POPULATION(p,:);
        bestlocaParticle = BEST_LOCAL(p,:);
        %selecionar particula random
        randPArticleIndex = randi([1 N_PARTICLES],1,1);
        randParticle = POPULATION(randPArticleIndex,:);
        
        [c1rand c2rand] = cross(particle,randParticle);
        [c1best c2best] = cross(particle,bestlocaParticle);
         
        crossedPopulation = [c1rand;c2rand;c1best;c2best];
        crossedFitness = Fitness(crossedPopulation);
        [minFit minIndex]  = min(crossedFitness);
         POPULATION(p,:) = crossedPopulation(minIndex,:);
       
        
       end 
   end    
 end 
  function [ch1,ch2] = cross(p1,p2)
        global OPERATIONS_PERJOBCELL;
        global N_JOBS;
        global N_OPERATIONS;
        randJobs = randperm(N_JOBS);
        randpoint = randi([1 N_JOBS-1],1,1);
        
        j1 = randJobs(1:randpoint);
        j2 = randJobs(randpoint+1:N_JOBS);

        parfor i=j1
           ch1(OPERATIONS_PERJOBCELL{i}) = p2(OPERATIONS_PERJOBCELL{i});
           ch2(OPERATIONS_PERJOBCELL{i}) = p1(OPERATIONS_PERJOBCELL{i}); 
        end
        parfor i=j2
           ch1(OPERATIONS_PERJOBCELL{i}) = p2(OPERATIONS_PERJOBCELL{i});
           ch2(OPERATIONS_PERJOBCELL{i}) = p1(OPERATIONS_PERJOBCELL{i}); 
        end
  end
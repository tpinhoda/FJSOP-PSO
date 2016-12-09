function [population] = CreatePopulation(type)
  perc = 0.1;
  switch type
    %%Escolhe-se o tipo de algoritmo, se é aleatório ou estocástico
    case 1 population = RandomPopulation();
    case 2 population = EstPopulation(perc);
  end  
  
end

function [population] = RandomPopulation() 
  %%Cria uma população aleatória
  global N_OPERATIONS;
  global N_PARTICLES;
  global TIME;
  population = [];
  for op=1:N_OPERATIONS
      
      machinesOp = find(TIME(op,:)!=0);

      randArray = randi([1 length(machinesOp)],1,N_PARTICLES);
      population = [population  machinesOp(randArray)'];
  end
end  

function [population] = EstPopulation(perc)
  %%Cria uma população estocástica com base nas regras de atribuição de Pezzella(2003)
  global N_OPERATIONS;
  global N_PARTICLES;
  global N_MACHINES;
  global TIME;
  global SCHEDULE
  population = zeros(N_PARTICLES, N_OPERATIONS);
  
  time = TIME;
  time(time==0)=10000;
  
  for p=1:N_PARTICLES
    opSequence = randperm(N_OPERATIONS);
    machSequence = randperm(N_MACHINES);
    for k=1:round(N_OPERATIONS*perc)
      [op mach] = find(time==min(min(time)));
      population(p, op(1))=mach(1);
      time(:,mach(1))= time(:,mach(1)) + time(op(1),mach(1));
      time(op(1),:)=10000;
    end  
    for op=opSequence
      if population(p,op) == 0
        mInd = machSequence(1);
        lowTime = time(op,machSequence(1));
        for mach=machSequence(2:N_MACHINES)
          if time(op,mach) < lowTime
            lowTime = time(op,mach);
            mInd = mach;
          end
        end
        time(:,mInd)+=lowTime;
        population(p, op)=mInd;
      end  
    end
    
    for mach=1:N_MACHINES
        time  = TIME;
        time(time==0) = 1000;
        
        arrayMach = find(population(p,:)==mach);
        for ind=1:length(arrayMach);
          [cost index] = min(time(arrayMach,mach));
          machSchedule(ind) = arrayMach(index);
          time(arrayMach(index),mach) = 1000;         
         end 
          
       SCHEDULE(p,mach) = machSchedule;
    end
    
  end
end  
        
        
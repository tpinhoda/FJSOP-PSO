function [population] = CalculateVelocity(type)
  
  switch type
    case 1 GeneralVelocity();
  end  
  
end

function GeneralVelocity() 
  
  global POPULATION;
  global BEST_GLOBAL;
  global BEST_LOCAL;
  global N_MACHINES;
  global N_OPERATIONS;
  global SCHEDULE;
  global N_PARTICLES;
  global TIME;
  global c0;
  global c1;
  global c2;
  %%Inicializa parâmetros
  v = ones(size(POPULATION));
  w = rand(1,N_OPERATIONS)*c0;
  r1 = rand(1,N_OPERATIONS)*c1;
  r2 = rand(1,N_OPERATIONS)*c2;
  
  %%Calcula velocidade 
  v = bsxfun(@times,w,v) + bsxfun(@times,r1,BEST_LOCAL - POPULATION) + bsxfun(@times,r2,BEST_GLOBAL - POPULATION);

  %move a particula
  POPULATION = round(POPULATION + v);
  POPULATION(POPULATION < 1) = 1;
  POPULATION(POPULATION > N_MACHINES) = N_MACHINES;

  ValidatePopulation(v);
  
  for p=1:N_PARTICLES
   for mach=1:N_MACHINES
      
      time  = TIME;
        time(time==0) = 1000;
        machSchedule = [];
        arrayMach = find(POPULATION(p,:)==mach);
        for ind=1:length(arrayMach);
          [cost index] = min(time(arrayMach,mach));
          machSchedule(ind) = arrayMach(index);
          time(arrayMach(index),mach) = 1000;         
         end 
          
       SCHEDULE(p,mach) = machSchedule;
   end
  end 
end  
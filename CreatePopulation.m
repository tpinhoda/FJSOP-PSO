function [population] = CreatePopulation(type)
  
  switch type
    case 1 population = RandomPopulation();
  end  
  
end

function [population] = RandomPopulation() 
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
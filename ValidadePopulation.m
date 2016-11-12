function ValidatePopulation(v)
  global POPULATION;
  global N_MACHINES;
  global N_PARTICLES;
  global N_OPERATIONS;
  global TIME;
  for p=1:N_PARTICLES
    for op=1:N_OPERATIONS
      direction = v(p,op)/(-(p,op));
      while(TIME(op,POPULATION(p,op)) == 0)
        POPULATION(p,op) = POPULATION(p,op)+= direction;
        if POPULATION(p,op) > N_MACHINES
          POPULATION(p,op) = 1;
        elseif POPULATION(p,op) = 0
          POPULATION(p,op) = 3;
        end
      end
    end
  end    
end
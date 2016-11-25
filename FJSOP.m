clear;
clc;
more off;
global OPERATIONS = load("benchmarks/op8x8.txt");
global TIME = load("benchmarks/Tempos8x8.txt");
global N_PARTICLES = 32;
global N_OPERATIONS = size(TIME,1);
global N_MACHINES = size(TIME,2);
global N_JOBS = size(OPERATIONS,2);
global BEST_LOCAL = [];
global POPULATION = [];
global BEST_GLOBAL = [];
global MAX_ITERATIONS = 1000;
c0 = 0.4;
c1 = 0.4;
c2 = 0.2;

for op=1:N_OPERATIONS
    
    machinesOp = find(TIME(op,:)!=0);

    randArray = randi([1 length(machinesOp)],1,N_PARTICLES);
    POPULATION = [POPULATION  machinesOp(randArray)'];
end

OpInMach = cell(N_PARTICLES,N_MACHINES);
for p=1:N_PARTICLES
  for m=1:N_MACHINES
    OpInMach(p,m) = find(POPULATION(p,:) == m);
  end    
end

%PrintGantt(5);

for p=1:N_PARTICLES
  BEST_LOCAL_FITNESS(p) = Fitness(p);
end 

BEST_LOCAL = POPULATION;
[bestFitness index] = min(BEST_LOCAL_FITNESS);
BEST_GLOBAL = BEST_LOCAL(index,:);
for i=1:MAX_ITERATIONS
 
%Busca local invertion na muda =/  
%  for p=1:N_PARTICLES
%    Invertion(p,0.8);
%  end
  
  v = ones(size(POPULATION));
  w = rand(1,N_OPERATIONS)*c0;
  r1 = rand(1,N_OPERATIONS)*c1;
  r2 = rand(1,N_OPERATIONS)*c2;

  v = bsxfun(@times,w,v) + bsxfun(@times,r1,BEST_LOCAL - POPULATION) + bsxfun(@times,r2,BEST_GLOBAL - POPULATION);

  POPULATION = round(POPULATION + v);
  POPULATION(POPULATION < 1) = 1;
  POPULATION(POPULATION > N_MACHINES) = N_MACHINES;

  ValidatePopulation(v);

  for p=1:N_PARTICLES
    pop_fitness(p) = Fitness(p);
    if pop_fitness(p) <= BEST_LOCAL_FITNESS(p)
        BEST_LOCAL(p,:) = POPULATION(p,:);
        BEST_LOCAL_FITNESS(p) = pop_fitness(p);
    end
  end
  
  [bestFitness index] = min(BEST_LOCAL_FITNESS);
  BEST_GLOBAL = BEST_LOCAL(index,:);

  printf("It: %d - Best: %d \n",i,bestFitness);
  
 
end



 
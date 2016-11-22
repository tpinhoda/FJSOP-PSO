clear;
clc;
global OPERATIONS = load("benchmarks/op10x10.txt");
global TIME = load("benchmarks/Tempos10x10.txt");
global N_PARTICLES = 40;
global N_OPERATIONS = size(TIME,1);
global N_MACHINES = size(TIME,2);
global N_JOBS = size(OPERATIONS,2);
global BEST_LOCAL = [];
global POPULATION = [];
global BEST_GLOBAL = [];
global MAX_ITERATIONS = 100;

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
  
  v = zeros(size(POPULATION));
  w = rand(1,N_PARTICLES);
  c1 = rand(N_PARTICLES,1);
  c2 = rand(N_PARTICLES,1);

  v = w*v + bsxfun(@times,c1,BEST_LOCAL - POPULATION) + bsxfun(@times,c2,BEST_GLOBAL - POPULATION);

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
  disp(bestFitness);
end



 
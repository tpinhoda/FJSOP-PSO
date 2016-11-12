

global OPERATIONS = load("benchmarks/op3x3.txt");
global TIME = load("benchmarks/Tempos3x3.txt");
global N_PARTICLES = 10;
global N_OPERATIONS = size(TIME,1);
global N_MACHINES = size(TIME,2);
global N_JOBS = size(OPERATIONS,2);
global BEST_LOCAL = [];
global POPULATION = [];
global BEST_GLOBAL = [];
global MAX_ITERATIONS = 5;

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
[min index] = min(BEST_LOCAL_FITNESS);
BEST_GLOBAL = BEST_LOCAL(index);
for i=1:MAX_ITERATIONS
  v = zeros(size(POPULATION));
  w = rand(N_PARTICLES,1);
  c1 = rand(N_PARTICLES,1);
  c2 = rand(N_PARTICLES,1);

  v = w*v + bsxfun(@times,(BEST_LOCAL - POPULATION)) + bsxfun(@times,(BEST_GLOBAL - POPULATION));

  POPULATION = round(POPULATION + v);
  POPULATION(POPULATION < 1) = 1;
  POPULATION(POPULATION > N_MACHINES) = N_MACHINES;
  POPULATION = ValidatePopulation(v);
  for p=1:N_PARTICLES
    pop_fitness(p) = Fitness(p);
  end
  
  
end



 
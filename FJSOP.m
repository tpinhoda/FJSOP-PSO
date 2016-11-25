clear;
clc;
more off;
global OPERATIONS = load("benchmarks/op8x8.txt");
global OPERATIONS_PERJOB;
global OPERATIONS_PERJOBCELL;
global TIME = load("benchmarks/Tempos8x8.txt");
global N_PARTICLES = 50;
global N_OPERATIONS = size(TIME,1);
global N_MACHINES = size(TIME,2);
global N_JOBS = size(OPERATIONS,2);
global BEST_LOCAL = [];
global POPULATION = [];
global BEST_GLOBAL = [];
global MAX_ITERATIONS = 1000;
global c0 = 0.4;
global c1 = 0.4;
global c2 = 0.2;

typePopulation = 1;
typeVelocity = 1;
typeSearch = 1;

%%Cria População
POPULATION = CreatePopulation(typePopulation);
OPERATIONS_PERJOB = zeros(length(OPERATIONS),max(OPERATIONS));
OPERATIONS_PERJOBCELL = cell(N_JOBS,1);
   for i=1:N_JOBS
      OPERATIONS_PERJOB(i,1:OPERATIONS(i))=[sum(OPERATIONS(1:i))-OPERATIONS(i)+1:sum(OPERATIONS(1:i))];
      OPERATIONS_PERJOBCELL(i)=[sum(OPERATIONS(1:i))-OPERATIONS(i)+1:sum(OPERATIONS(1:i))];
   end
   
  
%%Inicializa Lbest e GBest
BEST_LOCAL_FITNESS = Fitness(POPULATION);
BEST_LOCAL = POPULATION;
[bestFitness index] = min(BEST_LOCAL_FITNESS);
BEST_GLOBAL = BEST_LOCAL(index,:);

%%Comeco da Iterações
for i=1:MAX_ITERATIONS
    Crossover();
    
    parfor p=1:N_PARTICLES
      BuscaLocal(typeSearch,p);
      movedFitness = Fitness(POPULATION(p,:));
      if movedFitness <= BEST_LOCAL_FITNESS(p)
        BEST_LOCAL(p,:) = POPULATION(p,:);
        BEST_LOCAL_FITNESS(p) = movedFitness;
      end
    end
  
  [bestFitness index] = min(BEST_LOCAL_FITNESS);
  BEST_GLOBAL = BEST_LOCAL(index,:);
   
  %Cálculo da velocidade
   CalculateVelocity(typeVelocity);
  
  %Atualização dos lbests e gbests
  parfor p=1:N_PARTICLES
    movedFitness = Fitness(POPULATION(p,:));
    if movedFitness <= BEST_LOCAL_FITNESS(p)
        BEST_LOCAL(p,:) = POPULATION(p,:);
        BEST_LOCAL_FITNESS(p) = movedFitness;
    end
  end
  
  [bestFitness index] = min(BEST_LOCAL_FITNESS);
  BEST_GLOBAL = BEST_LOCAL(index,:);
%%  disp(BEST_LOCAL_FITNESS);
  printf("It: %d - Best: %d \n",i,bestFitness);
  %%---------------------------------  
 
end



 
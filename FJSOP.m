clear;
clc;
more off;
global OPERATIONS = load("benchmarks/op8x8.txt");
global OPERATIONS_PERJOB;
global OPERATIONS_PERJOBCELL;
global OPERATIONS_ID;
global JOB_ID;
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

typePopulation = 2;
typeVelocity = 1;
typeSearch = 2;

function setIDs()
    global OPERATIONS;
    global N_OPERATIONS;
    global OPERATIONS_ID;
    global JOB_ID;
    for i = 1:N_OPERATIONS;
      cumulativeSum = OPERATIONS(1);
      indJob = 1;
      while cumulativeSum < i
          indJob = indJob + 1;
          cumulativeSum = cumulativeSum + OPERATIONS(indJob);
      end
      JOB_ID(i)=indJob;
      OPERATIONS_ID(i)=OPERATIONS(indJob) - (cumulativeSum - i);
    end  
end

%%Cria População
POPULATION = CreatePopulation(typePopulation);
OPERATIONS_PERJOB = zeros(length(OPERATIONS),max(OPERATIONS));
OPERATIONS_PERJOBCELL = cell(N_JOBS,1);
 for i=1:N_JOBS
    OPERATIONS_PERJOB(i,1:OPERATIONS(i))=[sum(OPERATIONS(1:i))-OPERATIONS(i)+1:sum(OPERATIONS(1:i))];
    OPERATIONS_PERJOBCELL(i)=[sum(OPERATIONS(1:i))-OPERATIONS(i)+1:sum(OPERATIONS(1:i))];
 end
 setIDs();
   
  
%%Inicializa Lbest e GBest
BEST_LOCAL_FITNESS = BuscaLocal(POPULATION);
BEST_LOCAL = POPULATION;
[bestFitness index] = min(BEST_LOCAL_FITNESS);
BEST_GLOBAL = BEST_LOCAL(index,:);

%%Comeco da Iterações
for i=1:MAX_ITERATIONS
    

  %Cálculo da velocidade
   CalculateVelocity(typeVelocity);
  
  %Atualização dos lbests e gbests
  parfor p=1:N_PARTICLES
    movedFitness = BuscaLocal(POPULATION(p,:));
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



 
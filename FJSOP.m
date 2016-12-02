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
global c0 = 0.1;
global c1 = 0.4;
global c2 = 0.5;
global SCHEDULE = cell(N_PARTICLES,N_MACHINES);

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

coutFit = 0;
bestFitness = 0;
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
  
  [newbestFitness index] = min(BEST_LOCAL_FITNESS);
  if newbestFitness == bestFitness
    coutFit +=1;
  else
    bestFitness = newbestFitness;
    coutFit = 0;
  end  
  if coutFit == 20
    POPULATION = CreatePopulation(typePopulation);
      parfor p=1:N_PARTICLES
    movedFitness = BuscaLocal(POPULATION(p,:));
    if movedFitness <= BEST_LOCAL_FITNESS(p)
        BEST_LOCAL(p,:) = POPULATION(p,:);
        BEST_LOCAL_FITNESS(p) = movedFitness;
    end
  end
  
  [newbestFitness index] = min(BEST_LOCAL_FITNESS);

    coutFit = 0;
  end
  disp(coutFit); 
  BEST_GLOBAL = BEST_LOCAL(index,:);
 %% disp(POPULATION);
%%
  printf("It: %d - Best: %d \n",i,bestFitness);
  %%---------------------------------  
 
end



 
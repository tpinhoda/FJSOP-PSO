clear;
clc;
more off;
global OPERATIONS = load("benchmarks/op4x5.txt");
global TIME = load("benchmarks/tempos4x5.txt");

global OPERATIONS_PERJOB;     %%Opera��es de cada job
global OPERATIONS_PERJOBCELL; %%Opera��es feitas por cada m�quina
global OPERATIONS_ID;         %%Index de cada opera��o no roteamento 
global JOB_ID;                %%Index de cada oper��o no seu job

global N_PARTICLES = 30;            %%N�mero de part�culas que a nuvem ter�
global N_OPERATIONS = size(TIME,1); %%Quantidade de oper��es
global N_MACHINES = size(TIME,2);   %%Quantidade  de m�quinas
global N_JOBS = size(OPERATIONS,2); %%Quantidade de jobs
global BEST_LOCAL = [];             %%Matriz de melhores locais
global POPULATION = [];             %%Nuvem de part�culas
global BEST_GLOBAL = [];            %%Melhor part�cula
global MAX_ITERATIONS = 1000;       %%Quantidade de iter��es do PSO
global c0 = 0.2;                    %%Probabilidade da part�cula seguir seu caminho
global c1 = 0.4;                    %%Probabilidade da part�cula seguir para o melhor local
global c2 = 0.6;                    %%Probabilidade da part�cula seguir para o melhor global
global SCHEDULE = cell(N_PARTICLES,N_MACHINES); %%Matriz que possui o agendamento de todas as part�culas da nuvem

typePopulation = 2;                 %%
typeVelocity = 1;                   %%Tipos de algoritmos escolhidos (Ver scripts)
typeSearch = 2;                     %%  

function setIDs()
 %%Fun��o que cria os vetores JOB_ID e OPERATIONS_ID 
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
hist = [];
tic
%%Cria Popula��o
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
%%Comeco da Itera��es
for i=1:MAX_ITERATIONS
    

  %C�lculo da velocidade
   CalculateVelocity(typeVelocity);
  
  %Atualiza��o dos lbests e gbests
  movedFitness = BuscaLocal(POPULATION);
  improved = find(movedFitness <= BEST_LOCAL_FITNESS);
  BEST_LOCAL(improved,:) = POPULATION(improved,:);
  BEST_LOCAL_FITNESS(improved) = movedFitness(improved);
  
  [newbestFitness index] = min(BEST_LOCAL_FITNESS);
  if newbestFitness == bestFitness
    coutFit +=1;
  else
    bestFitness = newbestFitness;
    coutFit = 0;
  end  
  if coutFit == 5
    POPULATION = CreatePopulation(typePopulation);
    movedFitness = BuscaLocal(POPULATION);
    improved = find(movedFitness <= BEST_LOCAL_FITNESS);
    BEST_LOCAL(improved,:) = POPULATION(improved,:);
    BEST_LOCAL_FITNESS(improved) = movedFitness(improved);
  
    [bestFitness index] = min(BEST_LOCAL_FITNESS);
    coutFit = 0;
  end
 
    BEST_GLOBAL = BEST_LOCAL(index,:);

  printf("It: %d - Best: %d \n",i,bestFitness);
  hist = [hist bestFitness];
  %%---------------------------------  
 
end
toc



 
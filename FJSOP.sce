OPERATIONS = fscanfMat("benchmarks/op3x3.txt");
TIME = fscanfMat("benchmarks/Tempos3x3.txt");
N_PARTICLES = 10;
N_OPERATIONS = size(TIME,1);
N_MACHINES = size(TIME,2);
N_JOBS = size(OPERATIONS,2);

POPULATION = []
for op=1:N_OPERATIONS
    machinesOp = find(TIME(op,:)<>0);
    randArray = grand(1, N_PARTICLES, "uin", 1, length(machinesOp));
    POPULATION = [POPULATION  machinesOp(randArray)'];
end

OpInMach = cell(N_PARTICLES,N_MACHINES);
for p=1:N_PARTICLES
    for m=1:N_MACHINES
        OpInMach(p,m).entries = find(POPULATION(p,:) == m) 
    end    
end



function Invertion(indX,c1)
%%    Faz sucessivas inversões em uma dada partícula x_p com uma probabilidade pr_1 dessas inversões serem feitas, 
%%    além de sempre checar a aptidão das novas partículas geradas a fim de sempre manter a  que possui melhor aptidão
    global POPULATION;
    global N_OPERATIONS;
    
    xFitness = Fitness(indX); 
    for i=1:N_OPERATIONS
        j = 1;
        while j+i <= N_OPERATIONS
            if(rand() < c1) 
                oldParticle = POPULATION(indX,:);
                oldFitness  = xFitness;
                
                POPULATION(indX,:) = reverse(oldParticle,[j;j+i]);
                v = zeros(size(POPULATION));
                
                ValidatePopulation(v);
                
                xFitness = Fitness(indX);
                if(xFitness >= oldParticle) 
                    POPULATION(indX,:) = oldParticle;
                    xFitness = oldFitness;
                end    
            end    
            j = j+i+1;
        end         
    end
end

function x = reverse(x, pairs)
%%    Realiza um inversão em um sub-caminho de índices pairs = [i,j] de uma partícula x_p
    for p=pairs
        if p(1) > p(2)
            p([1 2]) = p([2 1]);
        end
        x([p(1):p(2)]) = x([p(2):-1:p(1)]);
    end
end
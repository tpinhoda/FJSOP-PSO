clc;
clear;
hist=[];
best=[];
global esquedjule;
parfor run=1:10
  [best(run,:) sched(run,:) hist(run,:)]=FJSOP();
   printf("%d\n",hist(run,end));
end
disp(hist(:,end));
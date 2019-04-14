close all
clear all
clc

D = 100; %number of units
patterns = [];
stable_state_previous = 0;
stable_count = zeros(1,300);

for a=1:300    
    vector = sign(-1 + 2*rand(1,D));    
    
    %i = randi(30,[1,D]);
    %vector(i) = -vector(i); %random flipping
    
    vector = sign(0.5+randn(1,D)) ; %biased random vector
        
    patterns = [patterns; vector];
    N = size(patterns,1); %number of patterns
    D = size(patterns,2); %number of neurons = nr. columns in pattern
    %Training 
    W = zeros(D,D);
    for n =1:N
        x = patterns(n,:);
        W = x'*x + W;
    end
    W = (W - diag(diag(W)))/N;

    %Asynch
    for ind=1:N
        iterate = 1;
        x_p = patterns(ind,:); 
        x = x_p;
        count = 1;
        while(iterate)   
            index = randperm(D);
            for j = 1:length(index)
                E_iteration(ind,count) = -x*(W*x');
                count = count +1;
                i = index(j);
                x(i) = sign(W(i,:)*x');
            end
            iterate = ~(isequal(x,x_p));
            x_p = x;
        end
        stable_states(ind,:) = x;
        iteration(ind) = count;
    end 
    if (a==1)
       difference = (sum(stable_states(1,:) - stable_state_previous , 2));
    else
        difference = (sum(stable_states(1:a-1,:) - stable_state_previous , 2));
    end
    
    for i=1:length(difference)
        if (difference(i) == 0)
            stable_count(a-1) = stable_count(a-1) + 1;
        end
    end
    stable_state_previous = stable_states;
end


figure
plot(stable_count)
title('Stable states for number of patterns')
xlabel('N° of patterns')


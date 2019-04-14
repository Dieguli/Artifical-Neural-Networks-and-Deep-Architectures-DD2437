close all
clear all
clc

D = 100; %number of units
patterns = [];
stable_state_previous = 0;
stable_count = zeros(1,300);

R = 5;
for repeat=1:R
    %for a=1:300
    for a=1:(100/R)
        % Generate sparse vector
        rho = 0.1; %percentage of sparseness
        vector = zeros(1,D);
        i = randi(D,[1,rho*D]); %extract a random indeces
        vector(i) = 1;
        patterns = [patterns; vector];
    end

    N = size(patterns,1); %number of patterns
    D = size(patterns,2); %number of neurons = nr. columns in pattern
    stable_states = zeros(N,D);
    iteration = zeros(1,N);

    %Training 
    W1 = zeros(D,D);
    W = zeros(D,D);
    for mu=1:size(patterns,1)
        x = patterns(mu,:);    
        for i=1:size(W,1)
            for j=1:size(W,2)
                W1(i,j) = (x(i)-rho)*(x(j)-rho);
            end
        end
        W = W+W1;
    end
    % W = zeros(D,D);
    % for mu =1:N
    %     x = patterns(mu,:);
    %     x = patterns - rho;
    %     W = x'*x + W;
    % end
    W = (W - diag(diag(W))); %/N;

    theta = [0.1 0.3 0.7 1];
    errors = zeros(N,length(theta));
    for t=1:length(theta)
        %Asynch
        for ind=1:N
            iterate = 1;
            x_p = patterns(ind,:); 
            x = x_p;
            count = 1;
            while(iterate)   
                index = randperm(D);
                for j = 1:length(index)
                    %E_iteration(ind,count) = -x*(W*x');
                    count = count +1;
                    i = index(j);
                    x(i) = 0.5 + 0.5*sign( W(i,:)*x' - theta(t) );
                end
                iterate = ~(isequal(x,x_p));
                x_p = x;
            end
            stable_states(ind,:) = x;
            iteration(ind) = count;
        end
        errors(:,t) = sum(stable_states - patterns,2);
    end

    correct = zeros(1,length(theta));
    for t=1:length(theta)
        for l=1:size(errors,1)
            if (errors(l,t)==0)
                correct(t) = correct(t) +1;
            end
        end
    end
    correct
    
    display('press a key to continue')
    pause
end
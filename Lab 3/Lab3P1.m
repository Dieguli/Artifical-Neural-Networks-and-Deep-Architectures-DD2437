close all
clear all
clc

patterns = [-1 -1 1 -1 1 -1 -1 1;...
            -1 -1 -1 -1 -1 1 -1 -1;...
            -1 1 1 -1 -1 1 -1 1]; %patterns stored row-wise
N = size(patterns,1); %number of patterns
D = size(patterns,2); %number of neurons = nr. columns in pattern

%Training 
W = zeros(D,D);
for n =1:N
    x = patterns(n,:);
    W = x'*x + W;
end
W = (W - diag(diag(W)))/N; %CONVERGES ONLY with the diagonal


%Check if the networks recalls
errors = ones(1,N)*(-999);
for ind=1:N
    x_recall = sign( W * (patterns(ind,:))' ); %produces a column-wise output for the state of neurons
    errors(ind) = sum(x_recall' - patterns(ind,:));
end


% Try with distorted inputs
patterns_d= [1 -1 1 -1 1 -1 -1 1;...
            1 1 -1 -1 -1 1 -1 -1;...
            1 1 1 -1 1 1 -1 1];  %distorted version of patterns
        
N = size(patterns_d,1);
stable_states = zeros(N,D);
iteration = zeros(1,N);

%Synch
for ind=1:N
    iterate = 1;
    x_p = (patterns_d(ind,:))';
    while(iterate)
        x = sign(W*x_p); %produces a column-wise output for the state of neurons
        iterate = ~(isequal(x,x_p));
        x_p = x;
        iteration(ind) = iteration(ind) +1;
    end
    stable_states(ind,:) = x';
end

%Asynch
% for ind=1:N
%     iterate = 1;
%     x_p = (patterns_d(ind,:))';
%     while(iterate)
%         x = sign(W*x_p); %produces a column-wise output for the state of neurons
%         iterate = ~(isequal(x,x_p));
%         x_p = x;
%         iteration(ind) = iteration(ind) +1;
%     end
%     stable_states(ind,:) = x';
% end





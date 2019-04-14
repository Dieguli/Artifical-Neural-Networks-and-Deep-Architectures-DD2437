close all
clear all
clc

%Reading patterns
load('pict.dat');
p1 = pict (1,1:1024);
p2 =  pict (1,1025:2048);
p3 =  pict (1,2049:3072);
p4 =  pict (1,3073:4096);
p5 =  pict (1,4097:5120);
p6 =  pict (1,5121:6144);
p7 =  pict (1,6145:7168);
p8 =  pict (1,7169:8192);
p9 =  pict (1,8193:9216);
p10 =  pict (1,9217:10240); %degarded version og p1
p11 =  pict (1,10241:11264); %mixture of p2and p3  
%patterns = [p1;p2;p3;p4;p5;p6;p7;p8;p9;p10;p11];

patterns = [p1;p2;p3];
N = size(patterns,1); %number of patterns
D = size(patterns,2); %number of neurons = nr. columns in pattern

%Training 
W = zeros(D,D);
for n =1:N
    x = patterns(n,:);
    W = x'*x + W;
end
W = (W - diag(diag(W)))/N;

% draw(p1) %see the datasets
% draw(p2)
% draw(p3)

patterns_d = [p10;p11];

draw(p10);
draw(p11);

N = size(patterns_d,1);
stable_states = zeros(N,D);
iteration = zeros(1,N);


%Asynch
for ind=1:N
    iterate = 1;
    x_p = patterns_d(ind,:); 
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

draw(stable_states(1,:)) %see the reconstructed images
draw(stable_states(2,:))

%Attractors
E = zeros(1,size(patterns,1));
for i=1:size(patterns,1)
    x = patterns(i,:);
    E(i) = -x*(W*x');
end

%Distrorted
E_d = zeros(1,size(patterns_d,1));
for i=1:size(patterns_d,1)
    x = patterns_d(i,:);
    E_d(i) = -x*(W*x');
end

figure
hold on
grid on
% plot(E_iteration(1,1:iteration(1)),'+-')
% plot(E_iteration(2,1:iteration(2)),'+-')
non_zero_ind1 = find( E_iteration(1,:));
non_zero_ind2 = find( E_iteration(2,:));
plot(E_iteration(1,1:non_zero_ind1(end)),'-')
plot(E_iteration(2,1:non_zero_ind2(end)),'-')


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

patterns = [p1;p2;p3;p4;p5];
N = size(patterns,1); %number of patterns
D = size(patterns,2); %number of neurons = nr. columns in pattern

%Training 
W = zeros(D,D);
for n =1:N
    x = patterns(n,:);
    W = x'*x + W;
end
W = (W - diag(diag(W)))/N;


n=300; % moderate percentage of flipping
i = randi(n,[1,D]);
p1(i) = -p1(i);
p2(i) = -p2(i);
p3(i) = -p3(i); 
p4(i) = -p4(i);
p5(i) = -p5(i);
p6(i) = -p6(i);
p7(i) = -p7(i);
patterns_d = [p1;p2;p3;p4;p5];
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

sum(stable_states - patterns,2)

figure
title('Energy')
hold on
grid on
non_zero_ind1 = find( E_iteration(1,:));
non_zero_ind2 = find( E_iteration(2,:));
non_zero_ind3 = find( E_iteration(3,:));
non_zero_ind4 = find( E_iteration(4,:));
%non_zero_ind5 = find( E_iteration(5,:));
%non_zero_ind6 = find( E_iteration(6,:));
plot(E_iteration(1,1:non_zero_ind1(end)),'-')
plot(E_iteration(2,1:non_zero_ind2(end)),'-')
plot(E_iteration(3,1:non_zero_ind3(end)),'-')
plot(E_iteration(4,1:non_zero_ind4(end)),'-')
%plot(E_iteration(5,1:non_zero_ind4(end)),'-')
%plot(E_iteration(6,1:non_zero_ind4(end)),'-')

clear all
close all
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


for n=1:200:D %for different percentage of flipping
    i = randi(n,[1,D]);
    p1(i) = -p1(i);
    p2(i) = -p2(i);
    p3(i) = -p3(i);   
    patterns_d = [p1;p2;p3];
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
    
    %plot results in a single image
    v1d = reshape(p1,32,32);
    v2d = reshape(p2,32,32);
    v3d = reshape(p3,32,32);   
    
    v1 = reshape(stable_states(1,:),32,32);
    v2 = reshape(stable_states(2,:),32,32);
    v3 = reshape(stable_states(3,:),32,32);      
    x = 1:32;
    y = 1:32;

    figure();
    hold on
    title(['Number of flipped elements: ' int2str(n)])
    for a=1:size(x,2)    
        for b=1:size(y,2)
            %plot distorted images
            if (v1d(a,b) == 1)
                subplot(2,3,1)
                    plot(x(a),y(b),'sk')
                    hold on
            end            
            if (v2d(a,b) == 1)
                subplot(2,3,2)
                    plot(x(a),y(b),'sk')
                    hold on
            end
            if (v3d(a,b) == 1)
                subplot(2,3,3)
                    plot(x(a),y(b),'sk')
                    hold on
            end   
            %plot recovered images
            if (v1(a,b) == 1)
                subplot(2,3,4)
                    plot(x(a),y(b),'sk')
                    hold on
            end            
            if (v2(a,b) == 1)
                subplot(2,3,5)
                    plot(x(a),y(b),'sk')
                    hold on
            end
            if (v3(a,b) == 1)
                subplot(2,3,6)
                    plot(x(a),y(b),'sk')
                    hold on
            end
        end
    end
    print([int2str(n) '_flips'],'-dpng')
end
clc
clear all
close all

load('votes.dat');
politicians = zeros(349,31);
for row=1:349
    politicians(row,:) = votes((row-1)*31+1 : row*31);
end

eta_step = 0.2;
n_neurons = 100; 
gridx = -1*ones(10,10); % 10x10 grid
neurone = 1; %starting neuron
for a=1:10
    for b=1:10
        gridx(a,b)= neurone;
        neurone = neurone + 1;
    end
end
clear neurone a b

w =  rand(n_neurons,31); %randomly initialized weights € [0,1]
%politicians = politicians(:,1:3); %for debug

Ep_max = 20;
initial_neigh = 3;
initial_w = w;

%Train
for epoch=1:Ep_max
    neighbourhood_dim = neighbourhood3(epoch,Ep_max,initial_neigh); %at each epoch reduce the neighbourhood
    politicians = politicians(randperm(size(politicians,1)),:);
    
    for ind=1:size(politicians,1)
        mp = politicians(ind,:); %take the single MP and train the network with an online approach
        distance = sqrt(sum( (mp - w).^2 ,2));
        [~, winn_index] = min(distance); %find the winning neuron
        %neighbours_inds = find_neighbour_old(w,index,neighbourhood_dim);
        neighbours_inds = find_neighbour(gridx,winn_index,neighbourhood_dim);
        %w(index,:) = w(index,:) + eta_step*(mp-w(index,:));        
        if (size(neighbours_inds,1) ~=0)
            %w(neighbours_inds,:) = w(neighbours_inds,:)  + eta(index,neighbours_inds,eta_step,w) .* (mp-w(neighbours_inds,:)); 
            % VA CAMBIATA LA FUNZIONE ETA( funzione DELLA GRID E NON DEI
            % PESI!!!!)
            w(neighbours_inds,:) = w(neighbours_inds,:)  + eta(winn_index,neighbours_inds,eta_step,gridx,neighbourhood_dim) .* (mp-w(neighbours_inds,:)); 
        end
    end
end

%Classify
neuron = zeros(size(politicians,1),1);
for ind=1:size(politicians,1)
     mp = politicians(ind,:); 
     distance = sum( (mp - w).^2 , 2);
     [~, neuron(ind)] = min(distance); %find the winner neuron, and aasign the ind-th mp to it
end

load('names.mat');
load('mpdistrict.dat');
load('mpparty.dat');
load('mpsex.dat');

% Gender
N = size(w,1);
male = zeros(N,1);
female = zeros(N,1);
for i=1:size(politicians,1)
    neruon_pointer = neuron(i);
    if mpsex(i)==0
        male(neruon_pointer) = male(neruon_pointer) +1;
    else
        female(neruon_pointer) = female(neruon_pointer) +1;
    end 
end

x_for_plot = 1:size(w,1);
figure
plot(x_for_plot,male,'+')
hold on
plot(x_for_plot,female,'+')
grid on
title('Gender per node')
xlabel('Nodes')
legend('Male','Female')



%District
for i_district=1:29
    saved = [];
    for i=1:size(politicians,1)
        if (mpdistrict(i) == i_district)
            already_present = 0;
            for l=1:length(saved)
                if neuron(i)==saved(l)
                   already_present = 1;
                end
            end
            if already_present==0
                saved = [saved, neuron(i)];
            end
        end
%        display(['Neuron ', int2str(neuron(i)), ' belongs to district ', int2str(mpdistrict(i))])
    end
    display(['District ', int2str(i_district), ' contains neurons: ', int2str(saved)])
end



%Parties
figure(2)
hold on
grid on
for i=1:size(politicians,1)
    switch mpparty(i)
        case 0
            plot(1,neuron(i),'sb')
        case 1
            plot(2,neuron(i),'dg')
        case 2
            plot(3,neuron(i),'pr')
        case 3
            plot(4,neuron(i),'^c')
        case 4
            plot(5,neuron(i),'vm')
        case 5
            plot(6,neuron(i),'hy')
        case 6
            plot(7,neuron(i),'ok')
        case 7
            plot(8,neuron(i),'+')
    end
end
title('Parties among nodes')
xlabel('Party')
xticklabels({'No party','M','Fp','S','V','Mp','Kd','C'})
axis([0 9 -inf inf])
ylabel('Nodes')


for i=1:size(politicians,1)
    switch mpparty(i)
        case 0
            % find the coordinates for that neuron in the grid
            matrix = abs(gridx-neuron(i));
            minMatrix = min(matrix(:)); 
            [row,col] = find(matrix==minMatrix);            
            figure(3)
                plot(row,col,'sb') %plot that neuron
                title('No party')
                hold on
                grid on             
                axis([0 10 0 10])
        case 1
            % find the coordinates for that neuron in the grid
            matrix = abs(gridx-neuron(i));
            minMatrix = min(matrix(:)); 
            [row,col] = find(matrix==minMatrix);            
            figure(4)
                plot(row,col,'dg') %plot that neuron
                title('M party')
                hold on
                grid on
                axis([0 10 0 10])
        case 2
            % find the coordinates for that neuron in the grid
            matrix = abs(gridx-neuron(i));
            minMatrix = min(matrix(:)); 
            [row,col] = find(matrix==minMatrix);            
            figure(5)
                plot(row,col,'pr') %plot that neuron
                title('Fp party')
                hold on
                grid on
                axis([0 10 0 10])
        case 3
            % find the coordinates for that neuron in the grid
            matrix = abs(gridx-neuron(i));
            minMatrix = min(matrix(:)); 
            [row,col] = find(matrix==minMatrix);            
            figure(6)
                plot(row,col,'^c') %plot that neuron
                title('S party')
                hold on
                grid on
                axis([0 10 0 10])
        case 4
            % find the coordinates for that neuron in the grid
            matrix = abs(gridx-neuron(i));
            minMatrix = min(matrix(:)); 
            [row,col] = find(matrix==minMatrix);            
            figure(7)
                plot(row,col,'vm') %plot that neuron
                title('V party')
                hold on
                grid on
                axis([0 10 0 10])
        case 5
            % find the coordinates for that neuron in the grid
            matrix = abs(gridx-neuron(i));
            minMatrix = min(matrix(:)); 
            [row,col] = find(matrix==minMatrix);            
            figure(8)
                plot(row,col,'hr') %plot that neuron
                title('Mp party')
                hold on
                grid on
                axis([0 10 0 10])
        case 6
            % find the coordinates for that neuron in the grid
            matrix = abs(gridx-neuron(i));
            minMatrix = min(matrix(:)); 
            [row,col] = find(matrix==minMatrix);            
            figure(9)
                plot(row,col,'ok') %plot that neuron
                title('Kd party')
                hold on
                grid on
                axis([0 10 0 10])
        case 7
           % find the coordinates for that neuron in the grid
            matrix = abs(gridx-neuron(i));
            minMatrix = min(matrix(:)); 
            [row,col] = find(matrix==minMatrix);            
            figure(10)
                plot(row,col,'+') %plot that neuron
                title('C party')
                hold on
                grid on
                axis([0 10 0 10])
    end
end
print(figure(3),'noparty', '-djpeg')
print(figure(4),'mparty', '-djpeg')
print(figure(5),'fpparty', '-djpeg')
print(figure(6),'sparty', '-djpeg')
print(figure(7),'vparty', '-djpeg')
print(figure(8),'mpparty', '-djpeg')
print(figure(9),'kdparty', '-djpeg')
print(figure(10),'cparty', '-djpeg')

figure(11)
hold on
grid on
for a=1:size(gridx,1)
    for b=1:size(gridx,2)
        plot(a,b,'.k')
    end
end
axis([0 10 0 10])
title('Neuron 2D grid')
print('neuron_grid', '-djpeg')



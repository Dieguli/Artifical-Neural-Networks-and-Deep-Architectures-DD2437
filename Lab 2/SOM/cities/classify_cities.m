clc
%clear all
close all

load('cities.dat');

eta_step = 0.2;
n_neurons = 10;
w =  rand(n_neurons,2); %randomly initialized weights € [0,1]
Ep_max = 20;

%Train
for epoch=1:Ep_max
neighbourhood_dim = neighbourhood2(epoch,Ep_max); %at each epoch reduce the neighbourhood

    for ind=1:size(cities,1)
        city = cities(ind,:); %take the single city and train the network with an online approach
        A = repmat(city,size(w,1),1);
        distance = sum( (A - w).^2 , 2);
        [~, index] = min(distance); %find the winning neuron
        w = update_neighb2(w,index,neighbourhood_dim,city,eta_step);
        %w = update_neighb(w,index,neighbourhood_dim,city,eta_step); %wrong
        %update, without imposing the closed loop condition on neurons
        
    end
end


%Classify
neuron = zeros(size(cities,1),1);
for ind=1:size(cities,1)
    city = cities(ind,:); %take the single city and train the network with an online approach
    A = repmat(city,size(w,1),1);
    distance = sum( (A - w).^2 , 2);
    [~, neuron(ind)] = min(distance); %find the winner neuron, and aasign the ind-th city to it
end
[~,i] = sort(neuron);
cities = [cities, (1:10)'];
ordered_cities = cities(i,:);
w(end,:) = w(1,:); %in order to draw a closed path.

figure(1)
subplot(1,2,1)
    hold on
    plot(ordered_cities(:,1),ordered_cities(:,2),'*k')
    plot(w(:,1),w(:,2),'b')
    plot(w(:,1),w(:,2),'*b')
    plot(w(1,1),w(1,2),'pg')
    plot(w(end-1,1),w(end-1,2),'pr')
    legend('Cities','Path','','Starting point','End point')
    grid on
subplot(1,2,2)
    plot(ordered_cities(:,1),ordered_cities(:,2),'*k')
    grid on
    legend('Cities')

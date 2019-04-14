clc
clear all
close all
% load('animals.dat'); on ubuntu I didn't see as a matrix so I translated
% into a matrix because the idiot is an idiot!
% props = zeros(32,84);
% for row=1:32
%     props(row,:) = animals((84*(row-1)+1):84*row);

%     props(:,col) = animals((84*(row-1)+1):84*row); mi sa che sono column
%     wise
% end

load('data.mat');
neighbourhood_initial = 50;
eta_step = 0.2;
n_neurons = 100;
w =  rand(n_neurons,84); %randomly initialized weights
w = normalize_weights(w);

%Train
for epoch=1:20
neighbourhood_dim = neighbourhood(epoch,20,neighbourhood_initial); %at each epoch reduce the neighbourhood

    for ind=1:size(props,1)
        animal = props(ind,:); %take the single animal and train the network with an online approach
        A = repmat(animal,size(w,1),1);
        distance = sqrt(sum( (A - w).^2 , 2));
        [~, index] = min(distance); %find the winner neuron
        w = update_neighb(w,index,neighbourhood_dim,animal,eta_step);
        w(index,:) = w(index,:) + eta_step* (animal - w(index,:));
        %w = normalize_weights(w);
    end
end

%Classify
classes = zeros(size(props,1),1);
for ind=1:size(props,1)
    animal = props(ind,:); %take the single animal and train the network with an online approach
    A = repmat(animal,size(w,1),1);
    distance = sqrt(sum( (A - w).^2 , 2));
    [~, classes(ind)] = min(distance); %find the winner neuron, and aasign the ind-th animal to it
end

[classes,sort_ind] = sort(classes);
animal_names = animal_names(sort_ind);

for ind=1:size(animal_names,1)
    display([char(animal_names(ind)), ' & ', int2str(classes(ind)), ' \\']) %format the output for LaTeX
end

%table(animal_names,classes)



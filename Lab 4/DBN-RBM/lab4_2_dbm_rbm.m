clc
%clear all
close all

load('../binMNIST_data/binMNIST.mat');
addpath('/home/sergio/Documents/Add-Ons/Toolboxes/Deep Neural Network/code/DeepNeuralNetwork');


TrainImages = bindata_trn;
TrainLabels = digtargets_trn;
TestImages = bindata_tst;
TestLabels = digtargets_tst;

nodes = [784 100 1]; % 1 hidden layer (2rbms)
%nodes = [784 150 75 1]; % 2 hidden layers
%nodes = [784 150 75  25 1]; % 3 hidden layers (4rbms)

tic

%% train the DBN
bbdbn = randDBN( nodes, 'BBDBN' );
nrbm = numel(bbdbn.rbm);
opts.MaxIter = 1000;
opts.BatchSize = 100;
opts.Verbose = true;
opts.StepRatio = 0.1;
opts.object = 'CrossEntropy';
opts.Layer = nrbm-1;
bbdbn = pretrainDBN(bbdbn, TrainImages); %, opts);
bbdbn= SetLinearMapping(bbdbn, TrainImages, TrainLabels);
opts.Layer = 0;
bbdbn = trainDBN(bbdbn, TrainImages, TrainLabels);% opts);
save('mnistbbdbn.mat', 'bbdbn' );
%}
%% train the MLP with backprop
net = feedforwardnet(30); %because the first layer is the the input layer and the last one is the output
net = configure(net,TrainImages', TrainLabels');
net = train(net,TrainImages', TrainLabels');
%%
load('mnistbbdbn.mat')
rmse= CalcRmse(bbdbn, TrainImages, TrainLabels);
ErrorRate= CalcErrorRate(bbdbn, TrainImages, TrainLabels);
fprintf( 'For training data:\n' );
fprintf( 'rmse: %g\n', rmse );
fprintf( 'ErrorRate: %g\n', ErrorRate );

rmse= CalcRmse(bbdbn, TestImages, TestLabels);
ErrorRate= CalcErrorRate(bbdbn, TestImages, TestLabels);
fprintf( 'For test data:\n' );
fprintf( 'rmse: %g\n', rmse );
fprintf( 'ErrorRate: %g\n', ErrorRate );

error= CalcError(bbdbn, TestImages, TestLabels);
figure()
    grid on
    plot(error,'b')
    hold on
    plot([0,length(error)], [rmse,rmse],'r')
    title('Error on test dataset')
    legend('Error per single test data','RMSE')
 print([num2str(num_stacked_rbm) '_rbms_error'], '-dpng', '-r0')


%% 
num_stacked_rbm = size(bbdbn.rbm,1);
for i=1:num_stacked_rbm
W_matrix = bbdbn.rbm{i}.W;
figure;  
    %set(f, 'Title', ['Weigths of layer ' num2str(i) 'for each output node:']);
    grid on
    switch i
        case 1
            a1 = sqrt(size(W_matrix,1));
            a2 = sqrt(size(W_matrix,1));
        case 2
            a1 = 10;
            a2 = 15;
        case 3
            a1 = 15;
            a2 = 5;
        case 4
            a1 = sqrt(size(W_matrix,1));
            a2 = sqrt(size(W_matrix,1));
    end
    num_nodes = size(W_matrix,2);
    for r=1:num_nodes
        if (num_nodes == 75)
            u = ceil(sqrt(num_nodes))+1; %faccio questo perchè voglio sia tutto automatico, e 
                    % 8sqrt(75) =8.6 --> allora 8*9 = 72, quindi devo fare 8*10
        else
            u = ceil(sqrt(num_nodes));
        end
        subplot(u,floor(sqrt(num_nodes)),r)
        imshow((reshape(W_matrix(:,r),a1,a2))')
        title(num2str(r))
    end
    set(gcf, 'Position', get(0, 'Screensize'));
    print([num2str(num_stacked_rbm) '_rbms_layer_' num2str(i) '_weights'], '-dpng', '-r0')
end
toc

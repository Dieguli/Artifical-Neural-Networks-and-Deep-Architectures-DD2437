clc
clear all
close all

% X= load('binMNIST.mat');
% imshow(reshape(X(k,:),28,28));
load('binMNIST.mat');
num_visible = 784;
trained = 0;
num_hidden_1 = 25;
num_hidden_2= 10;
learning_rate = 0.1;
max_epochs = 10;

%To initialize with same seed always
rng('default');

%Put the tags correctly (binary indicating position)
digtargets2_trn=zeros(length(digtargets_trn),10);
for i=1:length(digtargets_trn)
    %if(digtargets_trn(i)+1~=10)
        digtargets2_trn(i,digtargets_trn(i)+1)=1;
   % end
end

%Same as before but with tests
digtargets2_tst=zeros(length(digtargets_tst),10);
for i=1:length(digtargets_tst)
    %if(digtargets_tst(i)+1~=10)
        digtargets2_tst(i,digtargets_tst(i)+1)=1;
    %end
end

err=zeros(1,length(1:100:1000));
counter=1;
%Iterate number of epochs to obtain the error
for max_epochs=1:100:1000
    autoenc1 = trainAutoencoder(bindata_trn',num_hidden_1, 'MaxEpochs',max_epochs, 'ScaleData', false);
    features1 = encode(autoenc1,bindata_trn');
    deco1=decode(autoenc1, features1);
    err(counter)=(1/784)*trace((bindata_trn'-deco1)*(bindata_trn'-deco1)');
    counter=counter+1;
end
plot(1:100:1000, err);

%Training autoencoder 2
autoenc2 = trainAutoencoder(features1,num_hidden_2, 'MaxEpochs', max_epochs,'ScaleData',false);
%Encoding the output from autoencoder 1
features2 = encode(autoenc2,features1);
%Softmax layer for best handling outputs
softnet = trainSoftmaxLayer(features2,digtargets2_trn','MaxEpochs',max_epochs);
%Stacking all
deepnet = stack(autoenc1,autoenc2,softnet);
%Fun visualization
view(deepnet);
%Compute the output of the test data
y = deepnet(bindata_tst');
%Plotting confusion matrix (it is bad because not supervised has been done)
%plotconfusion(digtargets2_tst',y);

%Train the deepnet supervisedly
deepnet = train(deepnet,bindata_trn',digtargets2_trn');
%Output and confusion matrix (now improved)
y = deepnet(bindata_tst');
plotconfusion(digtargets2_tst',y);

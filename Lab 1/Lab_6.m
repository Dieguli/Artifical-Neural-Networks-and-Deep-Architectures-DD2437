clear all;
close all;
n=5;
x=zeros(1500,1);
x(26)=1.5;
for t=27:1500
    x(t)=(x(t-1)+((0.2*x(t-26))./(1+((x(t-26)).^10))))-0.1*x(t-1);
end
x=x';

targetSeries = x(5:end);

trainDat=x(1:1200);
trainDat1=zeros(5,1200);

trainTarg=targetSeries(1:1200);
testDat=x(1201:end-5);
testDat1=zeros(5,length(testDat));
testTarg=targetSeries(1201:end);

for i=1:1200
    trainDat1(1,i)=trainDat(i);
    if((i-5)<=0)
        trainDat1(2,i)=0;
    else
        trainDat1(2,i)=trainDat(i-5);
    end
    
     if((i-10)<=0)
        trainDat1(3,i)=0;
    else
        trainDat1(3,i)=trainDat(i-10);
     end
     
     if((i-15)<=0)
        trainDat1(4,i)=0;
    else
        trainDat1(4,i)=trainDat(i-15);
     end
    
      if((i-20)<=0)
        trainDat1(5,i)=0;
    else
        trainDat1(5,i)=trainDat(i-20);
      end
end

for i=1201:1500
    testDat1(1,i-1200)=x(i);
    testDat1(2,i-1200)=x(i-5);
    testDat1(3,i-1200)=x(i-10);  
    testDat1(4,i-1200)=x(i-15);
    testDat1(5,i-1200)=x(i-20);
end

%trainDat1=trainDat1(:,26:end);


inputSeries = num2cell(x);

%IF YOU WANT 2 LAYERS TAKE AWAY THE 10 BELOW: IT SAYS THE NUMBER OF NEURONS
%IN THE 2ND LAYER

net=feedforwardnet([n 70]);
%net.numInputs=5;
net.numLayers=3;

net=configure(net,trainDat1);

[net, TR]= train(net, trainDat1, trainTarg);

output = net(testDat1);

figure(1)
plot(output)
hold on;
plot(testTarg);


figure(2)
plot(0.5*(testTarg-output(:,1:end-4)).^2);
title('Error');
ylabel('MSE')

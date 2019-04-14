clear all;
n=1;
x=zeros(1500,1);
x(26)=1.5;
for t=27:1500
    x(t)=(x(t-1)+((0.2*x(t-26))./(1+((x(t-26)).^10))))-0.1*x(t-1);
end
x=x';

inputSeries = num2cell(x);
targetSeries = x(5:end);

% Create a Nonlinear Autoregressive Network with External Input
inputDelays = 6:5:26;
feedbackDelays = 0;
hiddenLayerSize = 10;
net = narnet(inputDelays,hiddenLayerSize);
%net=adddelay(net,5);
[X,Xi,Ai,T] = preparets(net,{},{},inputSeries);

net = train(net,X,T,Xi,Ai);
view(net)
Y = net(X,Xi,Ai);
perf = perform(net,Y,T);
plot(x)


clear all;
close all;

x=zeros(1505,1);
x(1) = 1.5;
for t=1:25
    x(t+1)= 0.9 * x(t);
end
for t=26:1505
    x(t+1)=x(t) + (0.2*x(t-25)) / (1+(x(t-25))^10) -0.1*x(t);
end
x = x';

input = [ x(301-20:1500-20); x(301-15:1500-15); x(301-10:1500-10); x(301-5:1500-5); x(301:1500)];
target = x(301+5:1500+5);


figure(1)
plot(x)
grid on
title('Time series')
xlabel('t')
ylabel('x(t)')


figure(2)
    plot(target,'+k')
    grid on
    hold on
    

    
net.numLayers=2;
RATIO = 0.5;
error_for_iterations = zeros(1,8);

%for N=1:8  %number of hidden neurons per layer
N = 8;
for r=1:9
    RATIO = r/10;
    net=feedforwardnet(N);
    net.performFcn = 'msereg'; %regularization
    net.performParam.ratio = RATIO; %strength of regularization
    net=configure(net,input);

    [net, TR]= train(net, input, target);
    output = net(input);
    %error_for_iterations(N) = max(0.5*(target-output).^2);
    error_for_iterations(r) = max(0.5*(target-output).^2);

    figure(2)
        plot(output)
        title('Output from networks with different n° of neurons, with "+" being the targets')
        legend('1 neuron','2 neurons','3 neurons','4 neurons','5 neurons','6 neurons','7 neurons','8 neurons');

    hold on;
    
    figure(3)
        plot(0.5*(target-output).^2);
        title('Error');
        ylabel('MSE')
        hold on
        %legend('1 neuron','2 neurons','3 neurons','4 neurons','5 neurons','6 neurons','7 neurons','8 neurons');
        legend('Ratio 0.1','Ratio 0.2','Ratio 0.3','Ratio 0.4','Ratio 0.5','Ratio 0.6','Ratio 0.7','Ratio 0.8','Ratio 0.9');

end

[~,best_ratio] = min(error_for_iterations);
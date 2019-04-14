%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%three layers
clc
close all
clear all

net.numLayers=3;
mu = 0; %mean of the random gaussian noise
N = 8;

sigma = 0.18;%0.03; 0.09 ; 0.18];
x=zeros(1505,1);
x(1) = 1.5;
for t=1:25
    x(t+1)= 0.9 * x(t);
end
for t=26:1505
    x(t+1)=x(t) + (0.2*x(t-25)) / (1+(x(t-25))^10) -0.1*x(t);
end
x = x';
x = x + normrnd(mu,sigma,size(x));

input = [ x(301-20:1500-20); x(301-15:1500-15); x(301-10:1500-10); x(301-5:1500-5); x(301:1500)];
target = x(301+5:1500+5);

error_for_ratio = zeros(1,9);
for r=1:9
    RATIO = r/10; 
    %now I find the best number of neurons for the second layer, with this
    %Ratio
    
    error_for_2nd_layer = zeros(1,8);
    first_plot = 1;
    for neuron_in_second_layer = 1:8
        net=feedforwardnet([N neuron_in_second_layer]);
        net.performFcn = 'msereg'; %regularization
        net.performParam.ratio = RATIO; %strength of regularization
        net=configure(net,input);

        [net, TR]= train(net, input, target); %train the network with best parameters
        output = net(input); 

        if (first_plot == 1)
            first_plot = 0;
            figure(r)
                plot(target,'+k')
                hold on
                grid on
        end

        error_for_2nd_layer(neuron_in_second_layer) = max(0.5*(target-output).^2);

        figure(r)
        plot(output)
        hold on
        title(['Gaussian noise ~ N(',num2str(sigma),'), Ratio = ', num2str(RATIO)])
        legend('1 neuron','2 neurons','3 neurons','4 neurons','5 neurons','6 neurons','7 neurons','8 neurons');
    end
    [~,best_neurons_2nd] = min(error_for_2nd_layer);
    figure(r)
        hold on
        title(['Noise ~ N(',num2str(sigma),'), Ratio = ', num2str(RATIO),'; minimum error with ',num2str(best_neurons_2nd),' neurons for 2nd layer'])

    %now that I know the number of neurons for the second layer, I compute
    %the Ratio for this network
    
    net=feedforwardnet([N best_neurons_2nd]);
    net.performFcn = 'msereg'; %regularization
    net.performParam.ratio = RATIO; %strength of regularization
    net=configure(net,input);
    [net, TR]= train(net, input, target); %train the network with best parameters
    output = net(input); 
    
    error_for_ratio(r) = max(0.5*(target-output).^2);    
end   
[~,best_ratio] = min(error_for_2nd_layer);


net=feedforwardnet([N best_neurons_2nd]);
net.performFcn = 'msereg'; %regularization
net.performParam.ratio = best_ratio; %strength of regularization
net=configure(net,input);
[net, TR]= train(net, input, target); %train the network with best parameters
output = net(input); 

figure(r+1)
    plot(target,'+k')
    hold on
    plot(output)
    hold on
    title(['Gaussian noise ~ N(',num2str(sigma),'), Ratio = ', num2str(best_ratio*0.1),'; minimum error with ',num2str(best_neurons_2nd),' neurons for 2nd layer'])


figure(r+2)
     plot(0.5*(target-output).^2);
     title('Error');

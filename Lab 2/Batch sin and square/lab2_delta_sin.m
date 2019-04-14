clc
clear all
close all

pattern = 0:0.1:2*pi;
pattern=pattern'; %column vector required
test = 0:0.05:2*pi;
test = test'; %column vector required

tr = sin(2*pattern); %train sets
ts = sin(2*test); %test sets

%%%%% Noise
r = 0 + 0.1*randn(length(pattern),1);
tr = tr + r;
r1 = 0 + 0.1*randn(length(test),1);
ts = ts +r1;
%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eta = 0.1; %learning rate %%
n_epochs = 20; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

MAX_RBFs = 200;
e = 10;
n = 1;
residual = [ ];

while((e > 0.01) && (n < MAX_RBFs))   
    d = max(pattern) - min(pattern); %maximum distance between datapoint
    sigma = d/sqrt(2*n); %common choice from book, pag. 119
    %Training with Delta Rule
    w1 = -1 + (1).*rand(n,1);%weight initially randomly distributed in the space
    mu = linspace(0,2*pi,n); %RBFs equally spaced in [0,2pi]
    x = pattern; 
    
    for epoch=1:1000
        index = randperm(length(pattern));
        x = pattern(index); %shuffle input data
        tr = sin(2*x); %shuffle output data        
        for k=1:length(x) %simulate sequential update
            phi_k1 = exp(-((x(k) - mu').^2)/(2*sigma^2));
            e = tr(k)-(phi_k1'*w1);
            w1  = w1 + eta*e*phi_k1;
        end
    end
    %Testing
    x = repmat(test,1,n); %just repeat column-input vector for each of n columns
    A1 = repmat(mu,length(test),1); %just repeat row-vector mu for each of the N rows
    A1 = ((x-A1).^2)/(2*sigma^2);
    phi1 = exp(-A1);
    y1_reconstructed = phi1*w1;
    e = sum((y1_reconstructed - ts).^2)/length(y1_reconstructed);
    residual = [residual e];
    n = n+1;
end

figure
    plot(ts)
    hold on
    plot(y1_reconstructed)
    grid on
    title(['y = sin(2x), max error = ',num2str(e) ,' with ', num2str(n) ,' neurons'])
    legend('Original signal','Reconstructed signal')
    
figure
    plot(residual)
    grid on
    title('error for function sin(2x)')
    xlabel('Number of nodes')
    ylabel('error')
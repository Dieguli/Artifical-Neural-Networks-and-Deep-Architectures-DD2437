clc
clear all
close all

pattern = 0:0.1:2*pi;
pattern=pattern'; %column vector required
test = 0:0.05:2*pi;
test = test'; %column vector required

tr = square(2*pattern); %train sets
ts = square(2*test); %test sets

%%%%% Noise
r = 0 + 0.1*randn(length(pattern),1);
tr = tr + r;
r1 = 0 + 0.1*randn(length(test),1);
ts = ts +r1;
%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eta = 0.07; %learning rate %%
n_epochs = 50000; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

MAX_RBFs = 100;
e = 10;
n = 15; %uso 10 neuroni e basta
residual = [ ];


% while((e > 0.001) && (N < MAX_RBFs))   
    d = max(pattern) - min(pattern); %maximum distance between datapoint
    sigma = d/sqrt(2*n); %common choice from book, pag. 119

    %Training with Delta Rule

    w2 = -1 + (1).*rand(n,1);%weight initially randomly distributed in the space
    mu = linspace(0,2*pi,n); %RBFs equally spaced in [0,2pi]
    x = pattern; 
    
    for epoch=1:n_epochs 
        index = randperm(length(pattern));
        x = pattern(index); %shuffle input data
        tr1 = sin(2*x); %shuffle output data
        tr = square(2*x); %shuffle output data  
        
        for k=1:length(x) %simulate sequential update
            phi_k2 = exp(-((x(k) - mu').^2)/(2*sigma^2));
            e = tr(k)-(phi_k2'*w2);
            w2  = w2 + eta*e*phi_k2;
        end
    end
    
    %Testing
    x = repmat(test,1,n); %just repeat column-input vector for each of n columns
    A2 = repmat(mu,length(test),1); %just repeat row-vector mu for each of the N rows
    A2 = ((x-A2).^2)/(2*sigma^2);
    phi2 = exp(-A2);
    y2_reconstructed = phi2*w2;
    y2_reconstructed = 2*(y2_reconstructed > 0) -1 ; %By Thresholding I can set the error to zero
    e = sum((y2_reconstructed - ts).^2)/length(y2_reconstructed);
    residual = [residual e];
    %n = n+1;
%end

figure
    plot(ts)
    hold on
    plot(y2_reconstructed)
    grid on
    title(['y = square(2x), max error = ',num2str(e) ,' with ', num2str(n) ,' neurons'])
    legend('Original signal','Reconstructed signal')
    
% figure
%     plot(residual)
%     grid on
%     title('error for function square(2x)')
%     xlabel('Number of nodes')
%     ylabel('error')
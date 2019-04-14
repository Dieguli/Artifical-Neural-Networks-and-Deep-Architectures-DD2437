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

MAX_RBFs = 1000;
e = 10;
n = 8;
residual = [ ];

while((e > 0.001) && (n < MAX_RBFs)) 
    n = n+1;
    mu = linspace(0,2*pi,n); %RBFs equally spaced in [0,2pi]
    d = max(pattern) - min(pattern); %maximum distance between datapoint
    sigma = d/sqrt(2*n); %common choice from book, pag. 119
    
    %Training
        x = repmat(pattern,1,n); %just repeat column-input vector for each of n columns
        A = repmat(mu,length(pattern),1); %just repeat row-vector mu for each of the N rows
        A1 = ((x-A).^2)/(2*sigma^2);
        phi1 = exp(-A1);
        %Batch update
        w1 = pinv(phi1) * tr;

    %Testing
        x = repmat(test,1,n); %just repeat column-input vector for each of n columns
        A = repmat(mu,length(test),1); %just repeat row-vector mu for each of the N rows
        A1 = ((x-A).^2)/(2*sigma^2);
        phi1 = exp(-A1);
        y1_reconstructed = phi1*w1;
        e = sum((y1_reconstructed - ts).^2)/length(y1_reconstructed);
        residual = [residual e];        
end


figure
    plot(residual)
    grid on
    title('Error for function sin(2x)')
    xlabel('Number of nodes')
    ylabel('error')
    
figure
    plot(ts)
    hold on
    plot(y1_reconstructed)
    grid on
    title(['y = sin(2x), max error = ',num2str(e) ,' with ', num2str(n) ,' neurons'])
    legend('Original signal','Reconstructed signal')
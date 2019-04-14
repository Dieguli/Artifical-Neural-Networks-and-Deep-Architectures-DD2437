clear all;
close all;

% Part 2
eta = 0.01;
rng default  % For reproducibility

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


NneurIn=9;
NneurOut=1;
w=zeros(NneurOut,2);
v=zeros(1,NneurIn);

for i=1:NneurIn
    for j=1:2
        w(i,j) = -1 + (2).*rand(1,1); 
    end
end

for j=1:NneurIn+1 %plus one for the bias
        v(j) = -1 + (2).*rand(1,1); 
end

epochs = 10000;
dw=0;   
dv=0;
alpha=0.9;

for i =1:epochs-1    
    X = [pattern ones(length(pattern),1)]';
    T = tr';
    hin = w * X;
    hout = [2 ./ (1+exp(-hin)) - 1 ; ones(1,length(pattern))];
    oin = v * hout;
    out = 2 ./ (1+exp(-oin)) - 1;

    delta_o = (out - T) .* ((1 + out) .* (1 - out)) * 0.5;
    delta_h = (v' * delta_o) .* ((1 + hout) .* (1 - hout)) * 0.5;

    dw = (dw .* alpha) - (delta_h * X') .* (1-alpha);
    dv = (dv .* alpha) - (delta_o * hout') .* (1-alpha);
    w = w + dw(1:length(dw)-1,:) .* eta;
    v = v + dv .* eta;
end

plot(out)
grid on
title(['y = sin(2x), with ', num2str(9) ,' neurons'])

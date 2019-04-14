clear all
close all
clc

load('pict.dat');
p1 = pict (1,1:1024);

D = 1024;
W = randn(D);
W = 0.5*(W + W');
vector_brigante = p1; 

%Asynch
iterate = 1;
x_p = vector_brigante;
x = x_p;
count = 1;
while(iterate)
    index = randperm(D);
    for j = 1:length(index)
        E(count) = -x*(W*x');
        count = count +1;
        i = index(j);
        x(i) = sign(W(i,:)*x');
    end
    iterate = ~(isequal(x,x_p));
    x_p = x;
end

figure
grid on
plot(E)


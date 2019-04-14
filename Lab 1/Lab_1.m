close all;
clear all;

eta = 0.01;
npoints=200;
mu1 = [-2,0];
mu2= [2,2];
sigma = [0.2,0;0,0.2];
rng default  % For reproducibility
r = [mvnrnd(mu1,sigma,npoints/2), 1*ones(npoints/2,1)];
s = [mvnrnd(mu2,sigma,npoints/2), -1*ones(npoints/2,1)];
r1 = -1 + (2).*rand(1,1);
r2 = -1 + (2).*rand(1,1);
r3 = -1 + (2).*rand(1,1);
w=[r1,r2,r3];

patterns=[r;s];
patterns=patterns(randperm(size(patterns,1)),:);
targets = patterns(:,3);
patterns = (patterns(:,1:2))';
patterns = [patterns ; ones(1,npoints)];

patterns = patterns - mean(patterns);

epochs = 20;
m = npoints/epochs;
for i =1:epochs-1
    X = patterns(:,i*m:(i+1)*m);
    T = (targets(i*m:(i+1)*m))';
    delta_w = -eta*(w*X - T)*X';
    w = w + delta_w;
end






figure
plot(r(:,1),r(:,2),'+');
hold on;
plot(s(:,1),s(:,2),'o')
plot(w(3)+w(2)*[-4:1:4],w(3)-w(1)*[-4:1:4]);

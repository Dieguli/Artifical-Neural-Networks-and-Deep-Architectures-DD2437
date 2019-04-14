clear all;
% Part 2
eta = 0.01;
npoints=600;
mu1 = [-1,-1];
mu2= [1,1];
sigma = [0.25,0;0,0.25];
rng default  % For reproducibility
r = [mvnrnd(mu1,sigma,npoints/2), 1*ones(npoints/2,1)];
s = [mvnrnd(mu2,sigma,npoints/2), -1*ones(npoints/2,1)];

NneurIn=3;
NneurOut=2;
w=zeros(NneurOut,3);
v=zeros(1,NneurIn);

for i=1:NneurOut
    for j=1:3
        w(i,j)=-1 + (2).*rand(1,1); 
    end
end

for j=1:NneurIn
        v(j)=-1 + (2).*rand(1,1); 
end

patterns=[r;s];
patterns=patterns(randperm(size(patterns,1)),:);
targets = patterns(:,3);
patterns = (patterns(:,1:2))';
patterns = [patterns ; ones(1,npoints)];

patterns = patterns - mean(patterns);

epochs = 60;
m = npoints/epochs;

dw=0;   
dv=0;
alpha=0.9;

for i =1:epochs-1
    
    X = patterns(:,i*m:(i+1)*m);
    T = (targets(i*m:(i+1)*m))';
    hin = w * X;
    hout = [2 ./ (1+exp(-hin)) - 1 ; ones(1,m+1)];
    oin = v * hout;
    out = 2 ./ (1+exp(-oin)) - 1;

    delta_o = (out - T) .* ((1 + out) .* (1 - out)) * 0.5;
    delta_h = (v' * delta_o) .* ((1 + hout) .* (1 - hout)) * 0.5;

    dw = (dw .* alpha) - (delta_h * X') .* (1-alpha);
    dv = (dv .* alpha) - (delta_o * hout') .* (1-alpha);
    w = w + dw(1:length(dw)-1,:) .* eta;
    v = v + dv .* eta;
end

plot(r(:,1),r(:,2),'+');
hold on;
plot(s(:,1),s(:,2),'o')
plot(v(3)+v(2)*[-4:1:4],v(3)-v(1)*[-4:1:4]);


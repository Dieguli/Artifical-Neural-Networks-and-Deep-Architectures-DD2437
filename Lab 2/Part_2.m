clear all;
close all;

N=20;

x=0:0.1:2*pi;
xtest=0:0.05:2*pi;

eta=0.1;
epochs=3000;

f1=square(2*x);
f2=sin(2*x);

f2test=sin(2*xtest);
f1test=square(2*xtest);

mu=2*pi/N; %Space between mus of the gaussians
muv=0:N-1; %Linear vector (0 to N-1 gaussians)
muv=mu*muv; %Mu vector (vector of means)
sigma=3*mu;

Phi=zeros(N,length(x)); %Matrix with functions applied to each point (6) in assignment

for i=1:length(x) %columns (varies the point/sample)
    for j=1:N %Rows (varies the mu of the function)
        Phi(j,i)=exp(-(((x(i)-muv(j)).^2)./(2*sigma.^2)));
    end
end

w=((Phi'*Phi)\Phi')'*f2';

wDelta=zeros(N,1);
%fapp=Phi'*w;
PhiDelta=zeros(N,1); %Matrix with functions applied to each point (6) in assignment

for n=1:epochs %columns (varies the point/sample)
    i=ceil(rand(1,1)*(length(x)-1));
    for j=1:N %Rows (varies the mu of the function)
        PhiDelta(j,1)=exp(-(((x(i)-muv(j)).^2)./(2*sigma.^2)));
    end
    e=(x(i)-PhiDelta'*wDelta);
    wDelta=wDelta+eta*e*PhiDelta;
end

Phitest=zeros(N,length(xtest));

for i=1:length(xtest) %columns (varies the point/sample)
    for j=1:N %Rows (varies the mu of the function)
        Phitest(j,i)=exp(-(((xtest(i)-muv(j)).^2)./(2*sigma.^2)));
    end
end

fapp=Phitest'*w;
fapp2=Phitest'*wDelta;
plot(xtest,f2test);
hold on;
plot(xtest,fapp);
plot(xtest,fapp2);
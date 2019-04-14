clear all;
close all;

N=9;

x=0:0.7:2*pi;
xtest=0:0.05:2*pi;

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

%fapp=Phi'*w;

Phitest=zeros(N,length(xtest));

for i=1:length(xtest) %columns (varies the point/sample)
    for j=1:N %Rows (varies the mu of the function)
        Phitest(j,i)=exp(-(((xtest(i)-muv(j)).^2)./(2*sigma.^2)));
    end
end

fapp=Phitest'*w;
plot(xtest,f2test);
hold on;
plot(xtest,fapp);
clear all;
% Part 3
eta = 0.01;
npoints=600;

patterns=ones(8,npoints);
patterns=patterns*-1;

for i=1:npoints
    pos=rand(1);
    pos=ceil(pos*8);
    patterns(pos,i)=1;
end

NneurIn=8;
NneurHid=3;
NneurOut=8;
w=zeros(NneurIn,8);
v=zeros(NneurHid,NneurIn);
u=zeros(NneurOut,NneurHid);

for i=1:NneurOut
    for j=1:8
        w(i,j)=-1 + (2).*rand(1,1); 
    end
end

for i=1:NneurHid
    for j=1:NneurIn
            v(i,j)=-1 + (2).*rand(1,1); 
    end
end

for i=1:NneurOut
    for j=1:NneurHid
            u(i,j)=-1 + (2).*rand(1,1); 
    end
end

targets=patterns;
epochs = 300;
m = npoints/epochs;

dw=0;   
dv=0;
du=0;
alpha=0.9;
errEpoch=zeros(1,epochs-1);

for i =1:epochs-1
    X = patterns(:,i*m:(i+1)*m);
    T = (targets(:,i*m:(i+1)*m))';
    hin = w * X;
    hout = [2 ./ (1+exp(-hin)) - 1];
    jin  = v * hout;
    jout =2 ./ (1+exp(-jin)) - 1;
    oin = u * jout;
    out = 2 ./ (1+exp(-oin)) - 1;

    delta_o = (out - T') .* ((1 + out) .* (1 - out)) * 0.5;
    delta_j = (u' * delta_o) .* ((1 + jout) .* (1 - jout)) * 0.5;
    delta_h = (v' * delta_j).* ((1 + hout) .* (1 - hout)) * 0.5;

    dw = (dw .* alpha) - (delta_h * X') .* (1-alpha);
    du = (du .* alpha) - (delta_o * jout') .* (1-alpha);
    dv = (dv .* alpha) - (delta_j * hout') .* (1-alpha);
    
   [row,col]=size(out);
   outN=zeros(size(out));
    for l=1:row
        for f=1:col
            if out(l,f)<0
                outN(l,f)=floor(out(l,f));
            else
                outN(l,f)=ceil(out(l,f));
            end
        end
    end
    
 
    errMat=0.5*(T'-outN)'*(T'-outN);
    errEpoch(i)=trace(errMat);
    
    w = w + dw .* eta;
    v = v + dv .* eta;
    u= u + du .*eta;
end

plot(errEpoch)
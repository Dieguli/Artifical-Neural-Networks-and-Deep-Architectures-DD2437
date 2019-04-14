clear all;
% ndata=length(x)*length(y);
eta = 0.15;

x=[-5:0.5:5]';
y=[-5:0.5:5]';
z=exp(-x.*x*0.1) * exp(-y.*y*0.1)' - 0.5;
mesh(x, y, z);

ndata=length(x)*length(y);

targets = reshape (z, 1, ndata);
[xx, yy] = meshgrid (x, y);
patterns = [reshape(xx, 1, ndata); reshape(yy, 1, ndata)];
foo=[patterns; targets]';
foo=foo(randperm(size(foo,1)),:)';
targets=foo(3,:);
patterns=foo(1:2,:);
patterns = [patterns ; ones(1,ndata)];


NneurIn=30;
NneurOut=1;
%NneurHid=10;
w=zeros(NneurIn,3);
v=zeros(NneurOut,NneurIn);
%u=zeros(NneurOut,NneurHid);

for i=1:NneurIn
    for j=1:3
        w(i,j)=-1 + (2).*rand(1,1); 
    end
end

for i=1:NneurOut
    for j=1:NneurIn
            v(i,j)=-1 + (2).*rand(1,1); 
    end
end

% for i=1:NneurOut
%     for j=1:NneurHid
%             u(i,j)=-1 + (2).*rand(1,1); 
%     end
% end
epochs = 147;
m = ndata/epochs;

dw=0;   
dv=0;
%du=0;
alpha=0.9;

for s =1:2000
    i=floor((length(patterns)/(m+1))*rand(1,1))+1; 
    X = patterns(:,i*m:(i+1)*m-1);
    T = (targets(i*m:(i+1)*m-1))';
    
    hin = w * X;
    hout = [2 ./ (1+exp(-hin)) - 1];
    oin = v * hout;
    out = 2 ./ (1+exp(-oin)) - 1;

    delta_o = (out - T') .* ((1 + out) .* (1 - out)) * 0.5;
    delta_h = (v' * delta_o) .* ((1 + hout) .* (1 - hout)) * 0.5;

    dw = (dw .* alpha) - (delta_h * X') .* (1-alpha);
    dv = (dv .* alpha) - (delta_o * hout') .* (1-alpha);
    
    w = w + dw .* eta;
    v = v + dv .* eta;

    [xx, yy] = meshgrid (x, y);
    X = [reshape(xx, 1, ndata); reshape(yy, 1, ndata);ones(1,ndata)];
    hin = w * X;
    hout = [2 ./ (1+exp(-hin)) - 1];
%     jin  = v * hout;
%     jout =2 ./ (1+exp(-jin)) - 1;
    oin = v * hout;
    out = 2 ./ (1+exp(-oin)) - 1;
    
    figure(1)
    zz = reshape(out, length(x), length(y));
    mesh(x,y,zz);
    axis([-5 5 -5 5 -0.7 0.7]);
    drawnow;
    
    figure(2)
    err= z-zz;
    mesh(x,y,err);
    axis([-5 5 -5 5 -0.7 0.7]);
    drawnow;

end


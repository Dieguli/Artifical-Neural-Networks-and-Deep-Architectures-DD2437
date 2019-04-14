clear; 
close all;

N = 8; % Number of neurons
P = 3; % Number of patterns
patterns = [-1 -1 1 -1 1 -1 -1 1; -1 -1 -1 -1 -1 1 -1 -1; -1 1 1 -1 -1 1 -1 1]; %patterns stored in a matrix
% [R, C] = size(patterns); %The numbers of columns (C) and rows(R) of patterns
% Training
sz = size(patterns);
w = patterns' * patterns;
patternsNew = zeros(sz);
copyPatterns=patterns;
 
%Testig of the weights using the update rule
for i = 1:P
    for j = 1 : N
        copyPatterns=patterns;
        copyPatterns(i,j)=0;
        patternsNew(i,j) = sign(w(j,:)*copyPatterns(i,:)');
   end    
end

%Changed input vectors (with some errors) to prove if the units can
%remember
patternsd = [1 -1 1 -1 1 -1 -1 1; -1 -1 -1 -1 -1 1 -1 -1; 1 1 1 -1 1 1 -1 1]; %patterns stored in a matrix

%Update rule
epochs=3;
for l=1:epochs
    for i = 1:P
        for j = 1 : N
            patternsd(i,j)=0;
            patternsd(i,j) = sign(w(j,:)*patternsd(i,:)');
        end    
    end
end

%Generate all binary combinations
n = 8;
allComb = dec2bin(0:2^n-1) - 48; %(dec2bin generates a char of the number in ASCII, so we substract 48 which is '0'
%We change the binary numbers so zeros are -1
for i=1:2^n-1
    for j=1:n
        if(allComb(i,j)==0)
            allComb(i,j)=-1;
        end
    end
end

%Apply update rule to all combinations

flag=0;
counter=1;
attractors=zeros(1,n);

for i = 1:2^n-1
    aux=[0 0 0 0 0 0 0 0];
    while(~isequal(aux,allComb(i,:))) %While it has not converged (i.e. the vector in last round is different in next one)
         aux=allComb(i,:);
        for j = 1 : n
            allComb(i,j)=0;
            allComb(i,j) = sign(w(j,:)*allComb(i,:)');
        end 
    end
    %In order to add one attractor to the set of attractors, we search that
    %it is not already there
    for l=1:counter
        if(isequal(attractors(l,:), aux))
            flag=1;
        end
    end
    %If it is not, we add it
    if(flag==0)
            attractors(counter+1,:)=aux;
            counter=counter+1;
    end
    flag=0;
end
%We take off the first row of zeroes of the attractors which was dummy
attractors=attractors(2:length(attractors(:,1)),:);





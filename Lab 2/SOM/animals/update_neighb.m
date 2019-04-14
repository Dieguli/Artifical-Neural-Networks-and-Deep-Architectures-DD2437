% Inputs 
%   w = weights
%   index = index of the winner
%   dim = dimension of the neighbourhood to be updated
function w = update_neighb(w,index,dim,animal,eta_step)
    a = ceil(index - dim/2);
    b = floor(index + dim/2);
    if (a<0) 
        a = 1;
    end
    if (b>size(w,1))
        b = size(w,1);
    end
    
    for i = a:b %update the weights of the neighbourhood
        w(i,:) = w(i,:) + eta(index,i,dim,eta_step)*(animal - w(i,:));
    end
end
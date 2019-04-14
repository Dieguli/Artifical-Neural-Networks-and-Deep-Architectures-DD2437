% Inputs 
%   w = weights
%   winner_ind = index of the winner
%   dim = dimension of the neighbourhood to be updated

function w = update_neighb2(w,winner_ind,dim,training_vect,eta_step)

    a = mod(winner_ind - dim,10);  %LOWER BOUND
        % since the neighbourhood is circular, if I have negative values I should
        % start back from the bottom.
        % "winner_ind -1" because neurons are ranging from 1 to 10, but mod() 
        % operation is done modulus10, which means that
        % ind = 0 ---> corresponds to neuron 1
        % ind = 1 ---> corresponds to neuron 2
        % ... and so on up to ind= 9 ---> neuron 10.
        % Now, for having ind = -1 corresponding to neuron 10 by using the mod10 
        % operation, the ways are 1) to compute the modulus over winner_ind- 1;
        % 2) compute a = mod(winner_ind,10) with winner_ind € [1,10], but then 
        % scale a = a +1, so that  mod(-1,10) +1 = 10 --> corresponds to
        % neuron 10.        
    a = a+1; %torno nel                                 
    
    b = mod(winner_ind,10); %UPPER BOUND: here we don't have the same problem since positive
        % numbers behaves properly
        
    for i = a:b %update the weights of the neighbourhood
        w(i,:) = w(i,:) + eta(winner_ind,i,dim,eta_step) * (training_vect - w(i,:));
    end
end
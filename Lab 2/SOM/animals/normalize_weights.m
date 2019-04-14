% Input
% w = colum vector of all the weigths to normalize

% Output
% weights = normalized weights
function [weights] = normalize_weights(w)
    Wnorm = sqrt(sum(w.^2,2));
    weights = w./Wnorm;
end
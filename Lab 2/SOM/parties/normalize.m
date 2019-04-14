function [w]=normalize(w)
    w = w./sqrt(sum(w.^2,2));
end
function [y]=eta(winner_ind,i,dim,eta_step)
    y = (1 - abs(i - winner_ind)/dim)*eta_step;
end

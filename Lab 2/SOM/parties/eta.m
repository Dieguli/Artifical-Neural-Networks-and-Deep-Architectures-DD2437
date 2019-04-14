function [y]=eta(winner_ind,neighbours_inds,eta_step,gridx,dim)
    matrix = abs(gridx-winner_ind);
    minMatrix = min(matrix(:)); %Find the x and y position of the winner, into the Grid
    [row,col] = find(matrix==minMatrix);
    dim = dim +0.1;
    y = zeros(length(neighbours_inds),1);
    
    
    for m=1:length(neighbours_inds)
         matrix = abs(gridx-neighbours_inds(m));
         minMatrix = min(matrix(:)); %Find the x and y position of the winner, into the Grid
        [r,c] = find(matrix==minMatrix);
        distance = sqrt( (row-r).^2 + (col-c).^2 );
        y(m) = (1 - (distance)/dim)*eta_step; %y would be a vector
    end
end

function [sorting_rule]=find_neighbour(gridx,winner_ind,dim)
    sorting_rule = [];
    
    matrix = abs(gridx-winner_ind);
    minMatrix = min(matrix(:)); %Find the x and y position of the winner, into the Grid
    [row,col] = find(matrix==minMatrix);
    
    for a=1:size(gridx,1)
        for b=1:size(gridx,2)
            distance = sqrt( (row-a).^2 + (col -b).^2 );
            if (distance<=dim)
                sorting_rule = [sorting_rule; gridx(a,b)]; %it has to be column vector in order to properly 
                                                           %address the weights w, in the main function
            end
        end
    end


end 


    % this computes the neighbourhodd as a square, I want it like a circle
%     min_col = col - dim;
%     max_col = col + dim;
%     if (min_col <=0)
%         min_col =1;
%     end
%     if (max_col > size(gridx,2))
%         max_col = size(gridx,2);
%     end    
%     min_row = row - dim;
%     max_row = row + dim;
%     if (min_row <=0)
%         min_row =1;
%     end
%     if (max_row > size(gridx,1))
%         max_row = size(gridx,1);
%     end

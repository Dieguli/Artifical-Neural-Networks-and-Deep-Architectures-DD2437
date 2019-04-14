function y = neighbourhood(epoch,max_epoch,initial_dim)
    if (epoch > max_epoch *0.2) && (epoch <= max_epoch *0.4)
        y = initial_dim/2;
    else
        if (epoch > max_epoch *0.4) && (epoch <= max_epoch *0.8)
                y = initial_dim/4;
        else
                y = initial_dim/16;
        end
    end
    
    y = floor(y);
end
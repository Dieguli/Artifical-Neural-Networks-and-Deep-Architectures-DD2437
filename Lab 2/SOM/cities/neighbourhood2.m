function y = neighbourhood2(epoch,max_epoch)
    if (epoch < 0.33*max_epoch)
        y = 2;
    else
        if (epoch < 0.66*max_epoch)
                y = 1;
        else
                y = 0;
        end
    end
end
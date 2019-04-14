function y = neighbourhood3(epoch,max_epoch,dim)
    if (epoch < 0.25*max_epoch)
        y = dim/2;
    else
        if (epoch < 0.5*max_epoch)
                y = dim/4;
        else
                if (epoch < 0.7*max_epoch)
                    y = dim/8;
                else
                    y = dim/16;
                end
        end
    end
    y = floor(y);
end
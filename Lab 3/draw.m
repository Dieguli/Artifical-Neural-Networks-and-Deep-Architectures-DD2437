function draw(p1)
    v = reshape(p1,32,32);
    x = 1:32;
    y = 1:32;

    pl = figure();
    hold on
    for a=1:size(x,2)    
        for b=1:size(y,2)
            if (v(a,b) == 1)
                plot(x(a),y(b),'sk')
            end
        end
    end
    %set(pl,'MarkerFaceColor',[0 0 0],'MarkerSize',15);

end
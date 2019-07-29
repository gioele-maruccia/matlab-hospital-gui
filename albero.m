axes(handles.buoneFeste)
        r = 1.0;
        h = 2.0;
        m = h/r;
        [R,A] = meshgrid(linspace(0,r,11),linspace(0,2*pi,41));
        X1 = R .* cos(A);
        Y1 = R .* sin(A);
        Z1 = -m*R;
        X2=X1(1:5:end);
        Y2=Y1(1:5:end);
        Z2=Z1(1:5:end);
        for k=1:5
            surf(X1*(k*0.1+1),Y1*(k*0.1+1),Z1-k-1); hold on;
            scatter3(reshape(X2*(k*0.1+1),1,numel(X2)),...
                reshape(Y2*(k*0.1+1),1,numel(Y2)),...
                reshape(Z2-k-+0.1,1,numel(Z2)),ones(1,numel(X2))*30,...
                randn(1,numel(X2)),'filled');
        end
        handles.numVolte = handles.numVolte +1;
        vettColori = {'hsv','hot','gray','bone','copper','pink','white','flag','lines','colorcube','vga','jet','prism','cool','autumn','spring','winter'};
                indACaso = round(1+14*rand(1))
        if handles.numVolte == 1
            colormap('summer');
        else
            colormap(vettColori{indACaso})
        end
        % direzione di provenienza della luce
        camlight('right');
        axis equal
        grid off
function newcoords = applyTransformationToCoords(tform, imagesize, coords, invert)
    % Expected format of coords: (Nx2)
    % / Ypos1 Xpos1 \
    % | Ypos2 Xpos2 |
    % | ....        |
    % \ YposN XposN /
    
    inpW = imagesize(2);
    inpH = imagesize(1);
    
    inpW2 = inpW / 2;
    inpH2 = inpH / 2;
    
    assert(size(coords,2) == 2);
    
    V = coords(:,1) - inpH2; %Y shifted center to 0
    U = coords(:,2) - inpW2; %X shifted center to 0
    
    
    scale1 = maketform('affine', [1./inpW, 0, 0; 0, 1./inpW, 0; 0, 0, 1]);
    scale2 = maketform('affine', [inpW, 0, 0; 0, inpW, 0; 0, 0, 1]);
    
    %                 evaluated this way around <-----
    totaltform = maketform('composite', scale2, tform, scale1);
    
    if ~invert
        [X, Y] = tformfwd(totaltform, U, V);
    else 
        [X, Y] = tforminv(totaltform, U, V);
    end
    X = X + inpW2;
    Y = Y + inpH2;
    
    % Mark invalid positions:
    X(X>inpW) = -1;
    Y(Y>inpH) = -1;
    
    X(X < 0 | Y < 0) = -1;
    Y(X < 0 | Y < 0) = -1;

    newcoords = [Y, X];
end


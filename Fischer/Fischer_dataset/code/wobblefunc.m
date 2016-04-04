function X = wobblefunc(U,T,forwardflag)
%wobblefunc Is a custom transformation function for wobbling effect.
%   To be used with maketform('custom', ...)

    %Transform points in U fwd or bwd
    % U is <P x 2> array of points [y,x]
    
    xstrength = T.tdata(1); % Amplitude as pixel offset
    ystrength = T.tdata(2);
    
    xcyclelen = 30./1000; %pixels length of half cycle (180deg)
    ycyclelen = 30./1000;
    
    if forwardflag
        error('fwd not supported');
    else
        xphase = U(:,2) ./ xcyclelen .* pi;
        yphase = U(:,1) ./ ycyclelen .* pi;
    
        Uoff = [sin(yphase).*ystrength, sin(xphase).*xstrength];
    
        X = U+Uoff;
    end
end


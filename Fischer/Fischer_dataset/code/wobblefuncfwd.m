function X = wobblefuncfwd(U,T)
%wobblefunc Is a custom transformation function for wobbling effect.
%   To be used with maketform('custom', ...)

    X = wobblefunc(U,T,true);

end


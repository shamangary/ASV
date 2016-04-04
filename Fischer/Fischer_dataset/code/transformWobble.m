function tform = transformWobble(xstrength, ystrength)

tform = maketform('custom', 2, 2, @wobblefuncfwd, @wobblefuncbwd, [xstrength, ystrength]);

end


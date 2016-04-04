function tform = transformPersp(strength)

tform1 = maketform('projective', [1, 0, strength; 0, 1, strength*-0.2; 0 0 1]);
tform2 = maketform('affine', [1, 0, 0; 0, 1, 0; 0.2*strength 0 1]);

tform = maketform('composite', tform2, tform1);

end


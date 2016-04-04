function tform = transformZoomRotate(scale, angle)

theta = deg2rad(angle);

A = [cos(theta) sin(theta) 0; -sin(theta) cos(theta) 0];
A = A .* scale;

tform = maketform('affine', [A; 0 0 1]);

end


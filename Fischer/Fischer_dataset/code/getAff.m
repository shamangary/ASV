function Aff=getAff(x, y, transform, imgsize, invert)

ptsa = zeros(9,2);
i = 0;
for yoff = -6:2:6
    for xoff = -6:2:6
        i = i + 1;
        ptsa(i,:) = [y,x] + [yoff,xoff];
    end
end
ptsb = mapPoints(ptsa, transform, imgsize, invert);

if any(ptsb(:) < 0)
    Aff = NaN(2,2);
else
    afftform = cp2tform(ptsa(:,[2 1]), ptsb(:,[2 1]), 'affine');
    Aff = afftform.tdata.T(1:2,1:2);
end
          
function retpts = mapPoints(pts, transform, imgsize, invert)
    retpts = applyTransformationToCoords(transform.transTForm, imgsize, pts, invert);
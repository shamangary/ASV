function im = transNongeoBlur(im, amount)

    assert(size(im,3) == 3);

    im = imfilter(im, fspecial('disk',amount));

end


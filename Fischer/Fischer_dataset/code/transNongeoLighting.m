function im = transNongeoLighting(im, offset, value)

    assert(size(im,3) == 3);

    im = im .* value + (offset.*255);
    im(im > 255) = 255;
    im(im < 0) = 0;

    im = uint8(im);

end


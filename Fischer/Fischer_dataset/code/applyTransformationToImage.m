function newim = applyTransformationToImage(tform, nongeotform, image)
    
    inpW = size(image,2);
    inpH = size(image,1);
    
    inpW2 = inpW / 2;
    inpH2 = inpH / 2;
    
    if ~isempty(tform)
        if isfield(tform, 'isgeometric')
            tform = rmfield(tform, 'isgeometric');
        end
        scale1 = maketform('affine', [1./inpW, 0, 0; 0, 1./inpW, 0; 0, 0, 1]);
        scale2 = maketform('affine', [inpW, 0, 0; 0, inpW, 0; 0, 0, 1]);

        %                 evaluated this way around <-----
        totaltform = maketform('composite', scale2, tform, scale1);


        newim = imtransform(image,totaltform,'bilinear', ...
                    'XYScale', 1, ...
                    'UData', [1-inpW2, inpW2], ...
                    'VData', [1-inpH2, inpH2], ...
                    'XData', [1-inpW2, inpW2], ...
                    'YData', [1-inpH2, inpH2] );
    else
        newim = image;
    end
    
    if ~isempty(nongeotform)
        if ~iscell(nongeotform)
            nongeotform = {nongeotform};
        end
        
        for i = 1:length(nongeotform)
            newim = nongeotform{i}.func(newim, nongeotform{i}.args{:});
        end
    end
end


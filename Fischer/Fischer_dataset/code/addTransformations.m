function imgstruct = addTransformations(imgstruct, name, transformations)
%addTransformation Applies transformations to all images in the struct and
%returns the modified struct.
%   imgstruct - Input structure containing images, as given by loadImages
%   name - A name for this transformation chain
%   transformations - An cell array of transformation strings

for i=1:length(imgstruct)
    imgstruct(i).transName = name;
    imgstruct(i).transStructs = transformations;
    
    assert(iscell(transformations));
    
    curImage = imgstruct(i).origImage;
    
    totalTForm = [];
    totalNongeo = [];
    for tid = 1:length(transformations)
        curTform = transStringToTForm(transformations{tid});
        isgeo = curTform.isgeometric;
        curTform = rmfield(curTform, 'isgeometric');
        
        if isgeo
            if isempty(totalTForm)
                totalTForm = curTform;
            else
                totalTForm = maketform('composite', curTform, totalTForm);
            end
        else
            totalNongeo{end+1} = curTform; %#ok<AGROW>
        end
        
    end
    
    imgstruct(i).transImage = applyTransformationToImage(totalTForm, totalNongeo, curImage);
    imgstruct(i).transNongeo = totalNongeo;
    
    imgstruct(i).transTForm = totalTForm;
end

end


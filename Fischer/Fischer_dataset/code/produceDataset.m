function produceDataset(imgstruct, datasetPath)
%produceDataset Takes imgstruct, applies std transforms and stores result

stdTransforms = { ...
    %{'perspective', {'persp:0.2','persp:0.5','persp:0.8','persp:1','persp:2.5|zoomrot:0.8,0|translate:0,-0.06'}}, ...
    %{'zoom', {'zoomrot:1.2,0','zoomrot:1.4,0','zoomrot:1.7,0','zoomrot:2.1,0','zoomrot:2.6,0','zoomrot:3,0'}}, ...
    %{'rotation', {'zoomrot:1,5','zoomrot:1,15','zoomrot:1,45'}}, ...
    %{'blur', {'translate:0.01,-0.02|blur:2','translate:0.015,-0.001|blur:5','translate:-0.002,0.01|blur:10','translate:0.011,-0.011|blur:20'}}, ...
    %{'lighting', {'translate:0.01,-0.02|lighting:0,0.9','translate:0.015,-0.001|lighting:0,0.8','translate:-0.002,0.01|lighting:0,0.7','translate:0.011,-0.011|lighting:0,0.6'}}, ...
    {'nonlinear', {'wobble:0.002,0.002','wobble:0.004,0.004','wobble:0.006,0.006'}}, ...
    };

reducedMaxSideLength = 1000;

for trans = 1:length(stdTransforms)
    
    transname = stdTransforms{trans}{1};
    transsubcount = length(stdTransforms{trans}{2});
    
    for sub = 1:transsubcount
        curtransstring = stdTransforms{trans}{2}{sub};
        
        transcellarray = strsplit(curtransstring, '|');
        
        % Do transformation series for all images:
        tmpstruct = addTransformations(imgstruct, transname, transcellarray);
        
        transid = [transname, num2str(sub)];
        writeOutTransformedImages(tmpstruct, transid, datasetPath, reducedMaxSideLength);
        writeOutTransformations(tmpstruct, transid, datasetPath);
    end
end
    
end

function writeOutTransformations(imgstruct, transid, datasetPath)
    curStruct = imgstruct(1);
    
    foldername ='transformations';
    
    folderToMake = fullfile(datasetPath, foldername);
    ensureDir(folderToMake);
        
    resultFilePath = fullfile(datasetPath, foldername, [transid, '.mat']);

    transName = curStruct.transName; %#ok<NASGU>
    transStructs = curStruct.transStructs; %#ok<NASGU>
    transTForm = curStruct.transTForm; %#ok<NASGU>
    transNongeo = curStruct.transNongeo; %#ok<NASGU>
    
    save(resultFilePath, 'transName', 'transStructs', 'transTForm', 'transNongeo');
end

function writeOutTransformedImages(imgstruct, transid, datasetPath, reducedMaxSideLength)
    
    parfor imgid = 1:length(imgstruct)
        curStruct = imgstruct(imgid);
        [~,fname,~] = fileparts(curStruct.name);
        
        folderToMake = fullfile(datasetPath, fname);
        ensureDir(folderToMake);
        
        origFilePath = fullfile(datasetPath, fname, '_original.jpg');
        if ~exist(origFilePath, 'file')
            writeoutImage(curStruct.origImage, origFilePath, reducedMaxSideLength);
        end
        
        resultFilePath = fullfile(datasetPath, fname, [transid, '.jpg']);
        
        writeoutImage(curStruct.transImage, resultFilePath, reducedMaxSideLength);
    end
end

function writeoutImage(image, filename, maxsidelen)
    h = size(image,1);
    w = size(image,2);
    
    % Fit to maxsidelen
    if h > w
        if h > maxsidelen
            image = imresize(image, [maxsidelen, NaN]);
        end
    else
        if w > maxsidelen
            image = imresize(image, [NaN, maxsidelen]);
        end
    end
    
    % Save:
    imwrite(image, filename, 'Quality', 98);
end

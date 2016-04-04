function imgstruct = loadImages(folder)

if ~exist('folder','var') || isempty(folder)
    folder = '/misc/lmbraid12/fischer/data/dosofis/source_files/';
end

folderinfo = dir(fullfile(folder, '*.jpg'));

imgstruct = struct([]);

for i = 1:length(folderinfo)
    imgstruct(i).name = folderinfo(i).name;
    imgstruct(i).fullFilename = fullfile(folder, folderinfo(i).name);
    
    imgstruct(i).origImage = imread(fullfile(folder, folderinfo(i).name));
end

end

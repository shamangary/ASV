function tform = transStringToTForm(transStr)

allfuncs = [];

c = length(allfuncs);
allfuncs(c+1).name = 'zoomrot';
allfuncs(c+1).func = @transformZoomRotate;
allfuncs(c+1).isgeometric = true;

c = length(allfuncs);
allfuncs(c+1).name = 'translate';
allfuncs(c+1).func = @transformTranslate;
allfuncs(c+1).isgeometric = true;

c = length(allfuncs);
allfuncs(c+1).name = 'persp';
allfuncs(c+1).func = @transformPersp;
allfuncs(c+1).isgeometric = true;

c = length(allfuncs);
allfuncs(c+1).name = 'blur';
allfuncs(c+1).func = @transNongeoBlur;
allfuncs(c+1).isgeometric = false;

c = length(allfuncs);
allfuncs(c+1).name = 'lighting';
allfuncs(c+1).func = @transNongeoLighting;
allfuncs(c+1).isgeometric = false;

c = length(allfuncs);
allfuncs(c+1).name = 'wobble';
allfuncs(c+1).func = @transformWobble;
allfuncs(c+1).isgeometric = true;

% ====

m = strsplit(transStr, ':');
assert(length(m) == 2);

func = m{1};
args = strsplit(m{2}, ',');

for i = 1:length(allfuncs)
    if strcmp(func, allfuncs(i).name)
        numericArgs = num2cell(str2double(args));
        if allfuncs(i).isgeometric
            tform = allfuncs(i).func(numericArgs{:});
            tform.isgeometric = true;
        else
            tform = allfuncs(i);
            tform.args = numericArgs;
        end
        return;
    end
end
error('Transform not found: %s', func);

end


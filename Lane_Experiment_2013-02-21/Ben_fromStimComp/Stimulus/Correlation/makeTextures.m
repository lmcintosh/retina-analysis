function ex = makeTextures(ex)
%
% FUNCTION ex = makeTextures(ex)
%
% Make pink noise and natural images textures. White noise textures are
% made on the fly.
%
% (c) bnaecker@stanford.edu 14 Feb 2012

%% Notify
Screen('DrawText', ex.ds.winPtr, 'Creating textures for pink noise and natural images', ...
    ex.ds.winCtr(1) - 100, ex.ds.winCtr(2));
Screen('Flip', ex.ds.winPtr);

%% Create
ex.ds.stimTex = cell(length(ex.pa.stimType), 1);
firstNatural = true;
for ri = 1:length(ex.pa.stimType)
    if ~strcmp(ex.pa.stimType{ri}, 'white');
        % save random state
        ex.pa.random(ri).stateAtTextureCreation = ex.pa.random(ri).stream.State;
        
        switch ex.pa.stimType{ri}
            case 'pink'
                tex = ex.ds.white .* ...
                    pinknoise(ex.pa.alpha, ex.pa.textureScaleFactor * ex.pa.stimSize, ...
                    ex.pa.textureScaleFactor * ex.pa.stimSize, ...
                    ex.pa.random(ri).stream);
                tex = min(tex(:), ex.ds.white); tex = max(tex(:), ex.ds.black);
                texMatrix(:,:,1) = uint8(round(reshape(tex, ...
                    ex.pa.textureScaleFactor * ex.pa.stimSize, ...
                    ex.pa.textureScaleFactor * ex.pa.stimSize)));
                texMatrix(:,:,2) = ...
                    uint8(ex.ds.white .* ones(ex.pa.textureScaleFactor * ex.pa.stimSize));
                ex.ds.stimTex{ri} = Screen('MakeTexture', ex.ds.winPtr, texMatrix);
                texMatrix = [];
            case 'natural'
                if firstNatural
                    dirContents = dir(ex.pa.naturalImgDir);
                    imgInds = strmatch('img', {dirContents.name});
                    imgFiles = dirContents(imgInds);
                    ex.ds.stimTex{ri} = zeros(length(imgFiles), 1);
                    for ii = 1:length(imgFiles)
                        s = load(fullfile(ex.pa.naturalImgDir, ...
                            imgFiles(ii).name), 'scaledLUM_Image');
                        tex = ex.ds.white .* s.scaledLUM_Image;
                        tex = min(tex(:), ex.ds.white); tex = max(tex(:), ex.ds.black);
                        texMatrix(:,:,1) = uint8(round(reshape(tex, ...
                            size(s.scaledLUM_Image, 1), ...
                            size(s.scaledLUM_Image, 2))));
                        texMatrix(:,:,2) = ex.ds.white .* ...
                            ones(ex.pa.naturalImgSize(1), ex.pa.naturalImgSize(2));
                        ex.ds.stimTex{ri}(ii) = ...
                            Screen('MakeTexture', ex.ds.winPtr, texMatrix);
                         texMatrix = [];
                    end
                    firstNatural = false;
                    firstNaturalInd = ri;
                else
                    ex.ds.stimTex{ri} = ex.ds.stimTex{firstNaturalInd};
                end
                texMatrix = [];
        end
    end
end
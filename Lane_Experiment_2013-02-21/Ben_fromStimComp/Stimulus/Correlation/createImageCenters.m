function ex = createImageCenters(ex)
%
% FUNCTION ex = createImageCenters(ex)
%
% Create vectors describing the center of every stimulus frame. These will
% be temporally white for white and pink noise, and will be simulated
% saccades plus fixational jitter for the natural images
%
% (c) bnaecker@stanford.edu 14 Feb 2012

% Notify
Screen('DrawText', ex.ds.winPtr, 'Creating stimulus centers and generating saccades', ...
    50, 50);
Screen('Flip', ex.ds.winPtr);

% Go through each block
ex.pa.stimCtr = cell(length(ex.pa.stimType), 1);
for r = 1:length(ex.pa.stimType)
    switch ex.pa.stimType{r}
        case 'white'
             % Dummy here
             ex.pa.stimCtr{r} = zeros(ex.pa.nFrames, 2);
        case 'pink'
            ex.pa.stimCtr{r} = zeros(ex.pa.nFrames, 2);
            ex.pa.stimCtr{r} = ...
                ex.pa.stimSize / 2 + ...
                randi(ex.pa.random(r).stream, ...
                (ex.pa.stimSize * ex.pa.textureScaleFactor) - ex.pa.stimSize, ...
                ex.pa.nFrames, 2);
        case 'natural'
            ex.pa.stimCtr{r} = zeros(ex.pa.nFrames, 2);
            ex.pa.random(r).stateAtSaccadeCreation = ex.pa.random(r).stream.State;
            ex.pa.stimCtr{r}(1, :) = ex.pa.stimSize / 2 + ...
                randi(ex.pa.random(r).stream, ...
                ex.pa.naturalImgSize(1) - ex.pa.stimSize, 1, 2);
            elapsedTime = 0;
            timeSincePreviousSaccade = 0; saccadeTime = 0;
            for fi = 2:ex.pa.nFrames
                if timeSincePreviousSaccade > ...
                        ex.pa.interSaccTime + ex.pa.interSaccSd * ...
                        randn(ex.pa.random(r).stream, 1)
                    saccadeTime = elapsedTime;
                    timeSincePreviousSaccade = 0;
                    ex.pa.stimCtr{r}(fi, :) = generateSaccades(ex, r, fi);
                else
                    timeSincePreviousSaccade = elapsedTime - saccadeTime;
                    ex.pa.stimCtr{r}(fi, :) = ex.pa.stimCtr{r}(fi - 1, :) + ...
                        (ex.pa.fixMoveSize ./ ex.pa.umPerPix) .* ...
                        randn(ex.pa.random(r).stream, 1, 2);
                end
                elapsedTime = elapsedTime + ex.pa.waitFrames * ex.ds.ifi;
            end
    end
end

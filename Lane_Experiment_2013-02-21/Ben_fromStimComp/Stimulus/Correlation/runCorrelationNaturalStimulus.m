function ex = runCorrelationNaturalStimulus(ex, si)
%
% FUNCTION ex = runCorrelationNaturalStimulus(ex, si)
%
% Runs the natural image stimulus
%
% (c) bnaecker@stanford.edu 15 Feb 2012

% Set dst rect (including photodiode)
dstRect = [ex.ds.dstRect; ...
    CenterRectOnPoint(ex.pa.pdRect, ...
    ex.pa.pdCenter(1) * ex.ds.winRect(3), ex.pa.pdCenter(2) * ex.ds.winRect(4))]';

% Run over frames
vbl = GetSecs;
fi = 1;

% Pick an initial texture
ex.pa.random(si).stateAtStimStart = ex.pa.random(si).stream.State;
ex.ds.texId(fi, si) = randi(ex.pa.random(si).stream, ...
	[ex.ds.stimTex{si}(1) ex.ds.stimTex{si}(end)]);
try
while fi <= ex.pa.nFrames && ~ex.kb.keyCode(ex.kb.escKey)
    % Make srcRect (for stimulus and photodiode)
    srcRect = [CenterRectOnPoint(ex.ds.srcRect, ex.pa.stimCtr{si}(fi, 1), ...
        ex.pa.stimCtr{si}(fi, 2)); ...
        CenterRectOnPoint(ex.ds.srcRect, ex.pa.stimCtr{si}(fi, 1), ...
        ex.pa.stimCtr{si}(fi, 2))]';
    
    % Pick texture, randomly switching with small probability
    if fi > 1
        if ex.pa.textureSwitchProb > rand(ex.pa.random(si).stream)
            ex.ds.texId(fi, si) = ex.ds.stimTex{si}(randi(ex.pa.random(si).stream, ...
                length(ex.ds.stimTex{si}), 1));
        else
            ex.ds.texId(fi, si) = ex.ds.texId(fi - 1, si);
        end
    end
    % Draw texture
    try
    Screen('DrawTextures', ex.ds.winPtr, ex.ds.texId(fi, si), srcRect, ...
        dstRect, 0, 0);
    catch me
        me;
    end
    
    % Flip
    Screen('DrawingFinished', ex.ds.winPtr);
    [vbl ex.ds.stimOnset(fi, si) ex.ds.flipTimeStamp(fi, si) ...
        ex.ds.flipMissed(fi, si) ex.ds.beamPos(fi, si)] = ...
        Screen('Flip', ex.ds.winPtr, ...
        vbl + (ex.pa.waitFrames - .5) * ex.ds.ifi);
    ex.ds.vbl(fi, si) = vbl;
    fi = fi + 1;
    
    % Check the keyboard
    ex = checkCorrExptKB(ex);
end
if ex.kb.keyCode(ex.kb.escKey)
    error('RunCorrelationExpt:runCorrelationNaturalStimulus:stimulusAborted', ...
        ['You quit the session early. Nothing will be saved, but the expt ' ...
        'struct will still be output to the workspace']);
end
catch me
    ex.me = me;
    return
end

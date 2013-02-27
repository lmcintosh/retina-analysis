function ex = runCorrelationWhiteStimulus(ex, si)
%
% FUNCTION ex = runCorrelationWhiteStimulus(ex, si)
%
% Runs a white noise stimulus, generating textures on the fly
%
% (c) bnaecker@stanford.edu 14 Feb 2012

%% Save state of the random stream
ex.pa.random(si).stateAtStimStart = ex.pa.random(si).stream.State;

%% Run over frames
vbl = GetSecs;
fi = 1;
try
while fi <= ex.pa.nFrames && ~ex.kb.keyCode(ex.kb.escKey)
    % Make a white noise texture
    tic
    tex = ex.ds.gray + ex.ds.gray .* ...
        ex.pa.whiteContrast(ex.pa.whiteContrastIndex(fi)) .* ...
        randn(ex.pa.random(si).stream, ex.pa.nBoxes);
    tex = min(tex(:), ex.ds.white); tex = max(tex(:), ex.ds.black);
    texture(:,:,1) = uint8(round(reshape(tex, ex.pa.nBoxes, ex.pa.nBoxes)));
    texture(:,:,2) = uint8(ex.ds.white .* ones(ex.pa.nBoxes, ex.pa.nBoxes));
    ex.ds.texId(fi, si) = Screen('MakeTexture', ex.ds.winPtr, texture);
    ex.ds.textureTimer(fi, si) = toc;
    
    % Draw the texture, then kill
    Screen('DrawTexture', ex.ds.winPtr, ex.ds.texId(fi, si), ...
        [], ex.ds.dstRect, 0, 0);
    Screen('Close', ex.ds.texId(fi, si));
    
    % Draw photodiode
    Screen('FillOval', ex.ds.winPtr, tex(1,1), ex.pa.pdRect);
    
    % Flip the screen
    try
    Screen('DrawingFinished', ex.ds.winPtr);
    catch me
        me;
    end
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
    error('RunCorrelationExpt:runCorrelationWhiteStimulus:stimulusAborted', ...
        ['You quit the session early. Nothing will be saved, but the expt ' ...
        'struct will still be output to the workspace']);
end
catch me
    ex.me = me;
    return
end
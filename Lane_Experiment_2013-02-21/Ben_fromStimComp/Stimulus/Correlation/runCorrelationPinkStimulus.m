function ex = runCorrelationPinkStimulus(ex, si)
%
% FUNCTION ex = runCorrelationPinkSimulus(ex, si)
%
% Runs a pink noise stimulus
%
% (c) bnaecker@stanford.edu 14 Feb 2012

% dstRect (including photodiode)
dstRect = [ex.ds.dstRect; ...
    CenterRectOnPoint(ex.pa.pdRect, ...
    ex.pa.pdCenter(1) * ex.ds.winRect(3), ex.pa.pdCenter(2) * ex.ds.winRect(4))]';

% Run over frames
vbl = GetSecs;
fi = 1;
try
while fi <= ex.pa.nFrames && ~ex.kb.keyCode(ex.kb.escKey)
    % Make srcRect (for stimulus and photodiode)
    srcRect = [CenterRectOnPoint(ex.ds.srcRect, ex.pa.stimCtr{si}(fi, 1), ...
        ex.pa.stimCtr{si}(fi, 2)); ...
        CenterRectOnPoint(ex.ds.srcRect, ex.pa.stimCtr{si}(fi, 1), ...
        ex.pa.stimCtr{si}(fi, 2))]';
    
    % Draw texture
    Screen('DrawTextures', ex.ds.winPtr, ex.ds.stimTex{si}, srcRect, ...
        dstRect, 0, 0);
    
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
    error('RunCorrelationExpt:runCorrelationPinkStimulus:stimulusAborted', ...
        ['You quit the session early. Nothing will be saved, but the expt ' ...
        'struct will still be output to the workspace']);
end
catch me
    ex.me = me;
    return
end

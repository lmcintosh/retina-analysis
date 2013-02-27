function ex = waitForTriggers(ex, trigger)
%
% FUNCTION ex = waitForTriggers(ex)
%
% Wait for the experimenter to press spacebar to arm trigger, then either
% trigger on keyboard or WaitForRec, depending on request
%
% (c) bnaecker@stanford.edu 14 Feb 2012

%% Arm
Screen('DrawText', ex.ds.winPtr, 'Press spacebar to arm trigger', ...
    50, 50);
Screen('Flip', ex.ds.winPtr);
while ~ex.kb.keyCode(ex.kb.spaceKey) && ~ex.kb.keyCode(ex.kb.escKey)
    ex = checkCorrExptKB(ex);
end

%% Wait for trigger
if any(strcmp(trigger, {'m', 'manual'}))
    Screen('DrawText', ex.ds.winPtr, 'Waiting for experimenter trigger (t)...', ...
        ex.ds.winCtr(1) - 100, ex.ds.winCtr(2));
    Screen('FillOval', ex.ds.winPtr, ex.ds.black, ex.pa.pdRect);
    Screen('Flip', ex.ds.winPtr);
    while ~ex.kb.keyCode(ex.kb.tKey)
        ex = checkCorrExptKB(ex);
    end
else
    Screen('DrawText', ex.ds.winPtr, 'Waiting for recording computer...', ...
        ex.ds.winCtr(1) - 100, ex.ds.winCtr(2));
    Screen('FillOval', ex.ds.winPtr, ex.ds.black, ex.pa.pdRect);
    Screen('Flip', ex.ds.winPtr);
    WaitForRec; WaitSecs(.5);
end
HideCursor;
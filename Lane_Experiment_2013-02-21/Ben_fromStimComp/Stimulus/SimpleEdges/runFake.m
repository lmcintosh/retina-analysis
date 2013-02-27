function ex = runFake(ex)
%
% FUNCTION ex = runFake(ex)
%
% run a fake stim, placeholder
%
% (c) bnaecker@stanford.edu 28 Jan 2013 

% setup
si = ex.pa.currentStimBlock;
vbl = GetSecs;
fi = 1;

% run
try
while fi <= ex.pa.nFrames && ~ex.kb.keyCode(ex.kb.escKey)

% make string
str = sprintf('this is a fake stim, it should be a %s stimulus, block %d of %d, frame, %d of %d,', ...
	ex.pa.stimType{si}, si, length(ex.pa.stimType), fi, ex.pa.nFrames);

% notify of fakitude
Screen('DrawText', ex.ds.winPtr, str, 50, 50);
[vbl ex.ds.stimOnset(fi, si) ex.ds.flipTimestamp(fi, si) ...
	ex.ds.flipMissed(fi, si) ex.ds.beamPos(fi, si)] = ...
	Screen('Flip', ex.ds.winPtr, vbl + (ex.pa.waitFrames - 0.5) * ex.ds.ifi);

% save stuff
ex.ds.vbl(fi, si) = vbl;
fi = fi + 1;

% poll kb
ex = checkExptKB(ex);
end
if ex.kb.keyCode(ex.kb.escKey)
	error('RunSimpleEdgesExpt:runFake:stimulusAborted', ...
	'you aborted, ex in wkspc');
end
catch me
	ex.me = me;
	return;
end

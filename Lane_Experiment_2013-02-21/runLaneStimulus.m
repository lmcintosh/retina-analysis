function ex = runLaneStimulus(ex)
%
% FUNCTION ex = runLaneStimulus(ex)
%
% The function runLaneStimulus is the template function for running an
% experiment-specific stimulus. In this case, it is the SimpleEdges drifting
% grating stimulus
%
% (c) bnaecker@stanford.edu 28 Jan 2013 

%% get the block number
si = ex.pa.currentStimBlock;

%% start some counters
% start vbl counter
vbl = GetSecs;
% start condition block counter
ci = 1;
% start frame-per-block counter
fi = 1;

%% loop over blocks of frames
try
while fi <= ex.pa.nFrames && ~ex.kb.keyCode(ex.kb.escKey)

	% make mask
	mask = repmat([ex.pa.conditions(fi, 1) 1; ...
		1 ex.pa.conditions(fi, 1)], ex.pa.nBoxes / 2, ex.pa.nBoxes / 2);

	% make the texture
	tex = zeros(ex.pa.nBoxes);
	if strcmp(ex.pa.stimType{si}, 'checkerwhite')
		tex(mask == 1) = ex.pa.whiteNoiseContrast(fi);
		tex(mask == -1) = ex.ds.white - ex.pa.whiteNoiseContrast(fi);
	else
		tex(mask == 1) = ex.pa.pinkNoiseContrast(fi);
		tex(mask == -1) = ex.ds.white - ex.pa.pinkNoiseContrast(fi);
	end

	% truncate
	tex = reshape(min(max(tex(:), ex.ds.black), ex.ds.white), ex.pa.nBoxes, ex.pa.nBoxes);
	
	% make the texture
	texid = Screen('MakeTexture', ex.ds.winPtr, tex);
	
	% draw the texture
	Screen('DrawTexture', ex.ds.winPtr, texid, [], ex.ds.dstRect, 0, 0);
	Screen('Close', texid);

	% draw photodiode
	Screen('FillOval', ex.ds.winPtr, tex(1), ex.pa.pdRect);

	% tell Screen we're done drawing
	Screen('DrawingFinished', ex.ds.winPtr);

	% flip the screen, capture time stamps
	[vbl ex.ds.stimOnset(fi, si) ex.ds.flipTimestamp(fi, si) ...
		ex.ds.flipMissed(fi, si) ex.ds.beamPos(fi, si)] = ...
		Screen('Flip', ex.ds.winPtr, vbl + (ex.pa.waitFrames - 0.5) * ex.ds.ifi);

	% save the new vbl
	ex.ds.vbl(fi, si) = vbl;

	% update counters
	fi = fi + 1;

	% poll keyboard
	ex = checkExptKB(ex);
end
catch me
	ex.me = me;
	return;
end

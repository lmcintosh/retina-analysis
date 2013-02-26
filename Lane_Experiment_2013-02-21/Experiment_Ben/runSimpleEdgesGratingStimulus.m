function ex = runSimpleEdgesGratingStimulus(ex)
%
% FUNCTION ex = runSimpleEdgesGratingStimulus(ex)
%
% This function runs the grating stimulus for the SimpleEdges experiment, both
% the phase-aligned and phase-offset versions.
%
% (c) bnaecker@stanford.edu 28 Jan 2013 

%% get the block number
si = ex.pa.currentStimBlock;

%% save state of random stream
ex.pa.random(si).stateAtStimStart = ex.pa.random(si).stream.State;

%% start some counters
% start vbl counter
vbl = GetSecs;
% start condition block counter
ci = 1;
% start frame-per-block counter
fi = 1;
% total frame counter
tfi = (ci - 1) * ex.pa.nFramesPerCondition + fi;

%% loop over blocks of frames
try
while tfi <= ex.pa.nFrames && ~ex.kb.keyCode(ex.kb.escKey)

	% compute source and destination rectangles (either one or two, depending on alignment)
	if ex.pa.conditionList(ci, 2) == 0
		% x offset
		offset = mod(tfi * ex.pa.offsetPerFrame, (2 / ex.pa.gratingSF));

		% source/dest rects
		srcRect = [offset 0 ex.pa.apertureSize + offset ex.pa.apertureSize]';
		dstRect = ex.ds.dstRect';
	else
		% x offsets
		offset1 = mod(tfi * ex.pa.offsetPerFrame, (2 / ex.pa.gratingSF));
		offset2 = mod(offset1 + ex.pa.conditionList(ci, 2) * ...
			(1 / 360) * (1 / ex.pa.gratingSF), (2 / ex.pa.gratingSF));

		% source rects
		srcRect = [offset1 0 ...
			offset1 + ex.pa.apertureSize ex.pa.conditionList(ci, 1) * ex.pa.apertureSize; ...
			offset2 0 ...
			offset2 + ex.pa.apertureSize (1 - ex.pa.conditionList(ci, 1)) * ex.pa.apertureSize;]';
		dstRect = [ex.ds.dstRect(1:3) ex.ds.dstRect(2) + ex.pa.conditionList(ci, 1) * ex.pa.apertureSize; ...
			ex.ds.dstRect(1) ex.ds.dstRect(2) + ex.pa.conditionList(ci, 1) * ex.pa.apertureSize ...
			ex.ds.dstRect(3:4);]';
	end

	% draw the grating
	Screen('DrawTextures', ex.ds.winPtr, ex.ds.gratingTexId, srcRect, dstRect);

	% draw photodiode
	Screen('FillOval', ex.ds.winPtr, ex.ds.gray + 0.1 .* mod(tfi, 2) * ex.ds.white, ex.pa.pdRect);

	% tell Screen we're done drawing
	Screen('DrawingFinished', ex.ds.winPtr);

	% flip the screen, capture time stamps
	[vbl ex.ds.stimOnset(tfi, si) ex.ds.flipTimestamp(tfi, si) ...
		ex.ds.flipMissed(tfi, si) ex.ds.beamPos(tfi, si)] = ...
		Screen('Flip', ex.ds.winPtr, vbl + (ex.pa.waitFrames - 0.5) * ex.ds.ifi);

	% save the new vbl
	ex.ds.vbl(tfi, si) = vbl;

	% update counters
	if fi == ex.pa.nFramesPerCondition
		fi = 1;
		ci = ci + 1;
	else
		fi = fi + 1;
	end
	tfi = (ci - 1) * ex.pa.nFramesPerCondition + fi;

	% poll keyboard
	ex = checkExptKB(ex);
end
catch me
	ex.me = me;
	return;
end

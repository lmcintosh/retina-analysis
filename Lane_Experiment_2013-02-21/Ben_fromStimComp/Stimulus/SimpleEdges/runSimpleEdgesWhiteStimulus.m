function ex = runSimpleEdgesWhiteStimulus(ex)
%
% FUNCTION ex = runSimpleEdgesWhiteStimulus(ex)
%
% Runs the white noise stimulus for the SimpleEdges experiment 
%
% (c) bnaecker@stanford.edu 28 Jan 2013 

%% get the stimulus block number
si = ex.pa.currentStimBlock;

%% save state of random stream
ex.pa.random(si).stateAtStimStart = ex.pa.random(si).stream.State;

%% loop over frames
vbl = GetSecs;
fi = 1;
try
while fi <= ex.pa.nFrames && ~ex.kb.keyCode(ex.kb.escKey)
	% first make a white noise texture
	tex = ex.ds.gray + ex.ds.gray .* ex.pa.whiteContrast .* ...
		randn(ex.pa.random(si).stream, ex.pa.nBoxes);
	tex = min(max(tex(:), ex.ds.black), ex.ds.white);
	texture(:, :, 1) = round(reshape(tex, ex.pa.nBoxes, ex.pa.nBoxes));
	texture(:, :, 2) = ex.ds.white .* ones(ex.pa.nBoxes, ex.pa.nBoxes);
	texid = Screen('MakeTexture', ex.ds.winPtr, texture);

	% draw the texture, and kill it
	Screen('DrawTexture', ex.ds.winPtr, texid, [], ex.ds.dstRect, 0, 0);
	Screen('Close', texid);

	% draw photodiode
	Screen('FillOval', ex.ds.winPtr, tex(1, 1), ex.pa.pdRect);

	% flip the screen
	Screen('DrawingFinished', ex.ds.winPtr);
	[vbl ex.ds.stimOnset(fi, si) ex.ds.flipTimestamp(fi, si) ...
		ex.ds.flipMissed(fi, si) ex.ds.beamPos(fi, si)] = ...
		Screen('Flip', ex.ds.winPtr, vbl + (ex.pa.waitFrames - 0.5) * ex.ds.ifi);
	
	% save the new vbl
	ex.ds.vbl(fi, si) = vbl;

	% increment the frame counter
	fi = fi + 1;

	% poll the keyboard
	ex = checkExptKB(ex);
end

% print some information if the experiment was quit early
if ex.kb.keyCode(ex.kb.escKey)
	error('RunSimpleEdgesExperiment:runSimpleEdgesWhiteStimulus:stimulusAborted', ...
		'You quit the experiment early. Nothing will be saved, but the expt struct is in the wkspc');
end
catch me
	ex.me = me;
	return;
end

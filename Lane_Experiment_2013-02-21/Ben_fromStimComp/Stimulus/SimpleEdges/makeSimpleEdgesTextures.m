function ex = makeSimpleEdgesTextures(ex)
%
% FUNCTION ex = makeSimpleEdgesTextures(ex)
%
% The function makeSimpleEdgesTextures makes the textures used in the
% SimpleEdges experiment.
%
% (c) bnaecker@stanford.edu 28 Jan 2013 

%% notify
Screen('DrawText', ex.ds.winPtr, ...'
	['Creating textures for ' ex.pa.experimentName ' experiment'], 50, 50);
Screen('Flip', ex.ds.winPtr);

%% create a texture (just one 1-D grating)
% grating support
x = meshgrid(1:ex.pa.apertureSize + 2 / ex.pa.gratingSF, 1);

% compute grating
if strcmp(ex.pa.gratingType, 'sine')
	gratingTex = ex.ds.gray + ex.pa.gratingContrast .* ex.ds.gray .* ...
		sin( 2 * pi * ex.pa.gratingSF .* x );

elseif strcmp(ex.pa.gratingType, 'square')
	% compute sine wave
	wv = sin( 2 * pi * ex.pa.gratingSF .* x );

	% make it square
	wv(wv > 0) = 1;
	wv(wv <= 0) = -1;

	% add to gray background to make the texture itself
	gratingTex = ex.ds.gray + ex.pa.gratingContrast .* ex.ds.gray .* wv;
else
	error('RunSimpleEdgesExpt:makeSimpleEdgesTextures:unknownWaveType', ...
	['The requested grating type "' ex.pa.gratingType '" is unknown.']);
end

% save grating texture matrix
ex.ds.gratingTexMtx = gratingTex;

% make the texture itself
ex.ds.gratingTexId = Screen('MakeTexture', ex.ds.winPtr, gratingTex);

function ex = setupLaneParams(ex)
%
% FUNCTION ex = setupTemplateParams(ex)
%
% The function setupTemplateParams is the template function to create experimental
% parameters.
%
% see also: RunTemplateExpt.m
%
% (c) bnaecker@stanford.edu 20 Feb 2013

%% Notify
Screen('DrawText', ex.ds.winPtr, 'Creating stimulus parameters ... ', ...
	50, 50);
Screen('Flip', ex.ds.winPtr);

%% basic information
ex.pa.experimentName = 'Lane';
ex.pa.date = datestr(now, 30);
ex = makeSaveDirectory(ex);

%% stimulus types
%ex.pa.stimType = ['white'; 'white'; cellstr(repmat('checkers', ex.pa.nReps, 1))];
tmp = cell(ex.pa.nReps, 1);
for ri = 1:ex.pa.nReps
	if mod(ri, 2) == 0
		tmp{ri} = 'checkerwhite';
	else
		tmp{ri} = 'checkerpink';
	end
end
whiteStims = cellstr(repmat('white', 2, 1));
ex.pa.stimType = [whiteStims; tmp];

%% aperture information
ex.pa.apertureSize = 512;					    % size of aperture, pixels
ex.pa.waitFrames = 2;						    % frames between each flip
ex.pa.umPerPix = 50 / 9;					    % approx. micron-to-pixel conversion
ex.ds.dstRect = CenterRectOnPoint(...		    % aperture destination rectangle
	[0 0 ex.pa.apertureSize ex.pa.apertureSize], ...
	ex.ds.winCtr(1), ex.ds.winCtr(2));

%% number of frames per repetition
ex.pa.nFrames = ex.pa.time * (ex.ds.frate / ex.pa.waitFrames);

%% white noise information
ex.pa.nBoxes = 32;							    % used as resolution for ALL stimuli
ex.pa.whiteContrastIndex = ones(ex.pa.nFrames, 1);

%% create conditions 
corrs = [1 -1];
contrasts = [0.05 0.35];
ex.pa.conditionList = cartprod(...
	contrasts, corrs);
ex.pa.nConditions = size(ex.pa.conditionList, 1);

%% make correlations condition
cs = vec(ones(ex.pa.nFrames / 2, 1) * corrs);
tmp = vec(ones(ex.pa.nFrames / 8, 1) * repmat(contrasts, 1, 4));
ex.pa.conditions = [cs tmp];

%% random seed for each stimulus block
for ri = 1:length(ex.pa.stimType)
	ex.pa.random(ri).stream = ...
		RandStream.create('mrg32k3a', 'Seed', 1);
end

%% make contrasts
[ex.pa.random(~strcmp(ex.pa.stimType, 'white')).stateAtStimStart] = ...
	deal(ex.pa.random(end).stream.State);
ex.pa.whiteNoiseContrast = ex.ds.gray + ex.ds.gray .* ...
	ex.pa.conditions(:, 2) .* randn(ex.pa.random(end).stream, ex.pa.nFrames, 1);
[p, Xstd] = GetPinkNoise(1, ex.pa.nFrames, ex.pa.conditions(:, 2), ex.ds.gray, 0);
ex.pa.pinkNoiseContrast = vec(p);

%% photodiode description
ex.pa.pdCenter = [.93 .15];                	    % center of rect, in screen percentages
ex.pa.pdRectSize = SetRect(0, 0, 100, 100);	    % actual screen size (pixels)
ex.pa.pdRect = CenterRectOnPoint(...       	    % the rectangle
    ex.pa.pdRectSize, ex.ds.winRect(3) .* ex.pa.pdCenter(1), ...
    ex.ds.winRect(4) .* ex.pa.pdCenter(2));

%% preallocate timestamp information
ex.ds.vbl = zeros(ex.pa.nFrames, ...		    % system estimate of flip time
	length(ex.pa.stimType));
ex.ds.stimOnset = ex.ds.vbl;				    % PTB's guess as to the stimulus onset
ex.ds.flipTimestamp = ex.ds.vbl;			    % timestamp after completion of flip
ex.ds.flipMissed = ex.ds.vbl;				    % PTB's guess if the flip was missed
ex.ds.beamPos = ex.ds.vbl;					    % beam position at vbl timestamp request

%% start your engines
ex.pa.initializeTime = GetSecs;

function ex = setupHighLowContrastCheckersParams(ex)
%
% FUNCTION ex = setupHighLowContrastCheckersParams(ex)
%
% The function setupHighLowContrastCheckersParams sets up the experimental parameters used
% in the HighLowContrastCheckers experiment.
%
% see also: RunHighLowContrastCheckersExpt.m
%
% Adapted from bnaecker@stanford.edu 25 Jan 2013 

%% Notify
Screen('DrawText', ex.ds.winPtr, 'Creating stimulus parameters ... ', ...
	50, 50);
Screen('Flip', ex.ds.winPtr);

%% basic information
ex.pa.experimentName = 'HighLowContrastCheckers';
ex.pa.date = datestr(now, 30);
ex = makeSaveDirectory(ex);

%% stimulus types
% 2 white noise blocks appended at beginning - for RF measurement?
tmp = cellstr(repmat('checkers', ex.pa.nReps, 1));
if ex.pa.useWhite
	ex.pa.stimType = ['white'; 'white'; tmp];
else
	ex.pa.stimType = tmp;
end

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
ex.pa.nBoxes = 64;							    % used as resolution for ALL stimuli
ex.pa.whiteContrast = ex.pa.whiteContrast .* ones(ex.pa.nFrames, 1);
ex.pa.whiteContrastIndex = ones(ex.pa.nFrames, 1);

%{
%% create conditions
conditionList = cartprod(...
	ex.pa.splitPosition, ...
	ex.pa.phaseOffset);
ex.pa.nConditions = size(conditionList, 1);
ex.pa.conditionList = conditionList(randperm(ex.pa.nConditions), :);
%}

%% compute number of frames per condition
ex.pa.nFramesPerCondition = ex.pa.nFrames / ex.pa.nConditions;

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

%% random seed for each stimulus block
for ri = 1:length(ex.pa.stimType)
	ex.pa.random(ri).stream = ...
		RandStream.create('mrg32k3a', 'Seed', 1);
end

%% start your engines
ex.pa.initializeTime = GetSecs;

function ex = parseHighLowContrastCheckersInput(varargin)
%
% FUNCTION ex = parseHighLowContrastCheckersInput((varargin)
%
% Parses the variable argument input to the HighLowContrastCheckers experiment. 
%
% adapted from bnaecker@stanford.edu 24 Jan 2013 

% length of each repeat (seconds)
if any(strcmpi('time', varargin))
	ex.pa.time = varargin{find(strcmpi('time', varargin)) + 1};
else
	ex.pa.time = 250;
end

% number of repetitions of each stimulus block
if any(strcmpi('nreps', varargin))
	ex.pa.nReps = varargin{find(strcmpi('nreps', varargin)) + 1};
else
	ex.pa.nReps = 10;
end

% trigger
if any(strcmpi('trigger', varargin))
	ex.pa.trigger = varargin{find(strcmpi('trigger', varargin)) + 1};
else
	ex.pa.trigger = 'm';
end

% contrast for white-noise receptive field measurement
if any(strcmpi('c', varargin))
	%ex.pa.gratingContrast = varargin{find(strcmpi('c', varargin)) + 1};
	ex.pa.whiteContrast = varargin{find(strcmpi('c', varargin)) + 1};
    ex.pa.pinkContrast = varargin{find(strcmpi('c', varargin)) + 1};
else
	%ex.pa.gratingContrast = 0.25;
	ex.pa.whiteContrast = 0.25;
    ex.pa.pinkContrast = 0.25;
end

% contrast for high-contrast stimuli
if any(strcmpi('cH', varargin))
	%ex.pa.gratingContrast = varargin{find(strcmpi('c', varargin)) + 1};
	ex.pa.whiteContrastH = varargin{find(strcmpi('cH', varargin)) + 1};
    ex.pa.pinkContrastH = varargin{find(strcmpi('cH', varargin)) + 1};
else
	%ex.pa.gratingContrast = 0.25;
	ex.pa.whiteContrastH = 0.35;
    ex.pa.pinkContrastH = 0.35;
end

% contrast for low-contrast stimuli
if any(strcmpi('cL', varargin))
    ex.pa.whiteContrastL = varargin{find(strcmpi('cL', varargin)) + 1};
    ex.pa.pinkContrastL = varargin{find(strcmpi('cL', varargin)) + 1};
else
    ex.pa.whiteContrastL = 0.05;
    ex.pa.pinkContrastL = 0.05;
end

% prepend white noise blocks
if any(strcmpi('white', varargin))
	ex.pa.useWhite = varargin{find(strcmpi('white', varargin)) + 1};
else
	ex.pa.useWhite = true;
end

% duration of same contrast
if any(strcmpi('cDur', varargin))
    ex.pa.cDur = varargin{find(strcmpi('cDur', varargin)) + 1};
else
    ex.pa.cDur = 20; % sec
end

% duration of same case (x = y or x = -y)
if any(strcmpi('corrDur', varargin))
    ex.pa.corrDur = varargin{find(strcmpi('corrDur', varargin)) + 1};
else
    ex.pa.corrDur = 40; % sec
end

% for each case have contrast X
if any(strcmpi('contrastSeq', varargin))
    ex.pa.contrastSeq = varargin{find(strcmpi('contrastSeq', varargin)) + 1};
else
    ex.pa.contrastSeq = {'low','high','low','high'};
end

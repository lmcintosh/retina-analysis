function ex = RunContrastCheckersExpt(varargin)
%
% FUNCTION ex = RunContrastCheckersExpt(varargin)
%
% The function RunContrastCheckersExpt runs the experimental stimulus for the Predictive
% Information experiment. Creates checkerboard with cases x=y and x=-y where
% x is white noise or pink noise in time that switches between regimes of high and low 
% contrast.
%
% Adapted from bnaecker@stanford.edu 24 Jan 2013 

try

%% parse varargin
ex = parseHighLowContrastCheckersInput(varargin{:});

%% setup keyboard
ex = setupExptKB(ex);

%% initialize display
ex = initDisplay(ex);

%% set up experimental parameters
ex = setupSimpleEdgesParams(ex);

%% make textures
ex = makeSimpleEdgesTextures(ex);

%% wait for trigger
ex = waitForTrigger(ex);

%% run experiment
for si = 1:length(ex.pa.stimType)
	% set current stimulus type
	ex.pa.currentStimBlock = si;

	% switch on the stimulus type
	switch ex.pa.stimType{si}
		case 'white'
			ex = runBarsWhiteNoise(ex); % here this could also be runSpatialWhiteNoise
		case 'grating'
			ex = runSimpleEdgesGratingStimulus(ex);
	end

	% break if error
	if isfield(ex, 'me');
		break;
	end
end

% save experimental structure
ex = saveExptStruct(ex);

%% clean up
sca;
ListenChar(0);
ShowCursor;
Priority(0);

catch me
% catch errors
ex.me = me;

% clean up
sca;
ListenChar(0);
ShowCursor;
Priority(0);
end

function ex = RunSimpleEdgesExpt(varargin)
%
% FUNCTION ex = RunSimpleEdgesExpt(varargin)
%
% The function RunSimpleEdgesExpt runs the experimental stimulus for the SimpleEdges
% experiment. Two squarewave gratings are offset from one another in phase and drifting.
%
% (c) bnaecker@stanford.edu 24 Jan 2013 

try

%% parse varargin
ex = parseSimpleEdgesInput(varargin{:});

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
			ex = runBarsWhiteNoise(ex);
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

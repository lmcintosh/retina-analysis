function ex = RunLaneExpt(varargin)
%
% FUNCTION ex = RunLaneExpt(varargin)
%
% The function RunLaneExpt is the template for the top-level function to run a basic
% experimental stimulus.
%
% (c) bnaecker@stanford.edu 20 Feb 2013

try

%% parse varargin
ex = parseLaneInput(varargin{:});

%% setup keyboard
ex = setupExptKB(ex);

%% initialize display
ex = initDisplay(ex);

%% set up experimental parameters
ex = setupLaneParams(ex);

%% make textures
%ex = makeLaneTextures(ex);

%% wait for trigger
ex = waitForTrigger(ex);

%% run experiment
for si = 1:length(ex.pa.stimType)
	% set current stimulus type
	ex.pa.currentStimBlock = si;

	% switch on the stimulus type
	switch ex.pa.stimType{si}
		case 'white'
			ex = runSpatialWhiteNoise(ex);
		case {'checkerwhite', 'checkerpink'}
			ex = runLaneStimulus(ex);
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

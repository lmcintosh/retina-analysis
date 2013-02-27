function ex = setupCorrExptParams(ex)
%
% ex = setupCorrExptParams(ex) sets up the parameters for the Baccus
% lab experiments
%
% (c) bnaecker@stanford.edu 12 Feb 2012

%% Notify
Screen('DrawText', ex.ds.winPtr, 'Creating stimulus parameters', ...
    50, 50);
Screen('Flip', ex.ds.winPtr);

%% Main setup
ex.pa.date = datestr(now, 30);
ex = makeSaveDirectory(ex);
ex.pa.experimentName = 'Correlation';

%% Aperture information
ex.pa.stimSize = 512;                  % Size of square aperture, pixels
ex.pa.waitFrames = 2;                  % Frames between each flip
ex.pa.textureScaleFactor = 6;          % Make textures (pink/natural) larger than aperture
ex.pa.umPerPix = 50 / 9;               % Approx. micron-to-pixel conversion
ex.pa.lowContrastPctTime = 2/3;        % Pct time on low contrast WN versus hi
ex.ds.dstRect = CenterRectOnPoint(...  % The aperture destination rectangle
        [0 0 ex.pa.stimSize ex.pa.stimSize], ...  
        ex.ds.winCtr(1), ex.ds.winCtr(2));
ex.pa.stimRes = 32;
ex.ds.srcRect = CenterRectOnPoint(...  % change the resolution of the natural and pink stims
		[0 0 ex.pa.stimRes ex.pa.stimRes], ...
		ex.ds.winCtr(1), ex.ds.winCtr(2));


%% Number of frames
ex.pa.nFrames = ex.pa.time * (ex.ds.frate / ex.pa.waitFrames);

%% White noise info
ex.pa.whiteContrast = [.08 .35];       % Low/Hi (% of mean)
% Setup contrast indices
nLowContrastFrames = ceil(ex.pa.nFrames * ex.pa.lowContrastPctTime);
ex.pa.whiteContrastIndex = [ones(nLowContrastFrames, 1); ...
    2 .* ones(ex.pa.nFrames - nLowContrastFrames, 1)];
ex.pa.nBoxes = 32;

%% Pink noise info
ex.pa.alpha = 1;               % Exponent to 1/f noise

%% Natural image size
ex.pa.naturalImgSize = [1007 1519];
ex.pa.fixMoveSize = 1;      % SD of size of fixational eye movements (um)
ex.pa.interSaccTime = 2;       % Mean time between saccades (s) (normal dist.)
ex.pa.interSaccSd = .5;        % SD of time between saccades (s)
ex.pa.saccExpMu = 50;          % Mu for exponential dist over saccade size (um)
ex.pa.saccMax = 1500;          % Maximum saccade size (um)
ex.pa.textureSwitchProb = .005;% Probability of switching natural images on a frame

%% Photodiode description
ex.pa.pdCenter = [.93 .15];                % Center of rect, in screen percentages
ex.pa.pdRectSize = SetRect(0, 0, 100, 100);% Actual screen size (pixels)
ex.pa.pdRect = CenterRectOnPoint(...       % The rectangle
    ex.pa.pdRectSize, ex.ds.winRect(3) .* ex.pa.pdCenter(1), ...
    ex.ds.winRect(4) .* ex.pa.pdCenter(2));

%% Preallocate the timestamp information
ex.ds.vbl = zeros(ex.pa.nFrames, ...      % The time of the flip request
    length(ex.pa.stimType)); 
ex.ds.stimOnset = ex.ds.vbl;              % PTB's guess as to the stimulus onset
ex.ds.flipTimeStamp = ex.ds.vbl;          % The timestamp after completion of the flip
ex.ds.flipMissed = ex.ds.vbl;             % PTB's estimate
ex.ds.beamPos = ex.ds.vbl;                % The vertical beam position at the call
ex.ds.texId = zeros(ex.pa.nFrames, length(ex.pa.stimType));
ex.ds.textureTimer = ex.ds.texId;

%% Create a random seed for each stimulus block
for ri = 1:length(ex.pa.stimType)
    ex.pa.random(ri).stream = ...
        RandStream.create('mrg32k3a', 'Seed', 1);
end

%% Start your engines
ex.pa.initializeTime = GetSecs;

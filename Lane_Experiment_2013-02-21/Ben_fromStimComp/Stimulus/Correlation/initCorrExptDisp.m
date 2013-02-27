function ex = initCorrExptDisp(ex)
%
% function ex = initCorrExptDisp(ex)
%
% Initialize display for the correlation experiments in the Baccus lab
%
% (c) bnaecker@stanford.edu 18 Jan 2012

AssertOpenGL;

%% Default arguments
defarg('stereoMode', 0);
defarg('screenSize', []);
defarg('bgCol', [128 128 128]);
ex.ds.stereoMode = stereoMode;

%% Find display name
if ~exist('dType', 'var') || isempty(dType)
    % Get hostname
    [f hn] = system('hostname');
    hn = hn(1:end - 1);
    
    % Figure out what system we're on
    if ~f
        switch hn
            case {'dn52e63s.sunet', 'dn52e6i7.sunet'}   % bnaecker MBP
                if max(Screen('Screens')) > 1
                    dType = 'dell';
                else
                    dType = 'mbp15';
                end
            case {'baccusmac', 'hr-ozuysal-1201722562.stanford.edu'}
                dType = 'baccusmac';
            case 'baccuspc'
                dType = 'baccuspc';
            otherwise
                dType = 'mbp15';
        end
    end
end
for r = 1:length(ex.pa);
    ex.pa(r).hostName = hn;
end

%% Get Screen
ex.ds.screenNum = max(Screen('Screens'));

%% Initialize and setup PsychImaging pipeline
InitializeMatlabOpenGL;
Screen('Preference', 'VisualDebugLevel', 3);
% PsychImaging('PrepareConfiguration');
% PsychImaging('AddTask', 'General', 'FloatingPoint32BitIfPossible');

%% Open double-buffered window
% [ex.ds.winPtr, ex.ds.winRect] = ...
%     PsychImaging('OpenWindow', ex.ds.screenNum, bgCol, screenSize, ...
%     [], [], ex.ds.stereoMode, 0, [], 'kPsychNeedFastBackingStore');
[ex.ds.winPtr, ex.ds.winRect] = ...
    Screen('OpenWindow', ex.ds.screenNum, bgCol, screenSize);

%% Get display basics
ex.ds.ifi = Screen('GetFlipInterval', ex.ds.winPtr);
ex.ds.frate = round(1/ex.ds.ifi);
ex.ds.winCtr = [ex.ds.winRect(3:4), ex.ds.winRect(3:4)] ./ 2;
ex.ds.info = Screen('GetWindowInfo', ex.ds.winPtr);

%% Colors
ex.ds.white = WhiteIndex(ex.ds.screenNum);
ex.ds.black = BlackIndex(ex.ds.screenNum);
ex.ds.gray = (ex.ds.white + ex.ds.black) / 2;

%% Text
Screen('TextFont', ex.ds.winPtr, 'Helvetica');
Screen('TextSize', ex.ds.winPtr, 16);
Screen('TextStyle', ex.ds.winPtr, 1);

%% Alpha-blending
% Screen('BlendFunction', ex.ds.winPtr, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
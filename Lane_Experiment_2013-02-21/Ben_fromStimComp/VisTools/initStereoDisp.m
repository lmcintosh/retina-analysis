function ds = initStereoDisp(stereoMode, dType, screenSize, bgCol)
% function ds = initStereoDisp(stereoMode, dType, screenSize, bgCol)
%
% Initialize display for stereo viewing
%
% Acceptable values for ds.StereoMode:
%       (default is 4)
% 0 == Mono display - No stereo
% 1 == Alternate frame stereo (temporally interleaved) for CrystalEyes Shutterglasses
% 2 == Top/bottom stereo with lefteye=top for use with CrystalEyes hardware
% 3 == As 2, but with lefteye=bottom.
% 4 == Free fusion (lefteye=left, righteye=right)
% 5 == Cross fusion (lefteye=right ...)
% 6-9 == Anaglyph stereo modes for color filter glasses:
% 6 == Red-Green, 7 == Green-Red, 8 == Red-Blue, 9 == Blue-Red
%
% (c) bnaecker@stanford.edu 10 Nov 2011 (adapted from Huk/Cormack Labs
% version, written by TBC)

AssertOpenGL;

%% Setup the display
% Default arguments
defarg('stereoMode', 4);
defarg('screenSize', []);
defarg('bgCol', [128 128 128]);
ds.stereoMode = stereoMode;

% Define display name
if ~exist('dType', 'var') || isempty(dType)
    % Get hostname
    [flag hn] = system('hostname');
    hn = hn(1:end - 1);
    
    if ~flag
        switch hn
            case 'dn52e63s.sunet'       % bnaecker's MBP
                if max(Screen('Screens')) > 1
                    dType = 'dell';
                else
                    dType = 'mbp15';
                end
            case 'baccusmac'
                dType = 'baccusmac';
            case 'baccuspc'
                dType = 'baccuspc';
            otherwise                   % Everything else
                dType = 'mbp15';
        end
    end
end
ds.dType = dType;

% Get number of screens and the screen size
ds.screenNum = max(Screen('Screens'));
switch lower(dType)
    case 'dell'
        ds.widthcm = 34;
        ds.viewdist = 90;
    case 'mbp15'
        ds.widthcm = 34;
        ds.viewdist = 50;
    case 'baccusmac'
        ds.widthcm = 25;
        ds.viewdist = 50;
    case 'baccuspc'
        ds.widthcm = 25;
        ds.viewdist = 50;
end
fprintf(['\nDisplay Type = ', dType, ', Viewing Distance = %g\n'], ds.viewdist);

if ds.stereoMode >= 6 || ds.stereoMode <= 1
    ds.width = 2*atand((ds.widthcm/2)/ds.viewdist);
else
    ds.width = 2*atand((ds.widthcm/4)/ds.viewdist);
end

%% Initialize Psychtoolbox and the PsychImaging pipeline
InitializeMatlabOpenGL;
Screen('Preference', 'VisualDebugLevel', 3);

% Initialize PI configurations
PsychImaging('PrepareConfiguration');
% Request closest thing to 32bpc floating-point framebuffer
PsychImaging('AddTask', 'General', 'FloatingPoint32BitIfPossible');

% % Get gamma table for each buffer
% PsychImaging('AddTask', 'LeftView', 'DisplayColorCorrection', 'LookupTable');
% PsychImaging('AddTask', 'RightView', 'DisplayColorCorrection', 'LookupTable');
fprintf('\n\n\n***WARNING: No gamma table loaded***\n\n\n');

%% Open double-buffered windows
[ds.winPtr, ds.winRect] = PsychImaging('OpenWindow', ds.screenNum, bgCol, screenSize, ...
    [], [], ds.stereoMode, 0, [], 'kPsychNeedFastBackingStore');

%% Get display basics
ds.ppd = ds.winRect(3)/ds.width;
ds.frate = round(1/Screen('GetFlipInterval', ds.winPtr));
ds.ifi = Screen('GetFlipInterval', ds.winPtr);
ds.winCtr = [ds.winRect(3:4), ds.winRect(3:4)] ./ 2;
ds.info = Screen('GetWindowInfo', ds.winPtr);

% Colors
ds.white = WhiteIndex(ds.screenNum);
ds.black = BlackIndex(ds.screenNum);
ds.gray = (ds.white + ds.black) / 2;

% Set general text
Screen('TextFont', ds.winPtr, 'Helvetica');
Screen('TextSize', ds.winPtr, 16);
Screen('TextStyle', ds.winPtr, 1);

%% Alpha-blending
Screen('BlendFunction', ds.winPtr, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
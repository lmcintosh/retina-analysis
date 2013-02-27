function ds = Init_StereoDispPI(stereomode, dtype, ScreenSize, bgcol)
% function ds = Init_StereoDispPI(stereomode, dtype, ScreenSize, bgcol)
% 
% Initialize display for stereo viewing using the new PsychImaging processes.
% 
% [dtype] selects display being used. When a gamma correction has been defined for that display,
% will also load corrected gamma table.  Otherwise, just specifies screen size and viewing distance
% for calculating visual degrees.
% 
% Currently defined display types:
%   's'     = 42" Sharp display (w/ gamma)
%   'mbp'   = macbook pro (w/o gamma)   ***default***
%   'mb'    = macbook (w/o gamma)
%   'imac'  = 24" iMac (w/o gamma)
%   'irc'   = scanner projector (w/ gamma)
%   'bl'    = BrainLogic projector at IRC. (set ND filter straight down ("6:00")
%   'opt'   = Optoma EP7155 DLP projector
%   'G220'  = ViewSonic G220fb, in Pillow Lab
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

% if exist('ds.StereoMode')
%     disp.StereoMode = ds.StereoMode;
% else
%     defarg('disp.StereoMode',4);
% end

AssertOpenGL;

defarg('stereomode',4);
ds.StereoMode = stereomode;
% set screen size to full if none provided
defarg('ScreenSize',[])
% def background color 8-bit grey
defarg('bgcol',[128 128 128]);


if ~exist('dtype','var') || isempty(dtype)
    [f hn] = system('hostname'); hn=hn(1:end-1); %get computer name and trim off LF at end
    if ~f
        switch hn
            case 'elephantroom' % LCD stereo setup
                if iswin
                    dtype = 'DQ';
                else
                    dtype = 's';
                end
            case 'emos'
                dtype = 'G90';  % Dual display stereo setup
            case {'stubbs','saxon','continental','elysium'} % all lab iMacs
                dtype = 'imac';
            case {'frisbee'}    % MacBookPros
                dtype = 'mbp';
            case {'cormackMacBookPro'}
                dtype = 'mbp17';
            case {'pillow833290'}
                dtype = 'G220';
            otherwise
                hn = [hn,' --NO MATCH FOUND!']; % Use MacBook Pro size as default
                dtype = 'mbp';
        end
    else
        dtype = input('Which display? (mbp, mb, or s (42" Sharp)) ','s');
        if isempty(dtype)
            dtype = 'imac';
        end
    end
end
AssertOpenGL;

ds.dtype = dtype;

% Get the list of Screens and choose the one with the highest screen
% number, as a best guess about where you want the stimulus displayed
ds.scrnNum = max(Screen('Screens'));

% Calculate screen size
switch lower(dtype)
    case 's'
        ds.widthcm = 93; % Screen width in cm
        ds.viewdist = 70.0; % In cm
        ds.gamma = getgamma(dtype); % gets gamma table from file specified in getgamma.m

    case 'mbp'
        ds.widthcm = 30.5;
        ds.viewdist = 45.0;

            case 'scone'
                ds.widthcm = 30.5;
                ds.viewdist = 45.0;
                ds.gamma = getgamma(dtype);

    case 'mb'
        ds.widthcm = 25.0;
        ds.viewdist = 45.0;
        
    case 'imac'
        ds.widthcm = 52.0;
        ds.viewdist = 70.0;
        
    case 'irc'
        ds.widthcm = 30.5; %34.3?  TBC 03-10-09
        ds.viewdist = 110;
        ds.gamma = getgamma(dtype);
        
    case 'mrilg'
        ds.widthcm = 92; % estimate from 42" samsung...need real vals
        ds.viewdist = 245.0;       % meas 3/4/10
        ds.gamma = getgamma(dtype);
        
    case 'bl' %Brain Logic projector, ND filter @ 6:00
        ds.widthcm = 27;
        ds.viewdist = 49;
        ds.gamma = getgamma(dtype);
        
    case 'g90'
        ds.widthcm = 70;
        ds.viewdist = 90.0;
        ds.gamma = getgamma(dtype);
        
        case 'g90color'
            ds.widthcm = 70;
            ds.viewdist = 90.0;
            ds.gamma = getgamma(dtype);
            ds = Init_Color(ds);

        case 'g90dual'
            ds.widthcm = 70;
            ds.viewdist = 90.0;
            ds.gamma = getgamma(dtype);
            
    case 'g220'
        ds.widthcm = 40.5;
        ds.viewdist = 60;
        ds.gamma = getgamma(dtype);

    case 'mbp17'
        ds.widthcm = 36.5;
        ds.viewdist = 45;
        
    case 'opt'
        ds.widthcm = 100;
        ds.viewdist = 280;
        
    case 'dq'   % DepthQ 120Hz stereo projector
        ds.widthcm = 100;  % PsyPhy room approximations...not for real experimental use.
        ds.viewdist = 280;
        ds.StereoMode = 1;
end
fprintf(['\ndtype = ',dtype,', viewing dist = %g\n'],ds.viewdist);

if ds.StereoMode >= 6 || ds.StereoMode <=1
    ds.width = 2*atand((ds.widthcm/2)/ds.viewdist);
else
    ds.width = 2*atand((ds.widthcm/4)/ds.viewdist);
end

%% Initialize 
% Setup Psychtoolbox for OpenGL 3D rendering support and initialize the
% mogl OpenGL for Matlab wrapper:
InitializeMatlabOpenGL;
% prevent splash screen
Screen('Preference','VisualDebugLevel',3);

% Initiate PI screen configs
PsychImaging('PrepareConfiguration');
% Request 32bpc floating point framebuffer for imaging pipeline. If not possible by hardware, make
% closest operable match.
PsychImaging('AddTask', 'General', 'FloatingPoint32BitIfPossible');

% setup Planar mirror mode for 2nd (top) display
if ds.StereoMode == 5
    PsychDatapixx('Open');
    PsychDatapixx('SetVideoHorizontalSplit', 1);
    PsychImaging('AddTask', 'RightView', 'FlipHorizontal');
    Beeper(1200,.5,.05),Beeper(1400,.5,.05),Beeper(1200,.5,.05)
end

if isfield(ds,'gamma') && isstruct(ds.gamma) && size(ds.gamma.table,3)>1
    % fancy gamma table for each stereobufer
    PsychImaging('AddTask', 'LeftView', 'DisplayColorCorrection', 'LookupTable');
    PsychImaging('AddTask', 'RightView', 'DisplayColorCorrection', 'LookupTable');
end

%% Open double-buffered onscreen window with the requested stereo mode:
[ds.ptr, ds.winRect]=PsychImaging('OpenWindow', ds.scrnNum, bgcol, ScreenSize, [], [], ds.StereoMode, 0, [],'kPsychNeedFastBackingStore');

if ds.StereoMode == 10 % Open slave window if using 2 monitors (not applicable when using Matrox DualHead2Go)
    PsychImaging('OpenWindow',ds.scrnNum-1, bgcol, ScreenSize, [], [], ds.StereoMode, 0, [],'kPsychNeedFastBackingStore');
end

%% Load normalized gamma table
if isfield(ds,'gamma')  %exist('gamtrig','var')
    if isstruct(ds.gamma)
        if size(ds.gamma.table,3)>1
            disp('...DONT THINK THIS WORKS YET...LUT IS WASHED OUT!')
            Snd('Play', [sin(0:1000),sin(0:.1:100),sin(0:1000)]);
            
            ds.oldgamma = Screen('ReadNormalizedGammaTable', ds.ptr);
            PsychColorCorrection('SetLookupTable', ds.ptr, ds.gamma.table(:,:,1), 'LeftView');
            PsychColorCorrection('SetLookupTable', ds.ptr, ds.gamma.table(:,:,2), 'RightView');
        else
            ds.oldgamma = Screen('LoadNormalizedGammaTable', ds.ptr, ds.gamma.table);
        end
    else
        ds.oldgamma = Screen('LoadNormalizedGammaTable', ds.ptr, ds.gamma(:,:,1));
    end
else
    ds.oldgamma = Screen('ReadNormalizedGammaTable',ds.ptr);
    fprintf('\n\n\n***WARNING: No gamma table loaded***\n\n\n')
end

%             ds.oldgamma = Screen('ReadNormalizedGammaTable', ds.ptr);
%             PsychColorCorrection('SetLookupTable', ds.ptr, ds.gamma, 'LeftView');
%             PsychColorCorrection('SetLookupTable', ds.ptr, ds.gamma, 'RightView');


% Set some basic variables about the display
ds.ppd = ds.winRect(3)/ds.width;                        % calculate pixels per degree
ds.frate = round(1/Screen('GetFlipInterval',ds.ptr));   % frame rate (in Hz)
ds.ifi=Screen('GetFlipInterval', ds.ptr);               % Inter-frame interval (frame rate in seconds)
ds.ctr = [ds.winRect(3:4),ds.winRect(3:4)]./2;          % Rect defining screen center
ds.info = Screen('GetWindowInfo', ds.ptr);              % Record a bunch of general display settings

% Set screen rotation
ds.ltheta = 0.00*pi;                                    % Screen rotation to adjust for mirrors
ds.rtheta = -ds.ltheta;
ds.scr_rot = 0;                                         % Screen Rotation for opponency conditions

% Define some colors
ds.white=WhiteIndex(ds.scrnNum);
ds.black=BlackIndex(ds.scrnNum);
ds.gray=(ds.white+ds.black)/2;
if round(ds.gray)==ds.white
    ds.gray=ds.black;
end
ds.inc=ds.white-ds.gray;

% Make text clean
Screen('TextFont',ds.ptr,'Helvetica');
Screen('TextSize',ds.ptr,16);
Screen('TextStyle',ds.ptr,1);


%% Make function handles for some useful shapes

% ds.cross(pos,r)
%       Returns Screen('DrawLines') coords for a cross centered on pos [x,y] with length r
%       Vectorized so that pos can be columns of [x;y] coords, but r must be be single integer.
%   Ex)
%       sz = 500; r = 15;
%       pos = roundrand(10,2)*500;
%       Screen('DrawLines', ds.ptr, ds.cross(pos, r), 2)
%       Screen('Flip', ds.ptr);
% 
ds.cross = @(pos,r) (kron(pos,ones(4,1))+repmat([-r-1,r,0,0;0,0,-r-1,r]',size(pos,1),1))';


% ds.holes(img, pos, sd)
%       Pokes gaussian holes of size [sd in pixels] in alpha channel of imgage matrix [img, size x by y by (1 or 3)] centered on points [pos]
%   Ex) 
%       sz = 500;
%       bg = oneoverf(1, sz).*ds.white;
%       pos = round(rand(20,2).*sz);
%       tex = Screen('MakeTexture', ds.ptr, ds.holes(bg, pos, 10));
%       Screen('DrawTexture', ds.ptr, tex, [], [0,0,sz,sz]);
%       Screen('Flip', ds.ptr);
% 
ds.holes = @(img,pos,sd)  cat(3,img, imclip(filter2(ggaus(7*sd, sd), mkpts(zeros(size(img(:,:,1))), pos)),1).*ds.white);

% ds.donut(rMin, rMax, size)
%       Create Gaussian donut in the alpha channel of size '+/- size' (needs to be square), with mean (rMax + rMin)/2
%       and SD (rMax - rMin)/7.  These should be in pixels.
ds.donut = @(rMin, rMax, size) normalize(normpdf(getRad(size), (rMax + rMin) / 2, (rMax - rMin) / 7), 0, ds.white);


%% Set up alpha-blending for smooth (anti-aliased) drawing of dots:
Screen('BlendFunction', ds.ptr, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');  % alpha blending for anti-aliased dots
% Screen('BlendFunction', ds.ptr, GL_ONE, GL_ONE);      % No alpha blending

ds.t0 = Screen('Flip', ds.ptr);

if exist('hn','var')
    fprintf('\n---------------------------------------------------------------------------\n');
    fprintf('Computer ID: "%s". Using associated display: %s\n',hn,dtype)
    fprintf('---------------------------------------------------------------------------\n');
end



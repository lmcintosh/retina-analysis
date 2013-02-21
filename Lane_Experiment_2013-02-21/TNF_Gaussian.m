function objSeed = TNF_Gaussian(checkers, sizes, maskMode, varargin)
%   center is in screen pixels
%   objSize is in screen pixels
%   USage:  TNF_Gaussian([-1 ;-1], 200, 0)      uses center of screen
%           TNF_Gaussian([14;16], 200, 0)     uses a specific checker center's
%
% config has 4 bits to change behaviour as follows:
%   bit 0,     include TNF center with background
%   bit 1,     include Gauss center with background
%   bit 2,     include TNF center no background
%   bit 3,     include Gauss center no background
%
%   For example to get Gaussian center with and without backgroun set
%   config = 10
global screen
    
try
    % process Input variables
    p = ParseInput(varargin{:});
    waitframes = p.Results.waitframes;
    objSeed = p.Results.objSeed;
    shape = p.Results.shape;
    presentationLength = p.Results.presentationLength;
    checkersSize = p.Results.checkersSize;
    backContrast = p.Results.backContrast;
    backReverseFreq = p.Results.backReverseFreq;
    stimSize = p.Results.stimSize;
    trialsN = p.Results.trialsN;
    objContrast = p.Results.objContrast;
    config = p.Results.config;
        
    objRects = Checkers2Rects(checkers, sizes);
    % start the stimulus
%    InitScreen(0)
    Add2StimLogList();

    % get the background texture
    stimSize = 2*checkersSize*floor(stimSize/checkersSize/2);
    checkersN = floor(stimSize/checkersSize);
    backTex = GetCheckersTex(checkersN+1, 1, backContrast);
    
    % I want framesN to have an even number of background reversals
    % 
    backFrames = fix(screen.rate/waitframes/backReverseFreq/2);
    framesN = fix(presentationLength*screen.rate/waitframes);
    framesN = backFrames*fix(framesN/backFrames);
    
    % Init the random stream
    gaussianStream = RandStream('mcg16807', 'Seed',objSeed);
    for trial = 0:trialsN-1
        
        phase = mod(trial,2);

        % config: 0bxxxx
        %   0bxxx1,     include TNF center with background
        %   0bxx1x,     include Gauss center with background
        %   0bx1xx,     include TNF center no background
        %   0b1xxx,     include Gauss center no background
        for i=0:3
            state = mod(bitshift(config, -i),2);
            if (state)  % if bit was set do the following, otherwise just continue
                switch i
                    case 0
                        reverseFreq = backReverseFreq;
                        objSeq = GetPinkNoise(trial*framesN+1, framesN, objContrast, screen.gray, 0);
                    case 1
                        reverseFreq = backReverseFreq;
                        objSeq = (randn(gaussianStream,1, framesN)*objContrast*screen.gray+screen.gray)';
                    case 2
                        reverseFreq = 0;
                        objSeq = GetPinkNoise(trial*framesN+1, framesN, objContrast, screen.gray, 0);
                    case 3
                        reverseFreq = 0;
                        objSeq = (randn(gaussianStream,1, framesN)*objContrast*screen.gray+screen.gray)';
                end                
            
                TemporalNaturalFlicker2(objSeq, reverseFreq, waitframes, ...
                    backTex, checkersN, phase, stimSize, 0, maskMode, ...
                    shape,objRects);
                if (KbCheck)
                    break
                end
            end
        end
        if (KbCheck)
            break
        end
    end
        

    % After drawing, we have to discard the noise checkTexture.
    Screen('Close', backTex{1});

    FinishExperiment();
    
catch exception
    %this "catch" section executes in case of an error in the "try" section
    %above. Importantly, it closes the onscreen window if its open.
    CleanAfterError();
    rethrow(exception)
end %try..catch..
end

function  TemporalNaturalFlicker2(objSeq, backReverseFreq, ...
    waitframes, backTex, checkersN, backPhase, stimSize, ...
    maskSize, maskMode, objShape, objRects)
    % Identical to TemporalNaturalFlicker but incorporates 
    % grayMaskSize
    
    global screen
    
try
    InitScreen(0);
    Add2StimLogList();
           
    % Define the background Destination Rectangle
    rectsCenter = mean(objRects,2)';
    backSource1 = SetRect(0, 0, checkersN, checkersN);
    backSource2 = SetRect(1, 0, checkersN+1, checkersN);
    backDest = SetRect(0,0,stimSize, stimSize);
    backDest = CenterRect(backDest, rectsCenter);
    
    grayMaskRect = SetRect(0, 0, maskSize, maskSize)'*ones(1, length(rectsCenter));
%    grayMaskTemplate = SetRect(0, 0, maskSize, maskSize)'*ones(1, length(rectsCenter));
    for i=1:size(objRects,2)
        if maskMode==1
            % each maskRect gets centered around its corresponding object
            grayMaskRect(:, i) = CenterRect(grayMaskRect(:,1)', objRects(:,i)')';
%            grayMaskRect(:, i) = CenterRect(grayMaskTemplate(:,1)', objRects(:,i)')';
        else
            % each maskRect gets centered around the rectsCenter, there is
            % effectively just one mask but I'm doing this to avoid
            % recoding
            grayMaskRect(:, i) = CenterRect(grayMaskRect(:,1)', rectsCenter)';
%            grayMaskRect(:, i) = CenterRect(grayMaskTemplate(:,1)', rectsCenter)';
        end
    end
    if backPhase==1
        tempDest = backSource2;
        backSource2 = backSource1;
        backSource1 = tempDest;
        clear tempDest
    end
    
    % Define the PD box
    pd = DefinePD();
    almostBlack = 30;
    
    updateRate = screen.rate/waitframes;
    updateTime = 1/updateRate-1/screen.rate/2;
    backFrames = fix(updateRate/backReverseFreq/2);
    framesN = length(objSeq);
        
    for frame=0:framesN-1
        if (mod(frame, 2*backFrames)==0 || backFrames==inf)
            % reverse background
            backSource = backSource1;
        elseif (mod(frame, backFrames)==0)
            backSource = backSource2;
        end
        
        % Object Drawing
        % --------------
        color = objSeq(frame+1);

        Screen('FillRect', screen.w, screen.gray, screen.rect);
        
        Screen('DrawTexture', screen.w, backTex{1}, backSource, backDest, 0,0)
        
                
        if (objShape)
            Screen('FillOval', screen.w, screen.gray, grayMaskRect);
            Screen('FillOval', screen.w, color, objRects);
        else
            Screen('FillRect', screen.w, screen.gray, grayMaskRect);
            Screen('FillRect', screen.w, color, objRects);
        end
        
        % Photodiode box
        % --------------
        if (frame==0 || mod(frame, backFrames)==0)
            Screen('FillOval', screen.w, screen.white, pd);
        else
            Screen('FillOval', screen.w, color/2+almostBlack, pd);
        end
        
        % Flip 'waitframes' monitor refresh intervals after last redraw.
        screen.vbl = Screen('Flip', screen.w, screen.vbl + updateTime , 1);
        
        if (KbCheck)
            break
        end
        
    end
            
    FinishExperiment();
    
catch exception
    %this "catch" section executes in case of an error in the "try" section
    %above. Importantly, it closes the onscreen window if its open.
    CleanAfterError();
    rethrow(exception)
end %try..catch..
end

function p = ParseInput(varargin)
    p  = inputParser;   % Create an instance of the inputParser class.

    [~, screenY] = Screen('WindowSize', max(Screen('Screens')));
    rate = Screen('NominalFrameRate', max(Screen('Screens')));
    if (rate==0)
        rate=100;
    end
    
    % Object related
    p.addParamValue('objSeed', 1, @(x) isnumeric(x) && size(x,1)==1 );
    p.addParamValue('objContrast', .1, @(x) x>=0 && x<=1);
    p.addParamValue('shape', 0, @(x) isnumeric(x));

    % Background related
    p.addParamValue('backContrast', 1, @(x)x>=0 && x<=1);
    p.addParamValue('backReverseFreq', 1, @(x) x>=0);
    p.addParamValue('backTexture', [], @(x) iscell(x));
    p.addParamValue('config', 15, @(x) x>0 && x<16);
    % General
    p.addParamValue('stimSize', screenY, @(x)x>0);
    p.addParamValue('presentationLength', 200, @(x)x>0);
    p.addParamValue('trialsN', 5);
    p.addParamValue('checkersSize', PIXELS_PER_100_MICRONS/2, @(x)x>0);
    p.addParamValue('waitframes', round(rate/30), @(x)isnumeric(x));         
    p.addParamValue('repeatCenter', 1, @(x) isnumeric(x));         

    % Call the parse method of the object to read and validate each argument in the schema:
    p.parse(varargin{:});
    
end

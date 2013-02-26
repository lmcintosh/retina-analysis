function RF(varargin)
    % if you want to change a parameter from its default value you have to
    % type 'paramToChange', newValue, ...
    % List of possible params is:
    % objContrast, objJitterPeriod, objSeed, stimSize, objSizeH, objSizeV,
    % objCenterXY, backContrast, backJitterPeriod, presentationLength,
    % movieDurationSecs, pdStim, debugging, barsWidth, waitframes, vbl
    global screen objRect pd

    p=ParseInput(varargin{:});

    objContrast = p.Results.objContrast;
    seed  = p.Results.seed;
    movieDurationSecs = p.Results.movieDurationSecs;
    stimSize = p.Results.stimSize;
    checkerSize = p.Results.checkerSize;
    waitframes = p.Results.waitframes;
    objCenterXY = p.Results.objCenterXY;
    pdStim = p.Results.pdStim;

try
    InitScreen(0);
    Add2StimLogList();

    checkersN_H = ceil(stimSize/checkerSize);
    checkersN_V = checkersN_H;
    
    % Define the obj Destination Rectangle
    objRect = SetRect(0,0, checkersN_H, checkersN_V)*checkerSize;
    objRect = CenterRect(objRect, screen.rect);
    objRect = OffsetRect(objRect, objCenterXY(1), objCenterXY(2));

    % Define the PD box
    if exist('pd', 'var')==0 || isempty(pd)
        pd = DefinePD();
    end
   

    % We run at most 'framesN' if user doesn't abort via
    % keypress.
    framesN = uint32(movieDurationSecs*screen.rate);

    % init random seed generator
    randomStream = RandStream('mcg16807', 'Seed', seed);

    % Define some needed variables
    
    Screen('FillRect', screen.w, screen.gray);

    % Animationloop:
    BinaryCheckers(framesN, waitframes, checkersN_V, checkersN_H, objContrast, randomStream, pdStim);

    FinishExperiment();
    
catch exception
    %this "catch" section executes in case of an error in the "try" section
    %above. Importantly, it closes the onscreen window if its open.
    CleanAfterError();
    rethrow(exception);
end %try..catch..
end


function p =  ParseInput(varargin)
    % Generates a structure with all the parameters
    % Allowed parameters are:
    %
    % objContrast, objJitterPeriod, objSeed, stimSize, objSizeH, objSizeV,
    % objCenterXY, backContrast, backJitterPeriod, presentationLength,
    % movieDurationSecs, pdStim, debugging, barsWidth, waitframes, vbl

    % In order to get a parameter back just use
    %   p.Resulst.parameter
    % In order to display all the parameters use
    %   disp 'List of all arguments:'
    %   disp(p.Results)
    %
    % General format to add inputs is...
    % p.addRequired('script', @ischar);
    % p.addOptional('format', 'html', ...
    %     @(x)any(strcmpi(x,{'html','ppt','xml','latex'})));
    % p.addParamValue('outputDir', pwd, @ischar);
    % p.addParamValue('maxHeight', [], @(x)x>0 && mod(x,1)==0);

    p  = inputParser;   % Create an instance of the inputParser class.

    p.addParamValue('objContrast', 1, @(x) x>=0 && x<=1);
    p.addParamValue('seed', 1, @(x) isnumeric(x));
    p.addParamValue('movieDurationSecs', 1000, @(x)x>0);
    p.addParamValue('stimSize', 32*PIXELS_PER_100_MICRONS, @(x)x>0);
    p.addParamValue('debugging', 0, @(x)x>=0 && x <=1);
    p.addParamValue('checkerSize', PIXELS_PER_100_MICRONS, @(x) x>0);
    p.addParamValue('waitframes', round(.033*MonitorFrameRate), @(x)isnumeric(x)); 
    p.addParamValue('objCenterXY', [0 0], @(x) size(x) == [1 2]);
    p.addParamValue('pdStim', 0, @(x) isnumeric(x));
    
    % Call the parse method of the object to read and validate each argument in the schema:
    p.parse(varargin{:});
    
end


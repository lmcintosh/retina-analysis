function [checkerRects] = Checkers2Rects(checkers, sizes, varargin)
    % checkers is of the following form:
    %   [check0X check1X ...; check0Y check1Y ...]
    %
    % any coordinate < 0 means center of the screen
    % for example   [-1 -1]   is the screen center
    %               [-1 10]   is screen center in X and checker 10 in y
    Add2StimLogList()
    
    p=ParseInput(varargin{:});

    % parameters used when mapping the RF
    checkN = p.Results.checkN;
    checkSize = p.Results.checkSize;

    [screenX, screenY] = Screen('WindowSize', max(Screen('Screens')));
    center = [screenX screenY]/2;
    
    % is any coordinate defined to be the screen center?
    checkers(checkers<0) = checkN/2+.5;

    % make the output
    checkerRects = ones(4, size(checkers,2));
    
    % fill the output with the coordinates of each checker, still in
    % checker coordinates
    checkerRects(1:2, :) = checkers;
    checkerRects(3:4, :) = checkers;
    
    % change from checker notation to pixels. Screen center corresponds
    % to checker position: checkN/2+.5
    checkerRects = (checkerRects - checkN/2-.5)*checkSize;
    checkerRects = checkerRects + [center center]'*ones(1, size(checkers,2));

    checkerRects(1:2, :) = checkerRects(1:2, :) - ones(2,1)*sizes*PIXELS_PER_100_MICRONS/100/2;
    checkerRects(3:4, :) = checkerRects(3:4, :) + ones(2,1)*sizes*PIXELS_PER_100_MICRONS/100/2;
    
    % translate all checkers to be described from the left, top border of
    % checker 0, 0
    % left border of each checker 
    % shift the center from that of checker (0,0) to that of checer
    % (checkX, checkY)
%    newCenter = newCenter + checkers*checkSize;
end

function p =  ParseInput(varargin)
    p  = inputParser;   % Create an instance of the inputParser class.


    % Background related
    p.addParamValue('checkN', 32, @(x)x>0);
    p.addParamValue('checkSize', PIXELS_PER_100_MICRONS, @(x) x>0);

    % Call the parse method of the object to read and validate each argument in the schema:
    p.parse(varargin{:});
    
end

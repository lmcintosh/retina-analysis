function [pixelsX] = PIXELS_PER_100_MICRONS
    Add2StimLogList();
    
    [width height] = Screen('WindowSize', max(Screen('Screens')));
    switch width
        case 640
            pixelsX = 12;
        case 800
            pixelsX = 14;
        case 1024
            pixelsX = 18;
        case 1280
            pixelsX = 22;
        case 1680
            pixelsX = 30;
        otherwise
            error('Pixel size not defined for this reslution inside PIXELS_PER_100_MICRONS');
    end
    
end

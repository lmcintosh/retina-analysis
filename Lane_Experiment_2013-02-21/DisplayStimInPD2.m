function DisplayStimInPD2(stim, pd, frame, framesPerCode, screen)
    % stim will be coded in the pdBox as 4 bits in base 4 (4 colors other
    % than white)
    % At frame 1 pd box will always be white to signal clearly the stim
    % onset
    % At pd.frame1 bit 0 is shown
    % At pd.frame2 bit 1 is shown
    % At pd.frame3 bit 2 is shown
    % At pd.frame4 bit 3 is shown
    %
    % framesPerCode is needed to know when the new stim is starting
    %
    % Bit is   Intensity
    %   0           15
    %   1           95
    %   2           175
    %   3           255
    %   -           15      in between coding frames
    %   -           255     1st frame of code
    Add2StimLogList();
    
    temp=mod(frame, framesPerCode);
    if (temp==0)           % display white on 1st frame
        Screen('FillOval', screen.w, screen.white, pd);
    elseif (temp==1)    % display bit0
        % Change stim into the colors needed for the pd
        pdColors = stim2pdColors(stim);    % stim = pdColor(1)*4^0 + pdColor(2)*4^1 + pdColor(2)*4^2 + pdColor(3)*4^3
        Screen('FillOval', screen.w, pdColors(1), pd);
    elseif (temp==2)   % display bit1
        pdColors = stim2pdColors(stim);    % stim = pdColor(1)*4^0 + pdColor(2)*4^1 + pdColor(2)*4^2 + pdColor(3)*4^3
        Screen('FillOval', screen.w, pdColors(2), pd);
    elseif (temp==3)   % display bit2
        pdColors = stim2pdColors(stim);    % stim = pdColor(1)*4^0 + pdColor(2)*4^1 + pdColor(2)*4^2 + pdColor(3)*4^3
        Screen('FillOval', screen.w, pdColors(3), pd);
    elseif (temp==4)   % display bit3
        pdColors = stim2pdColors(stim);    % stim = pdColor(1)*4^0 + pdColor(2)*4^1 + pdColor(2)*4^2 + pdColor(3)*4^3
        Screen('FillOval', screen.w, pdColors(4), pd);
    else
        AlmostBlack = 15;       
        Screen('FillOval', screen.w, AlmostBlack, pd);
    end
end


function Wait2Start(varargin)
% Wait2Start displays text instructions on the screen and
% checks for keyboard input.  If you hit spacebar, it also
% waits for the recording computer to start recording
    global vbl screen
    Add2StimLogList();
    InitScreen(0);
 
    KbName('UnifyKeyNames');
    SPACEBAR = KbName('space');
    ESCAPE = KbName('escape');
            
    Screen('FillRect', screen.w, 128);
    Screen(screen.w,'TextSize', 24);
    
    text1 = 'Space Bar:        WaitForRec';
    text2 = 'Anything else:   Starts stimulus';
    
    
    Screen(screen.w, 'DrawText', text1 ,30,30, 0 );
    Screen(screen.w, 'DrawText', text2 ,30,60, 0 );
    if (nargin)
        text3 = varargin{1};
        Screen(screen.w, 'DrawText', text3 ,30,90, 0 );
    end
    vbl = Screen('Flip',screen.w);

    ListenChar(2)
    while (max(Screen('Screens'))==0)       % if only one monitor
        [keyIsDown, ~, keyCode, ~] = KbCheck;
        if (keyIsDown)
            pause(.2)
            if (keyCode(SPACEBAR))
                text1 = 'Waiting for Rec computer to start';
                Screen(screen.w, 'DrawText', text1 ,30,30, 0 );
                Screen('Flip',screen.w);

                WaitForRec();

                Screen('FillRect', screen.w, screen.gray);
                for i=1:30
                    Screen('FillOval', screen.w, screen.black, [890 55 1010 175]);
                    vbl = Screen('Flip', screen.w);
                end
            elseif (keyCode(ESCAPE))
                % not implemented
            else
                % do nothing, start immediatly
            end
            break;
        end
    end
    ListenChar(0)
end


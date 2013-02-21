function InitScreen(debugging)
    % Initializes the Screen.
    % The idea here is that you can call this function from within a given
    % stimulus where the 2nd parameter might or might no be defined. If it
    % is defined this function does nothing but if it is not defined then
    % this function initializes the screen.
    
    global screen
    
    Add2StimLogList();
    if (isfield(screen, 'w'))
        return
    end

    screen.rate = Screen('NominalFrameRate', max(Screen('Screens')));
    if screen.rate==0
        screen.rate=100;
    end
    if mod(screen.rate,2)
        answer = questdlg(['Screen Rate is a non (', num2str(screen.rate), ...
            'Hz). Do you want to continue or abort?'], 'Frame Rate', 'Abort', 'Continue', 'Abort');
        if strcmp(answer, 'Abort')
            error('Change the monitor rate');
        end
    end

    % write which function initialized the screen. So that we know when to
    % close it.
    s = dbstack('-completenames');
    screen.callingFunction = s(length(s)).file;

    AssertOpenGL;

    % Get the list of screens and choose the one with the highest screen number.
    screenNumber=max(Screen('Screens'));

    % Find the color values which correspond to white and black.
    screen.white=WhiteIndex(screenNumber);
    screen.black=BlackIndex(screenNumber);

    % Round gray to integral number, to avoid roundoff artifacts with some
    % graphics cards:
	screen.gray=floor((screen.white+screen.black)/2);

    % This makes sure that on floating point framebuffers we still get a
    % well defined gray. It isn't strictly neccessary in this demo:
    if screen.gray == screen.white
		screen.gray=screen.white / 2;
    end

    [screenX, screenY] = Screen('WindowSize', max(Screen('Screens')));
    screen.center=[screenX screenY]/2;
    
    % Open a double buffered fullscreen window with a gray background:
    if (screenNumber == 0)
        if (debugging)
            [screen.w screen.rect]=Screen('OpenWindow',screenNumber, screen.gray, [10 10 400 400]);
        else
            [screen.w screen.rect]=Screen('OpenWindow',screenNumber, screen.gray);
            HideCursor();
        end
        Priority(1);
   else
        [screen.w screen.rect]=Screen('OpenWindow',screenNumber, screen.gray);
    end
    
    % Query duration of monitor refresh interval:
    screen.ifi=Screen('GetFlipInterval', screen.w);

    [scree.width scree.height] = Screen('WindowSize', max(Screen('Screens')));
    screen.vbl = 0;
end


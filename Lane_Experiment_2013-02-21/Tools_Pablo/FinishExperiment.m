function FinishExperiment()
    % only execute this code if the calling function (the one above
    % this one in the stack) is the 1st function that initialized the
    % screen. 
    global screen
    Add2StimLogList();
    
    s = dbstack('-completenames');
    if (strcmp(screen.callingFunction, s(2).file))
        
        clear Screen
        if  max(Screen('Screens'))==0
            button = questdlg('Save log file?','','Yes');
            if (strcmp(button, 'Yes'));
%                s=dbstack;
%                CreateStimuliLog2();
                CreateStimuliLog();
            end
        end
        clear global
        Screen('CloseAll');         % Close all open onscreen and offscreen
        % windows and textures, movies and video
        % sources. Release nearly all ressources.
        Priority(0);
        ShowCursor();
    end
end




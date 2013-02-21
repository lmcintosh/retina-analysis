function CleanAfterError()
    Add2StimLogList();
    
    clear Screen
    clear global
    clear global expLog
    clear global screen
    clear global StimLogList
    Screen('CloseAll');         % Close all open onscreen and offscreen
                                % windows and textures, movies and video
                                % sources. Release nearly all ressources.
    Priority(0);
    ShowCursor();
end


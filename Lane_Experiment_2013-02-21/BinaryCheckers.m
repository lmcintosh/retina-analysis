function [exitFlag] = BinaryCheckers(framesN, waitframes, checkersV, checkersH, objContrast, randomStream, pdStim)
    global screen objRect pd

    Add2StimLogList();
    exitFlag = -1;
    frame = 0;
    
    
    for frame = 0:framesN-1

        if (mod(frame, waitframes)==0)
            % CENTER REGION
            % ------ ------

            % Make a new obj texture
            objColor = (rand(randomStream, checkersH, checkersV)>.5)*2*screen.gray*objContrast...
                + screen.gray*(1-objContrast);
            objTex  = Screen('MakeTexture', screen.w, objColor);
            
            % display last texture
            Screen('DrawTexture', screen.w, objTex, [], objRect, 0, 0);
        
            % We have to discard the noise checkTexture.
            Screen('Close', objTex);
        end
        

        % PD
        % --
        % Draw the PD box
        DisplayStimInPD2(pdStim, pd, frame, screen.rate, screen)
        
        % uncomment this line to check the coordinates of the 1st checker
        % Flip 'waitframes' monitor refresh intervals after last redraw.
        screen.vbl = Screen('Flip', screen.w, screen.vbl + 0.5 * screen.ifi, 1);
        if (KbCheck)
            break
        end
    end;
    
    if (frame >= framesN)
        exitFlag = 1;
    end
end




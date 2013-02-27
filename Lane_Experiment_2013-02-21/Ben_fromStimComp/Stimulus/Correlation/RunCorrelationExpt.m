function ex = RunCorrelationExpt(stimType, time, reps, trigger)
%
% FUNCTION ex = RunCorrelationExpt(stimType, time, reps, trigger) runs the
% stimuli for the Baccus lab correlation experiments.
%
% bnaecker@stanford.edu 14 Feb 2012

try
    %% Default arguments, make data structure
    defarg('stimType', 'all');
    defarg('time', 250);
    defarg('reps', 3);
    defarg('trigger', 'm');
    ex = makeExpStruct(stimType, time, reps);
    
    %% Setup keyboard
    ex = setupCorrExptKB(ex);
    
    %% Initialize display
    ex = initCorrExptDisp(ex);
    
    %% Set up experimental parameters
    ex = setupCorrExptParams(ex);
    
    %% Generate the centers of the textures (random or simulated saccades)
    ex = createImageCenters(ex);
    
    %% Create textures
    ex = makeCorrelationTextures(ex);
    
    %% Run triggering routine
    ex = waitForTriggers(ex, trigger);
    
    %% Run stimuli
    for si = 1:length(ex.pa.stimType)
        switch ex.pa.stimType{si}
            case 'white'
                ex = runCorrelationWhiteStimulus(ex, si);
            case 'pink'
                ex = runCorrelationPinkStimulus(ex, si);
            case 'natural'
                ex = runCorrelationNaturalStimulus(ex, si);
        end
    end
    
    %% Save
    ex = saveExptStruct(ex);
    
    %% Clean up
    sca;
    ListenChar(0);
    ShowCursor;
    Priority(0);
catch me
    ex.me = me;
    sca;
    ListenChar(0);
    ShowCursor;
    Priority(0);
end

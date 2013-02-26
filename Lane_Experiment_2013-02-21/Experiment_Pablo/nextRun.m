function nextRun()

try
    Add2StimLogList();
    Wait2Start()

%{
    RF('movieDurationSecs', 600);
    
% {    
    pause(.2)
    OMS_identifier_LD
    
    pause(.2)
    Sensitization
    
    pause(.2)
    objContrast = .1;
    trialsN=1;
    repeatCenterFlag=1;
    TemporalNaturalFlicker_SSx(objContrast, trialsN, ...
        repeatCenterFlag);
    
    GrayScreen(127, 60)

    center = GetEveryOtherChecker(10,21);
    objSize = ones(1,size(center,2))*100;

    pause(.2)
    noiseType = 0;
    selectedRF(center, objSize, noiseType, 'checkersSize', PIXELS_PER_100_MICRONS, ...
        'presentationLength', 600);

    pause(.2);
    TNF_Distance2(center, objSize, 0, 'objContrast', .4, 'presentationLength', 200, 'shape',0, 'checkersSize', PIXELS_PER_100_MICRONS)

    selectedRF(center, objSize, noiseType);
%}
% {
    pause(.2)
    TNF_Gaussian([-1;-1], 1200, 1)%, ...
    % you can alter default parameters by appending to the arguments something like, ...,'backContrast',.2)

    pause(.2)
    RF('movieDurationSecs', 600)
%{
        'objContrast', .2, ...
        'config', 7, ...
        'trialsN', 3)
%}
%{

    pause(.2)
    TNF_BackContrast([-1;-1], 1200, 1, ...
        'objContrast', .1)
%}        
    FinishExperiment();
    
catch exception
    %this "catch" section executes in case of an error in the "try" section
    %above. Importantly, it closes the onscreen window if its open.
    CleanAfterError();
    rethrow(exception)
end %try..catch..

end

function x = GetPinkNoise(startFrame, framesN, contrast, meanLuminance, plotFlag)
    % Generate a noise wave with 'pink like characterisitics'
    %
    %   Start by loading matlab's pink noise sequence and then adjust the
    %   scaling to have contrast and meanLuminance.
    
    Add2StimLogList();
    
    load pinknoise;
    x(1:startFrame)=[];
    x(framesN+1:end)=[];

    Xstd = std(x);
    x = x*contrast*meanLuminance/Xstd + meanLuminance;    
    
    if plotFlag
        AnalyseNoise(x)
    end
end

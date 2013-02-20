function [predictiveInfo] = LNPprediction(trials, time, numLNs, numRGCs, figures)
% INPUTS: trials, time, numLNs, numRGCs, figures?
% OUTPUTS: predictiveInfo

whiteORcorr = ones(trials,1); % record which trial is which
nonlinearOutput = cell(trials,numLNs); % store all bipolar outputs for each trial

resolution = 32;
point = .5*10e4;
slope = 2;
binLength = 1;
avg = 0; drift = 0;
variance = .1;


for trial = 1:trials
    for bipolar = 1:numLNs
        if rand(1) > .5
            stimulus = wiener(avg,drift,sqrt(variance),time,0);
            temp = var(stimulus);
        else
            stimulus = sqrt(temp)*randn(time,1) + avg;
        end

        [spikes,stim,nonlinearOutput{trial,bipolar}] = lnp(time,resolution,point,slope,binLength,stimulus,0);
    end
end



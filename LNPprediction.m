function [predictiveInfo,stimulus,whiteORcorr,spiketrains] = LNPprediction(trials, time, figures, filterLength, point, slope, variance)
% INPUTS: trials, time (ms), figures?, filterLength, point, slope, variance
% OUTPUTS: predictiveInfo
% predictiveInfo has dimensions time x 2, where 1st col is white and 2nd col is pink

whiteORcorr = ones(trials,1); % record which trial is which
nonlinearOutput = cell(trials,1); % store all bipolar outputs for each trial

if nargin < 4
    filterLength = 30;
    point = .5;
    slope = 2;
    variance = .1;
end

binLength = 1;
avg = 0; drift = 0;

% Initialize LNP variables
spiketrains = zeros(time/binLength,trials);
stimulus = zeros(time/binLength,trials);
whiteORcorr(1:floor(trials/2)) = 0; % here we're just splitting the trials in half between white noise and pink noise

% Initialize info variables
h = zeros(trials-1,3);
mi_white = zeros(time/binLength-binLength,1);
mi_pink = zeros(time/binLength-binLength,1);


for trial = 1:trials
    [spiketrains(:,trial),stimulus(:,trial),~] = lnp(time,filterLength,point,slope,variance,binLength,whiteORcorr(trial),0);
end

tmp = find(spiketrains>1);
spiketrains(tmp) = 1; % clip spike trains at 1

for t = 1:time/binLength - binLength
    [h_white(t,:), mi_white(t), ~] = Inxn(spiketrains(t,whiteORcorr==0),spiketrains(t+1,whiteORcorr==0),2,0,1);
    [h_pink(t,:), mi_pink(t), ~] =  Inxn(spiketrains(t,whiteORcorr==1),spiketrains(t+1,whiteORcorr==1),2,0,1);
end

times = linspace(0,time,time/binLength-binLength);

if figures ~= 0
    figure;
    subplot(1,2,1), plot(times,mi_white), title('Mutual Information - White Stim'),
    subplot(1,2,2), plot(times,mi_pink), title('Mutual Information - Pink Stim')

    figure;
    subplot(1,2,1), plot(times,h_white), title('Entropy - White Stim'),
    subplot(1,2,2), plot(times,h_pink), title('Entropy - Pink Stim')
end
%figure;
%plot(stimulus)



predictiveInfo = [col(mi_white), col(mi_pink)];



%{

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

if numLNs/numRGCs > 1
    for RGC = round(linspace(1,numLNs,numRGCs))
        nonlinearOutput{:,RGC:RGC+round(numLNs/numRGCs)
%}



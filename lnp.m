function [spikeTrain,stimulus,nonlinearOutput] = lnp(time,resolution,point,slope,binLength,stimulusType,plots)
% lnp is a linear-nonlinear-poisson cascade model used to model retinal ganglion neurons
% INPUTS: time (duration of output), resolution (length of linear filter),
% point (threshold), slope (slope of threshold), binLength, stimulusType (0,1,or vector), plots 
% OUTPUTS: spikeTrain, stimulus, nonlinearOutput

%time = 1000; % ms
%resolution = 32;
%point = .5*10e4;
%slope = 2;
%binLength = 1;

% create the linear filter
kernel = linearKernel(1,-0.5,1,resolution); % inputs: freq, phase, var, resolution

% create the stimulus
variance = .1;
mean = 0;
if stimulusType == 0
    stimulus = sqrt(variance)*randn(time,1) + mean;
elseif stimulusType == 1
    stimulus = wiener(mean,0,sqrt(variance),time,0); % random walk stimulus
    % starting pt, drift, standard deviation of samples at time t = 1, how long, figures?
end

% pass the stimulus through the linear filter
linearOutput = conv(stimulus,kernel,'same');

% pass the linear filter's output through the nonlinearity/threshold
nonlinearOutput = threshold(linearOutput,point,slope);
nonlinearOutput = col(nonlinearOutput);

% use poisson probability of spiking to generate a spike train
spikeTrain = poissrnd(binLength*nonlinearOutput);



if plots ~= 0
    figure; subplot(4,1,1), plot(stimulus),
    subplot(4,1,2), plot(linearOutput),
    subplot(4,1,3), plot(nonlinearOutput),
    subplot(4,1,4), plot(spikeTrain,'r.')
end

%rasters(spikeTrain)

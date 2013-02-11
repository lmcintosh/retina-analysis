function [spikeTrain,stimulus] = lnp(time,resolution,point,slope,binLength,stimulusType,plots)
% lnp is a linear-nonlinear-poisson cascade model used to model retinal ganglion neurons
% INPUTS: time (duration of output), resolution (length of linear filter),
% point (threshold), slope (slope of threshold), binLength, stimulusType, plots OUTPUTS: spikeTrain, stimulus

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
else
    stimulus = wiener(mean,variance,time,0); % random walk stimulus
    % starting pt, variance, how long, figures?
    stimulus = stimulus*0.2;
end

% pass the stimulus through the linear filter
linearOutput = conv(stimulus,kernel,'same');

% pass the linear filter's output through the nonlinearity/threshold
nonlinearOutput = threshold(linearOutput,point,slope);
nonlinearOutput = col(nonlinearOutput);

% use poisson probability of spiking to generate a spike train
spikeTrain = poissrnd(binLength*nonlinearOutput);




%{
% note that I'm assuming bins are small enough that we only worry about one
% spike per bin
uniformPDF = rand(length(nonlinearOutput),1);
% probOfSpike = diag(binLength*nonlinearOutput)*exp(-binLength*nonlinearOutput); % this
% is just the pdf for 1 spike, but I think we actually want the cdf

CDF = diag(binLength*nonlinearOutput);
probOfSpike = CDF*exp(-binLength*nonlinearOutput);
figure; plot(probOfSpike)
for i = 2:30;
    CDF = CDF + diag(binLength*nonlinearOutput.^i)/factorial(i);
    probOfSpike = CDF*exp(-binLength*nonlinearOutput);
    figure; plot(probOfSpike)
end

probOfSpike = zeros(length(nonlinearOutput),1);
for i = 1:length(nonlinearOutput)
    CDF = 0;
    for j = 1:50
        CDF = CDF + ((binLength*nonlinearOutput(i))^j)/factorial(j);
    end
    probOfSpike(i) = -binLength*nonlinearOutput(i) + log(CDF);
end

probOfSpike = exp(probOfSpike);
spikeTrain = (probOfSpike >= uniformPDF);
%}

if plots ~= 0
    figure; subplot(4,1,1), plot(stimulus),
    subplot(4,1,2), plot(linearOutput),
    subplot(4,1,3), plot(nonlinearOutput),
    subplot(4,1,4), plot(spikeTrain,'r.')
end

%rasters(spikeTrain)

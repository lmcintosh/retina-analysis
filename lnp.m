function [spikeTrain] = lnp(time,resolution,point,slope,binLength)
% lnp is a linear-nonlinear-poisson cascade model used to model retinal ganglion neurons
% INPUTS: time (duration of output), resolution (length of linear filter), point (threshold), slope (slope of threshold)

%time = 1000; % ms
%resolution = 32;
%point = .5*10e4;
%slope = 2;
%binLength = 1;

% create the linear filter
kernel = linearKernel(1,-0.5,1,resolution); % inputs: freq, phase, var, resolution

% create the stimulus
stimulus = wiener(0,1,time,0); % random walk stimulus

% pass the stimulus through the linear filter
linearOutput = conv(stimulus,kernel,'same');

% pass the linear filter's output through the nonlinearity/threshold
nonlinearOutput = threshold(linearOutput,point,slope);
nonlinearOutput = col(nonlinearOutput);

% use poisson probability of spiking to generate a spike train
% note that I'm assuming bins are small enough that we only worry about one
% spike per bin
uniformPDF = rand(length(nonlinearOutput),1);
% probOfSpike = diag(binLength*nonlinearOutput)*exp(-binLength*nonlinearOutput); % this
% is just the pdf for 1 spike, but I think we actually want the cdf

%{
CDF = diag(binLength*nonlinearOutput);
probOfSpike = CDF*exp(-binLength*nonlinearOutput);
figure; plot(probOfSpike)
for i = 2:30;
    CDF = CDF + diag(binLength*nonlinearOutput.^i)/factorial(i);
    probOfSpike = CDF*exp(-binLength*nonlinearOutput);
    figure; plot(probOfSpike)
end
%}

probOfSpike = zeros(length(nonlinearOutput),1);
for i = 1:length(nonlinearOutput)
    CDF = 0;
    for j = 1:5
        CDF = CDF + ((binLength*nonlinearOutput(i))^j)/factorial(j);
    end
    probOfSpike(i) = -binLength*nonlinearOutput(i)*log(CDF);
end

probOfSpike = exp(probOfSpike);


spikeTrain = (probOfSpike >= uniformPDF);

figure; subplot(4,1,1), plot(stimulus),
subplot(4,1,2), plot(linearOutput),
subplot(4,1,3), plot(nonlinearOutput),
subplot(4,1,4), plot(probOfSpike)

rasters(spikeTrain)

%figure; plot(spikeTrain,'.')
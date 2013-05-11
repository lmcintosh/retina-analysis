function [times, rates] = makeFiringRates(spikes,binLength)
% INPUT: spikes is a 1 x numNeurons cell array where each cell has vector
% of spike times
% INPUT: binLength specifies the firing rate bin size in miliseconds
% OUTPUT: times is a column vector of time in seconds corresponding to each
% column element of rates
% OUTPUT: rates is a time x numNeurons double array with firing rates

binLength = binLength/1000;
allSpikes = cell2mat(spikes);
timeDuration = max(max(allSpikes)); % in seconds
numBins = timeDuration/binLength;
numCells = length(spikes);

binEdges = linspace(0,timeDuration,numBins+1);
rates = zeros(length(binEdges)-1,numCells);

for i = 1:numCells
    for j = 1:length(binEdges)-1
        spikesInBin = spikes{i}(binEdges(j) <= spikes{i} < binEdges(j+1));
        rates(j,i) = length(spikesInBin)/binLength; % converts spike count to Hz
    end
end
        
times = binEdges(1:length(binEdges)-1);

figure;
plot(times,rates(:,1))
xlabel('Time (seconds)')
ylabel('Firing Rate (Hz)')
title('Firing Rate of a single RGC')
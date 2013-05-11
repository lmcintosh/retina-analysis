function [] = rastersFromCells(spikes)
% INPUTS: spikes
% OUTPUTS: none

numCells = length(spikes);
allSpikes = cell2mat(spikes);
figure;
for i = 0:numCells-1
    t = spikes{i+1};
    plot([t;t],[ones(size(t))+i;zeros(size(t))+i],'k-')
    hold on
end
axis([0 max(max(allSpikes))+1 0 numCells])
ylabel('Neuron #')
title('Raster Plot of RGCs over Whole Experiment')


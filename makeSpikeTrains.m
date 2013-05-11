% pieceTogether.m
% take text file and separate out the neurons


load all.txt
al = all(isfinite(all));

neuron = 1;
last = 0;
spiketrains = cell(1);

for i = 1:length(al)-1;
    if al(i+1)<al(i);
        spiketrains{neuron} = al(last+1:i);
        last = i;
        neuron = neuron + 1;
    elseif i == length(al)-1;
        spiketrains{neuron} = al(last+1:i+1);
    end
end



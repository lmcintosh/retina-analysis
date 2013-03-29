% PredInfo_distributions.m
% Look at the distribution of mutual information over various delta t's

%[spikeTrain,stimulus,nonlinearOutput] = lnp(100,30,1,1,1,.5,0,1);
time = 100;
[predictiveInfo,stimulus,whiteORcorr,spiketrains] = LNPprediction(1000, time, 0, 30, 1, 1, 1);

% white
infos_w = zeros(time,1);
for j = 1:time
    infos_w(j) = mutualinfo(spiketrains(50,whiteORcorr==0),stimulus(j,whiteORcorr==0));
end

% pink
infos_p = zeros(time,1);
for j = 1:time
    infos_p(j) = mutualinfo(spiketrains(50,whiteORcorr==1),stimulus(j,whiteORcorr==1));
end

figure; plot(-49:50,infos_w)
title('Mutual information between a fixed spike train and white stim with different delta t')
xlabel('Delta t of stimulus')
ylabel('Bits')

figure; plot(-49:50,infos_p)
title('Mutual information between a fixed spike train and pink stim with different delta t')
xlabel('Delta t of stimulus')
ylabel('Bits')

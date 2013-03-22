% piecetogetherStillpredictions.m

load LNPpredictions_still.mat;
% important things are predictiveInfo_p and predictiveInfo_w
% size(predictiveInfo_*) = 4x8x10x8
% slopes x points x filterLength x variances (contrast)
% defaults: 1 (2), 1 (4), 30 (5), 1 (4)

% want three figures:   points x filterLength
%                       variances x filterLength
%                       points x slopes
% (y axis by x axis)

sizeSlps = size(predictiveInfo_p,1);
sizePts = size(predictiveInfo_p,2);
sizeFlt = size(predictiveInfo_p,3);
sizeVar = size(predictiveInfo_p,4);

% points x filterLength
fig1_p = zeros(sizePts,sizeFlt);
fig1_w = fig1_p;
for i = 1:sizeFlt
    for j = 1:sizePts
        fig1_p(j,i) = predictiveInfo_p(2,j,i,4);
        fig1_w(j,i) = predictiveInfo_w(2,j,i,4);
    end
end

fig2_p = zeros(sizeVar,sizeFlt);
fig2_w = fig2_p;
for i = 1:sizeFlt
    for j = 1:sizeVar
        fig2_p(j,i) = predictiveInfo_p(2,4,i,j);
        fig2_w(j,i) = predictiveInfo_w(2,4,i,j);
    end
end

fig3_p = zeros(sizePts,sizeSlps);
fig3_w = fig3_p;
for i = 1:sizeSlps
    for j = 1:sizePts
        fig3_p(j,i) = predictiveInfo_p(i,j,5,4);
        fig3_w(j,i) = predictiveInfo_w(i,j,5,4);
    end
end


figure;
imagesc(fig1_p)
colorbar
title('Predictive information as function of filter and threshold position, pink noise')
xlabel('Filter integration time')
ylabel('Threshold position')


figure;
imagesc(fig1_w)
colorbar
title('Predictive information as function of filter and threshold position, white noise')
xlabel('Filter integration time')
ylabel('Threshold position')


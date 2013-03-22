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
fig1_p = zeros(sizeFlt,sizePts);
fig1_w = temp_p;
for i = 1:sizeFlt
    for j = 1:sizePts
        fig1_p(i,j) = predictiveInfo_p(2,j,i,4);
        fig1_w(i,j) = predictiveInfo_w(2,j,i,4);
    end
end

fig2_p = zeros(sizeFlt,sizeVar);
fig2_w = temp_p;
for i = 1:sizeFlt
    for j = 1:sizeVar
        fig2_p(i,j) = predictiveInfo_p(2,4,i,j);
        fig2_w(i,j) = predictiveInfo_w(2,4,i,j);
    end
end

fig3_p = zeros(sizeSlps,sizePts);
fig3_w = temp_p;
for i = 1:sizeSlps
    for j = 1:sizePts
        fig3_p(i,j) = predictiveInfo_p(i,j,5,4);
        fig3_w(i,j) = predictiveInfo_w(i,j,5,4);
    end
end




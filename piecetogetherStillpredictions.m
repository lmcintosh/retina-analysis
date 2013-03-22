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
temp_p = zeros(sizeFlt,sizePts);
temp_w = temp_p;
for i = 1:sizeFlt
    for j = 1:sizePts
        temp_p(i,j) = predictiveInfo_p(2,j,i,4);
        temp_w(i,j) = predictiveInfo_w(2,j,i,4);
    end
end

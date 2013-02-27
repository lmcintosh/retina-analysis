function [h, Mut_Info] = mutiState2(a,b,c,numbinsA,numbinsB,numbinsC)
% calculates I([a' b'];c')
% need a, b, c to be row vectors

%% Probabilities
pAB = zeros(numbinsA,numbinsB);
pABC = zeros(numbinsA,numbinsB,numbinsC);

binedgesA = linspace(min(a),max(a),numbinsA+1);
binedgesB = linspace(min(b),max(b),numbinsB+1);
binedgesC = linspace(min(c),max(c),numbinsC+1);

[hA,whichBinA] = histc(a,binedgesA);
[hB,whichBinB] = histc(b,binedgesB);
[hC,whichBinC] = histc(c,binedgesC);

pA = hA/sum(hA);
pB = hB/sum(hB);
pC = hC/sum(hC);

% inputs to histcn are X and edges, where X is MxN; i.e., M data points in R^N
[hAB edgesAB midAB locAB] = histcn([a' b'], binedgesA, binedgesB);
[hABC edgesABC midABC locABC] = histcn([a' b' c'], binedgesA, binedgesB, binedgesC);

pAB = hAB/sum(sum(hAB));
pABC = hABC/sum(sum(sum(hABC)));

%% Entropies
HAB = 0;
HC = 0;
HABC = 0;

for i = 1:length(pC)
    if pC(i) ~= 0
        HC = HC - pC(i)*log2(pC(i));
    end
end

for i = 1:size(pAB,1)
    for j = 1:size(pAB,2)
        if pAB(i,j) ~= 0
            HAB = HAB - pAB(i,j)*log2(pAB(i,j));
            for k = 1:size(pABC,3)
                if pABC(i,j,k) ~= 0
                    HABC = HABC - pABC(i,j,k)*log2(pABC(i,j,k));
                end
            end
        end
    end
end

%% Mutual Information
h = [HAB HC HABC];
Mut_Info = HAB + HC - HABC;



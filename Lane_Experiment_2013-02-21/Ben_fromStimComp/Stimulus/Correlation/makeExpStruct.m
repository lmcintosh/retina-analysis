function ex = makeExpStruct(stimType, time, reps)
%
% function ex = makeExpStruct(stimType, time, reps) makes the experimental
% structure for use in the correlation experiments
%
% (c) bnaecker@stanford.edu 23 Jan 2012

%% Make structure
ex = struct;
if strcmp(stimType, 'all')
    types = {'white', 'pink', 'natural'};
else
    types = {stimType};
end
ex.pa.stimType = cell(length(types) * reps, 1);
for r = 1:reps
    ex.pa.stimType( (r - 1) * length(types) + 1: r * length(types)) = ...
        types(randperm(length(types)));
end
ex.pa.time = time;
ex.pa.nReps = reps;
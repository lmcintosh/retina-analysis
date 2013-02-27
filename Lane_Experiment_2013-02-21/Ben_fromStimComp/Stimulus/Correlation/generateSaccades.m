function ctr = generateSaccades(ex, r, fi)
%
% FUNCTION ex = generateSaccade(ex)
%
% generates a simulated saccade
%
% (c) bnaecker@stanford.edu 14 Feb 2012

in = false;
while ~in
    dist = min(-ex.pa.saccExpMu * log(rand(ex.pa.random(r).stream, 1)), ex.pa.saccMax);
    dir = 360 * randn(ex.pa.random(r).stream, 1);
    endPt = ex.pa.stimCtr{r}(fi - 1, :) + dist .* [cosd(dir) sind(dir)];
    if IsInRect(endPt(1), endPt(2), ...
            [ex.pa.stimSize / 2 , ex.pa.stimSize / 2, ...
            ex.pa.naturalImgSize(2) - (ex.pa.stimSize / 2), ...
            ex.pa.naturalImgSize(1) - (ex.pa.stimSize / 2)]);
        ctr = endPt;
        in = true;
    else
        in = false;
    end
end
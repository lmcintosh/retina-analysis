function Tex = GetCheckersTex(stimSize, barsWidth, Contrast)
% Usage: Tex = GetCheckersTex(stimSize, barsWidth, screen, Contrast)
    global screen
    Add2StimLogList();
    
    InitScreen(0);
    if size(stimSize,2)==1
        [x, y]  = meshgrid(0:stimSize-1);
    else
        [x, y] = meshgrid(0:stimSize(1)-1, 0:stimSize(2)-1);
    end
    x = mod(floor(x/barsWidth),2);
    y = mod(floor(y/barsWidth),2);
    bars = x.*y + ~x.*~y;
    bars = bars*2*screen.gray*Contrast...
        + screen.gray*(1-Contrast);
    Tex{1} = Screen('MakeTexture', screen.w, bars);
end


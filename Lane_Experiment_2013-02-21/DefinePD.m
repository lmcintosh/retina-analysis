function pd = DefinePD()
    global screen
    Add2StimLogList();
    
    pd = SetRect(0,0, 10*PIXELS_PER_100_MICRONS, 10*PIXELS_PER_100_MICRONS);
    pd = CenterRectOnPoint(pd, screen.rect(3)*.94, screen.rect(4)*.16);
end

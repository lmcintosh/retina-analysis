function Add2StimLogList()
    global StimLogList
    
    s = dbstack('-completenames');
    if isempty(StimLogList)
        % There are two functions that have to be always added to
        % StimLogList manually.
        %   One of them is Add2StimLogList itself
        %   The other one is 'CleanAfterError' that hopefully did not run
        %   during the experiment and therefor will not be included.
        %   This points to a fundamental error in the design. Only those
        %   functions that run during execution will be added. If the code
        %   is written so that there is randomness to what is run or a
        %   close loop with the recording the 2nd time is run it might look
        %   for functions that are not recorded.
        StimLogList{1} = which('Add2StimLogList');
        StimLogList{2} = which('CleanAfterError');
    end
    
    for i=1:length(StimLogList)
        if strcmp(StimLogList{i}, s(2).file)
            return
        end
    end
    
    StimLogList{end+1}=s(2).file;
end
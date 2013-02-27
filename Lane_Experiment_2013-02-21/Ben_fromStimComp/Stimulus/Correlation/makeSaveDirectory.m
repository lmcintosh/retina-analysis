function ex = makeSaveDirectory(ex)
%
% FUNCTION ex = makeSaveDirectory(ex)
%
% Create a directory to save the data. Checks if there are any others and
% generates a directory appended 'a', 'b', 'c', etc. if necessary
%
% (c) bnaecker@stanford.edu 15 Feb 2012

%% On which computer are we running?
dateFolder = datestr(now, 'ddmmyy');
switch ex.pa.hostName
    case 'D213-stimulus'
        ex.pa.naturalImgDir = ['C:\Documents and Settings\Mike Menz\' ...
            'Desktop\Stimuli\Ben\imgs\'];
        ex.pa.saveDir = fullfile(['C:\Documents and Settings\Mike Menz\' ...
            'Desktop\Stimuli\Ben\Data\Correlation']);
    case {'DNab41119f.Stanford.EDU', 'hr-ozuysal-1201722562.stanford.edu'}
        ex.pa.naturalImgDir = ['/Users/baccuslab/Desktop/Stimuli/' ...
            'Ben/Images'];
        ex.pa.saveDir = fullfile(['/Users/baccuslab/Desktop/Stimuli/' ...
            'Ben/Data/Correlation/']);
    otherwise
        ex.pa.naturalImgDir = ['/Users/bnaecker/FileCabinet/Stanford/'...
            'BaccusLab/Images/Tkacik/Scaled'];
        ex.pa.saveDir = fullfile(['/Users/bnaecker/FileCabinet/Stanford/' ...
            'BaccusLab/Projections/Correlation/TestData/']);
end

%% Check if there are any others
dirContents = dir(ex.pa.saveDir);
possibleMatches = strncmp(dateFolder, {dirContents.name}, 6);
alphabet = char(97:122);
previousFiles = sum(possibleMatches);
if previousFiles > 0
    ex.pa.saveDir = fullfile(ex.pa.saveDir, [dateFolder alphabet(previousFiles)]);
else
    ex.pa.saveDir = fullfile(ex.pa.saveDir, dateFolder);
end

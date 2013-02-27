function s = pplot(varargin)
%
% function s = pplot(varargin)
%
% Makes figures look nice. If varargin is empty, it acts on all figures and
% their children, figuring out the type and changing the appropriate
% settings. If varargin is not empty, the first entry must be an array of
% handles, on which the function acts. Any other settings must be in
% param-value pairs, but you can thereby set any of the normal settings you
% might by directly setting them through the function.
%
% (c) bnaecker@stanford.edu 21 Sep 2012

%% check for empty input
if isempty(varargin)
    % assume all open figures and their children are to be beautified
end

%% check for single input
if length(varargin) == 1
    assert(all(ishandle(varargin{1})), ...
        'pplot:badHandles', ...
        ['If only one input argument is given, it must be an array of ' ...
        'handles on which pplot will act']);
end

%% check for param-value pairs
if length(varargin) > 1
    % check that the first argument is a handle list
    if all(ishandle(varargin{1}))
        handleList = varargin{1};
        argList = varargin(2:end);
    else
        argList = varargin;
    end
    
    % check that number of remaining arguments is even
    assert(mod(length(argList), 2) == 0, ...
        'pplot:paramValuePairs', ...
        ['If more than one input argument is given, they must be in ' ...
        'param-value pairs']);
end

%%%%% DEFAULT PARAMETERS %%%%%

% setup a struct with all the arguments
s = struct();

% font name
if any(strcmpi('fontname', argList))
    s.fontName = argList{find(strcmpi('fontname', argList)) + 1};
else
    s.fontName = 'Helvetica';
end

% axes font size
if any(strcmpi('axesfontsize', argList))
    s.axesFontSize = argList{find(strcmpi('axesfontsize', argList)) + 1};
else
    s.axesFontSize = 14;
end

% title font size
if any(strcmpi('titlefontsize', argList))
    s.titleFontSize = argList{find(strcmpi('titlefontsize', argList)) + 1};
else
    s.titleFontSize = 16;
end

% line width
if any(strcmpi('linewidth', argList))
    s.lineWidth = argList{find(strcmpi('linewidth', argList)) + 1};
else
    s.lineWidth = 2;
end

% axes line width
if any(strcmpi('axeslinewidth', argList))
    s.axesLineWidth = argList{find(strcmpi('axeslinewidth', argList)) + 1};
else
    s.axesLineWidth = 2;
end

% font weight
if any(strcmpi('fontweight', argList))
    s.fontWeight = argList{find(strcmpi('fontweight', argList)) + 1};
else
    s.fontWeight = 'bold';
end

% tick dir
if any(strcmpi('tickdir', argList))
    s.tickDir = argList{find(strcmpi('tickdir', argList)) + 1};
else
    s.tickDir = 'out';
end

% figure color
if any(strcmpi('figcolor', argList))
    
else
    s.figColor = 'w';
end

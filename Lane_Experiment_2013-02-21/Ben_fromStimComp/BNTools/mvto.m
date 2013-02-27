function varargout = mvto(target, varargin)
%
% function varargout = mvto(target, varargin)
%
% moves to the specified location. if 'target' is a directory, the function
% moves there directly. if 'target' is a function on the MATLAB search path, 
% mvTo moves you to the folder in which that function exists.
%
% if the folder of function is not on the search path, a unix search is
% performed to find it. if it's a regular directory, you are moved there.
% if it's a MATLAB function or .mat file, then you are moved to the folder 
% containing that function. you can call extra options to save the found path.
%
% varargin contains extra arguments, in param-value pairs, which are only
% used if the requested location is neither a folder nor a function on the
% search path. 
%
% Optional inputs:
% 
% 'startpath' -- root of the filesystem search. will search recursively from here
%
% 'out' -- where to print output of UNIX find command, defaults to stdout
%
% 'err' -- where to print errors of UNIX find command, defaults to /dev/null
%
% 'updatepath' -- update the path with the found folder. this does a recursive
% 		update, and then saves the path. you probably don't want this, so it
%		defaults to false
%
% 'echo' -- whether or not to print out the results of the system command.
% 		defaults to false.
%
% (c) bnaecker@stanford.edu 21 Sep 2012

%% check if it's a directory
if exist(target, 'dir') == 7
    try
        cd(target);
        return;
    catch me
        %  could not cd, rethrow the error
        varargout{1} = me;
        return;
    end
end

%% check if it's a function
s = which(target);

% is it on the path?
if ~isempty(s)
	% move to the folder containing the fuction
    [pt, fname, ext] = fileparts(s);
	cd(pt);
	
	% return with args if requested
	if nargout 
		varargout{1} = 1;
	end
	return;
end

%%%%% at this point, 'target' is neither a directory nor a file on the path,
%%%%% so we have to do a UNIX system search

%% parse varargin
% check for even arguments
assert(mod(length(varargin), 2) == 0, ...
    'mvTo:badParamValuePairs', ...
    ['If specifying extra arguments to search for a function via ' ...
    'UNIX "find" command, they must be in param-value pairs']);
    
% start path
if any(strcmpi('startpath', varargin))
    startPath = varargin{find(strcmpi('startpath', varargin)) + 1};
else
    startPath = '/Users/bnaecker/FileCabinet/';
end

% std output
if any(strcmpi('out', varargin))
    out = varargin{find(strcmpi('out', varargin)) + 1};
else
    out = '/dev/stdout';
end

% err output
if any(strcmpi('out', varargin))
    out = varargin{find(strcmpi('out', varargin)) + 1};
else
    out = '/dev/null';
end

% save the new folder to the path
if any(strcmpi('updatepath', varargin))
    updatePath = varargin{find(strcmpi('updatepath', varargin)) + 1};
else
    updatePath = false;
end

% echo the UNIX terminal output
if any(strcmpi('echo', varargin))
    echo = varargin{find(strcmpi('echo', varargin)) + 1};
else
    echo = false;
end

%% format the name a bit
% remove fileseps
fileseps = strfind(target, '/');
if any(fileseps)
    target = target(fileseps(end) + 1 : end);
end

%% make the unix search string
cmd = ['find ' startPath ' -name ' target '* > ' out ' 2> ' out];

%% Notify
fprintf(['Could not find the requested file or folder on the MATLAB path.\n' ...
    '\nSearching filesystem starting at %s \n'], startPath);
resp = input('\nContinue? (y/n): ', 's');
if strncmp(resp, 'y', 1)
    % run the command
    fprintf('\n');
    if echo
        [status, result] = unix(cmd, '-echo');
    else
        [status, result] = unix(cmd);
    end
else
    fprintf('\nExiting.\n');
    return;
end

%% check for an error
if status
    fprintf(['UNIX command failed. Exit code ' num2str(status) '.\n']);
    varargout = {status, result};
    return
elseif isempty(result)
    fprintf('UNIX command failed. File does not exist.\n');
    return;
end

%% no error, try to move to the new folder
% deal with multiple returns by taking the one before the first delim
newResult = strtok(result);
% notify if different
if any(size(newResult) ~= size(result))
    fprintf(['\nPossibly more than one match. Moving to first, but consider ' ...
        'refining your search.\n']);
end

try
    fileseps = strfind(newResult, '/');
    d = newResult(1:fileseps(end));
    cd(d);
    if updatePath
    	addpath(genpath(d));
        savepath;
    end

	% notify
	fprintf('\nNow in %s\n\n', pwd);
    return;
catch me
    fprintf('\nCould not CD. Check MException.\n');
    varargout{1} = me;
end

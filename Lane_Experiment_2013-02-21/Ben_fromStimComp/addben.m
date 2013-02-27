function [oldPath, addedPath] = addben
%
% flag = addben adds the current directory and all its subdirectories to
% the path
%
% (c) bnaecker@stanford.edu 23 Jan 2012

%% Old path
oldPath = path;

%% Find the current directory and the parent
here = pwd;
% seps = strfind(here, filesep);
% parent = here(1:seps(end));

%% Get all the children to the parent
% addedPath = genpath(parent);
addedPath = genpath(here);

%% Add them
path(addedPath, oldPath);
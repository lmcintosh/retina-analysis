function r = row(x)
%
% FUNCTION r = row(x)
%
% Makes x into a row vector 
%
% (c) bnaecker@stanford.edu 14 Jan 2013 

if size(x, 1) == 1
	return;
elseif size(x, 2) == 1
	r = x';
else
	r = x(:)';
end

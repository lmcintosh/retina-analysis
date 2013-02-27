function c = col(x)
%
% FUNCTION c = col(x)
%
% makes x into a column vector 
%
% (c) bnaecker@stanford.edu 14 Jan 2013 

if size(x, 1) == 1
	c = x';
elseif size(x, 2) == 1
	return
else
	c = s(:);
end

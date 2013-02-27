function [nrmA, nrms] = normify(A, dim)
%
% function [nrmA, nrms] = normify(A, dim)
%
% returns the normed version of A, along the dimension 'dim'.
% i.e., dim == 1 means take the norm of the rows of A, dim == 2 means take
% the norm of the columns. 'nrmA' is A with each vector normed
% appropriately, 'nrms' is the norm of each original vector
%
% (c) bnaecker@stanford.edu 21 Sep 2012

% check A is a matrix
assert(ismatrix(A), ...
    'normify:NDInput', ...
    'Normify only works on matrices');

% check if it's a vector
if isvector(A)
    if nargout == 2
        nrms = norm(A);
    else
        nrms = [];
    end
    nrmA = A ./ norm(A);
    return
end

% check for dim arg
if ~exist('dim', 'var')
    dim = 1;
end

% do norm
nrmA = A;
if dim == 2
    nrm = zeros(size(A, 1), 1);
    for vi = 1:size(A, 1)
        nrm(vi) = norm(A(vi, :));
    end
    nrmA = A ./ (nrm * ones(1, size(A, 2)));
elseif dim == 1
    nrm = zeros(1, size(A, 2));
    for vi = 1:size(A, 2)
        nrm(vi) = norm(A(:, vi));
    end
    nrmA = A ./ (ones(size(A, 1), 1) * nrm);
end

% return norms if requested
if nargout == 2
    nrms = nrm;
else
    nrms = [];
end
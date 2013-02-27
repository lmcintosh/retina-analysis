function y = pinknoise(a, m, n, stream)
%
% PINKNOISE - returns array of 1/f noise using random 'stream'
%
% usage:
%   PINKNOISE(a, m, n, seed) returns an m-by-n array
%   of noise with 1/(f^a) amplitude spectrum
%
% (c) bnaecker@stanford.edu
% 
% HISTORY:
% 12 Jan 2012       BNN     Wrote it. Adapted from ONEOVERF (LKC)

%% Deal with odd array sizes
mOdd = 0; nOdd = 0;
if isodd(m)
    m = m + 1;
    mOdd = 1;
end
if isodd(n)
    n = n + 1;
    nOdd = 1;
end

%% Make noise
skirt = spike(a, m, n);                     % The amplitude spectrum
y = skirt .* exp(1i .* 2 .* ...             % Noise in complex frequency domain
    pi .* rand(stream, m, n));
y = normalize(real(ifft2(fftshift(y))));    % Tranfer to space domain

%% Deal with odd array sizes again
if mOdd
    y = trimr(y, 1);
end
if nOdd
    trimb(y, 1);
end
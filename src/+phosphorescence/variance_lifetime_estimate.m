function var = variance_lifetime_estimate(tau, T, k, N)
%VARIANCE_LIFETIME_ESTIMATE Compuate the variance of an lifetime estimate.
%
%   Compute the variance of an estimate of TAU based on N photons acquired
%   over a time T and using K channels
%
%   The formula is based on the paper
%
%   How many photons are necessary for fluorescence-lifetime measurements?
%   M. Köllner, J. Wolfrum. Chemical Physics Letters 200 (1992), p. 199-204.
%   https://doi.org/10.1016/0009-2614(92)87068-Z
%
%   Inputs:
%       TAU = lifetime [s]
%       T   = measurement window width [s]
%       K   = number of channels, equivalently number of bins for the time window
%       N   = number of photons
%
%   Output:
%       VAR = computed variance
%
% Adrien Luecker, Institute of Fluid Dynamics, ETH Zurich
% May 2014 - September 2017

if nargin < 4
    N = 1;
end

r = T/tau;
var1 = k^2/r^2*(1 - exp(-r))...
     / ((exp(r/k)*(1 - exp(-r)))/(exp(r/k) - 1)^2 - k^2/(exp(r)-1));
var = tau^2/N*var1;
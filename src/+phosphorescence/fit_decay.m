function [tau, resnorm] = fit_decay(t, J, t_on)
%FIT_DECAY Fit a single exponential decay.
%
%   Fit a single exponential decay to the data in J as a function of T.
%   The decays are only fitted for values of T > T_on.
%
%   Inputs:
%       T    = times (1 x Nt)
%       J    = signal (1 x Nt)
%       T_ON = time from which to fit
%
%   Outputs:
%       TAU     = fitted lifetime
%       RESNORM = fit residual

% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
% Adrien Luecker, Institute of Fluid Dynamics, ETH Zurich, 2014-2017

% function to fit a single exponential decay
f_decay = @(x,xdata)x(1)*exp(-xdata/x(2));

% extract indices of off-phase
idx_off = (t > t_on);
t_off   = t(idx_off) - min(t(idx_off));
% renormalize signal
J_off   = J(idx_off)/max(J);

options = optimoptions(@lsqcurvefit,'Algorithm', 'levenberg-marquardt', ...
    'TolX', 1e-12, 'TolFun',1e-12, 'MaxFunEvals', 1000);
[fit, resnorm] = lsqcurvefit(f_decay, [1, 1e-5], t_off, J_off, [], [], options);

tau = fit(2);

plot_fit = 0;

if plot_fit
    figure(3)
    plot(t_off, J_off, 'b-')
    hold on
    plot(t_off, f_decay(fit, t_off), 'r--')
    legend('signal', 'fit')
    xlabel('t [s]')
    ylabel('Normalized collected signal')
end

end

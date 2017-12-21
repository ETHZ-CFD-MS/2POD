import utils.mmHgToMolar

%% Set parameters

r_min = 0;
r_max = 1e-5;
dr    = 1e-5;

z_min = 0;
z_max = 1e-5;
dz    = 1e-5;

S_P  = 1e-3; % initial probe concentration [M]
S_O2 = 1e-3; % initial oxygen concentration [M]

T = 273.15 + 25; % temperature [K]

P       = 5e-3;    % laser power (FIXME: mean?) [W]
Np      = 2000;    % number of pulses
t_pulse = 110e-15; % pulse duration [s]
f       = 80e6;    % laser frequency [s^-1]
lambda  = 840e-9;  % wave length of light [m]
NA      = 0.95;    % numerical aperture
t_coll  = 5e-4;    % collection period duration [s]
PSF_type = 'gaussian';

kd     = 2.4e5; % [s^-1]
kp     = 1.7e4; % [s^-1]
kq     = 1.2e3/mmHgToMolar(1, T); % [M^-1 s^-1] ( = 1200 [mmHg^-1 s^-1]) 
sigma2 = 100e-58;   % probe cross-section [m^4 s photon^-1 molecule^-1]
                    % The value is actually 100 GM = 100 * 10^{-50} cm^4 s photon^-1 molecule^-1

D      = 2e-9;  % [m^2 s^-1]

dt_coll = 1e-6; % time step during collection period
rel_tol = 1e-9; % relative tolerance in Newton iteration

%% Initialization of grid, matrices and fields

% Construct grid
Nr = round((r_max - r_min)/dr);
Nz = round((z_max - z_min)/dz);
N = Nr*Nz; % number of grid cells

% Coordinates of cell faces
rf = linspace(r_min, r_max, Nr+1);
zf = linspace(z_min, z_max, Nz+1);

% Coordinates of cell centers
rc = 0.5*(rf(1:end-1) + rf(2:end));
zc = 0.5*(zf(1:end-1) + zf(2:end));

% Create matrix for the discretized Laplacian
A_O2 = 0;
A = [zeros(N)  zeros(N); ...
     zeros(N)     A_O2];

% Initialize fields
PT = zeros(N,1);
O2 = S_O2*ones(N,1);

%% Compute photon flux and excitation rate
alpha = 1e5; % dummy value

%% Integrate over collection period
N_dt = round(t_coll/dt_coll);
tt = [];
PT_t = [];
O2_t = [];
t = 0;
for i = 1:100
    [PT, O2] = integrate_system(PT, O2, dt_coll, 0*A, alpha, kd, kp, kq, S_P, S_O2, rel_tol);
    % collect signal
    
    t = t + dt_coll;
    tt = [tt t];
    PT_t = [PT_t PT];
    O2_t = [O2_t O2];
end

plot(tt, PT_t, tt, O2_t)
hold on
% analytical solution for PT when kq = 0
% plot(tt, S_P*(1-exp(-alpha*tt)), 'k')
% analytical solution for O2 when kd = 0 and alpha >> 1/dt
% plot(tt, S_O2*exp(-kq*S_P*tt), 'k')

PT
O2

%% Analytically compute steady state solution
% a = -(alpha + kq)*kq;
% b = alpha*S_P*kq - kd*(alpha+kq) + kq*kd*S_O2;
% c = alpha*kd*S_P;
% 
% % Solution for P_T
% r = roots([a b c]);
% PT_steady = max(r)
% 
% % Solution for O_2
% O2_steady = kd*S_O2/(kd+kq*PT_steady)

syms P O
S = solve(alpha*S_P - (alpha+kp+kq*O)*P == 0,...
          kd*S_O2   - (kd+kq*P)*O == 0);
fprintf('Analytical P^T = %g\n', max(eval(S.P)))
fprintf('Analytical O_2 = %g\n', max(eval(S.O)))


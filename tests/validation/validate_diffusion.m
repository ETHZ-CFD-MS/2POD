%% Set parameters
r_min = 0;
r_max = 1;
dr    = 1e-1;

z_min = 0;
z_max = 2;
dz    = 1e-1;

S_O2 = 3e-4; % initial oxygen concentration [M]

% D      = 2e-9;  % [m^2 s^-1]
D      = 1;  % [m^2 s^-1]

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
A = diffusion_matrix_cylindrical(rf, zf, D);

%% Control

% Test if a constant field undergoes no diffusion
% sum(A')

% Test diffusion from a initial condition with a jump.
Y = zeros(N,1);
Y(Nr/2:Nr:N) = 1; % test "symmetry" in r-direction
% Y((9*Nr+1):(11*Nr)) = 1; % test symmetry in z-direction

dt = 1e-2;

N_dt = 100;

% create meshgrid with r and z
[Z, R] = meshgrid(zc, rc);

Ya = reshape(Y, Nr, Nz);
mesh(Z, R, Ya)
for i=1:N_dt
    Y = (speye(N) - dt*A)\Y;
    
    Ya = reshape(Y, Nr, Nz);
    mesh(Z, R, Ya)
    xlabel('z')
    ylabel('r')
    drawnow
%     min(Y)
end
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

import utils.mmHgToMolar

%% initialization 
% probeName = 'PtP-C343';
% probeName = 'PtTCHP-C307';
probeName = 'PtG2p';
% runName = 'O2_titration_no_protein_S_P_50e-6_Pm_50e-3_rMax_16um';
% runName = 'O2_titration_S_P_50e-6_Pm_50e-3_RSA_ratio_0_16_rMax_16um';
% runName = 'probePowerDependence_PO2_50_RSA_ratio_0_16_rMax_16um';
% runName = 'removalRatioDependence_RSA_PO2_50_S_P_50e-6_Pm_50e-3_rMax_16um';
% runName = 'diffusionO2Dependence_PO2_50_S_P_50e-6_Pm_50e-3_rMax_16um';
% runName = 'PO2_50_S_P_50e-6_Pm_50e-3_RSA_ratio_0_16_rMax_16um_t_coll_975us_nGates_100';
% runName = 'PO2_50_S_P_50e-6_Pm_50e-3_RSA_ratio_0_16_nGates_400_rMax_32um_Neumann';
runName = 'testRun';
% runName = 'nPhotonVsPower';
% runName = 'nPhotonVsOnPhaseLengthWithCstApparentPower';
% saveFileName = ['../cases/diss-' probeName '/' runName];
saveFileName = ['../cases/photon_counting/' runName];

PO2 = 50;       % oxygen partial pressure [mmHg]
% PO2Array = [0:5:20, 30:10:60, 80:20:160]; % oxygen partial pressure [mmHg]
PO2Array = [50];
S_P = 5e-6;     % probe concentration [M]
% S_PArray = 10e-6:10e-6:100e-6;     % probe concentration [M]
Pm = 5e-3;  % mean laser mean power [W]
% PmArray = 5e-3:5e-3:50e-3; % mean laser mean power [W]
PmArray = 1e-3:1e-3:10e-3;
nGates = 1; % number of excitation gates
% t_coll = 225e-6; % duration of collection period)
t_coll = 250e-6; % duration of collection period)

% k_rem = 0.4e8; % [M^-1 s^-1] total removal rate of singlet O2 by proteins (BSA, Pimenta et al., 2015, Table 2)
% k_rem = 2.6e8; % [M^-1 s^-1] total removal rate of singlet O2 by proteins (HSA, Pimenta et al., 2015, Table 2)
k_rem = 4.1e8; % [M^-1 s^-1] total removal rate of singlet O2 by proteins (RSA, Pimenta et al., 2015, Table 2)
protein_conc = 42.5/66000; % [M] (protein concentration [g/L] / (molar mass)) (Goldwasser et al., 1997; Low, 1952)
% protein_conc = 0; % [M]
removal_ratioArray = 0.0:0.05:0.5;
removal_ratio = 0.16; % ratio k_r/(k_q,pr + k_r) (Foote et al, 1975)
kr = removal_ratio*k_rem*protein_conc; % rate of irreversible oxygen removal
kqpr = (1 - removal_ratio)*k_rem*protein_conc; % quenching rate

% D = 2.11e-9; % diffusion coefficient of O2 in distilled water at 25?C [m^2/s]
% D = 1.62e-9; % diffusion coefficient of O2 in human plasma at 25?C [m^2/s] (1975, Goldstick)
D = 2.18e-9; % diffusion coefficient of O2 in human plasma at 37?C [m^2/s] (1975, Goldstick)
DArray = 1e-9*[0:0.1:0.6, 0.8, 1, 1.25, 1.5, 1.8, 2.1, 2.5];

t_onArray = 1e-6*[1, 5, 10, 15, 20, 25];
t_collArray = 250e-6 - t_onArray;
NpArray = round(1e-6*[1, 5, 10, 15, 20, 25]*80e6);
PmArray = Pm*2000./NpArray;

T = 273.15 + 36.5; % temperature [K]
% T = 273.15 + 23; % temperature [K]

switch probeName
    case 'PtP-C343'
        kp     = 2.174e4; % [s^-1], using fit to titration curve (batch 2015-10)
        kq     = 341.01/mmHgToMolar(1, T); % [M^-1 s^-1], using fit to titration curve (batch 2015-10)
        sigma2 = 65e-58; % communicated by Sergei Vinogradov, takes non-efficient FRET into account
        phip = 0.10; % communicated by Sergei Vinogradov
    case 'PtTCHP-C307'
        kp     = 1.4e4; % [s^-1], at 36.5?C, obtained from \tau = 7.13e-5 s at PO2 = 0
                  % (Roussakis et al., 2014, Supporting Information, S10)
        kq     = 1.2e3/mmHgToMolar(1, T); % [M^-1 s^-1] ( = 1200 [mmHg^-1 s^-1], Roussakis et al., 2014, p. 5943)
        sigma2 = 100e-58;   % probe cross-section [m^4 s photon^-1 molecule^-1]
        phip   = 0.20; % communicated by Sergei Vinogradov
    case 'PtG2p'
        kp = 1e6/41.; % [s^-1]
        kq = 532.6/mmHgToMolar(1, T); % [M^-1 s^-1]
        sigma2 = 652e-58; % data from Sergei, at lambda = 960nm (11/05/2017), probe cross-section [m^4 s photon^-1 molecule^-1]
        phip   = 0.18; % communicated by Sergei Vinogradov
    otherwise
        fprintf('Unknown probe name %s', probeName)
        return
end

rGrading = @(r) ((r < 3e-6)*1 + (r >= 3e-6).*(1 + (r - 3e-6)*(3 - 1)/(8e-6 - 3e-6)));
zGrading = @(z) ((z < 3e-6)*1 + (z >= 3e-6).*(1 + (z - 3e-6)*(3 - 1)/(8e-6 - 3e-6)));

grid = CartesianGrid(0, 12e-6, 1e-7, 0, 15e-6, 1e-7, rGrading, zGrading);
% grid = CartesianGrid(0, 16e-6, 1e-7, 0, 20e-6, 1e-7, rGrading, zGrading);
% grid = CartesianGrid(0, 20e-6, 1e-7, 0, 25e-6, 1e-7, rGrading, zGrading);
% grid = CartesianGrid(0, 32e-6, 1e-7, 0, 40e-6, 1e-7, rGrading, zGrading);

laserProperties = ...
    struct('Pm'      , Pm,      ... % mean laser mean power [W]
           'nGates'  , nGates,  ... % number of gates
           'Np'      , 2000,    ... % number of pulses
           'f'       , 80e6,    ... % laser frequency [Hz]
           't_pulse' , 110e-15, ... % pulse duration [s]
           'lambda'  , 950e-9,  ... % wave length of light [m]
           'NA'      , 0.95,    ... % numerical aperture
           'n0'      , 1.33,    ... % refractive index after the lens
           't_coll'  , t_coll,  ... % collection period duration [s]
           'chi'     , 0.05,    ... % collection efficiency
           'PSF_type', 'bessel' ...
    );

chemicalProperties = ...
    struct('kp'    , kp,     ... % phosphorescence decay rate without quencher [s^-1]
           'kq'    , kq,     ... % phosphorescence quenching rate [M^-1 s^-1]
           'sigma2', sigma2, ... % probe cross-section [m^4 s photon^-1 molecule^-1]
           'D'     , D,      ... % oxygen diffusion coefficient [m^2 s^-1]   
           'kd'    , 2.4e5,  ... % decay rate of singlet oxygen in water [s^-1]
           'kqpr'  , kqpr,   ... % singlet O2 quenching rate by proteins [M^-1 s^-1]
           'kr'    , kr,     ... % irreversible decay rate of singlet oxygen by proteins [s^-1]
           'phip'  , phip,   ... % phosphorescence quantum yield [-]
           'T'     , T       ... % temperature [K]
    );

numericProperties = ...
    struct('f_opt'  , 5,    ... % pulse aggregation factor (optimization)
           'RelTol' , 1e-6,  ... % relative tolerance for ODE solver
           'AbsTol' , 1e-10  ... % absolute tolerance for ODE solver
    );

parameterStudyArray = PO2Array;
% parameterStudyArray = S_PArray;
% parameterStudyArray = removal_ratioArray;
% parameterStudyArray = DArray;
% parameterStudyArray = PmArray;
% parameterStudyArray = NpArray;
n     = numel(parameterStudyArray);
% parameterStudyArray = {S_PArray, PmArray};
% [S_vals, Pm_vals] = meshgrid(S_PArray, PmArray);
% S_vals = S_vals(:);
% Pm_vals = Pm_vals(:);
% n     = numel(S_vals);

tau = zeros(laserProperties.nGates, n);
n_photons = zeros(laserProperties.nGates, n);
laserPropCell = cell(n, 1);
chemPropCell = cell(n, 1);

%% main loop
for i = 1:n
    laserPropCell{i} = laserProperties;
    chemPropCell{i} = chemicalProperties;
    
    PO2 = PO2Array(i);
%     S_P = S_PArray(i);
    
%     S_P = S_vals(i);
%     laserPropCell{i}.Pm = Pm_vals(i);
%     laserPropCell{i}.Pm = PmArray(i);
%     laserPropCell{i}.Np = NpArray(i);
%     laserPropCell{i}.t_coll = t_collArray(i);

%     chemPropCell{i}.kqpr = (1 - removal_ratioArray(i))*k_rem*protein_conc;
%     chemPropCell{i}.kr   = removal_ratioArray(i)*k_rem*protein_conc;
%     chemPropCell{i}.D = DArray(i);
    
    [J, tt] = phosphorescence_decay(PO2, S_P, grid, laserPropCell{i}, chemPropCell{i}, numericProperties);

    % extract phosphorescence lifetime and number of collected photons
    tau_all_gates = zeros(laserPropCell{i}.nGates, 1);
    n_photons_all_gates = zeros(laserPropCell{i}.nGates, 1);
    t_on = laserPropCell{i}.Np/laserPropCell{i}.f;
    for iGate = 1:laserPropCell{i}.nGates
        [tau_all_gates(iGate), resnorm] = fit_decay(tt(iGate,:), J(iGate,:), t_on);
        n_photons_all_gates(iGate) = photon_count(tt(iGate,:), J(iGate,:), t_on);
        fprintf('Phosphorescence lifetime for S_P = %g, Pm = %g (gate %i): tau = %e (resnorm = %e)\n', ...
                S_P, laserPropCell{i}.Pm, iGate, tau_all_gates(iGate), resnorm)
    end
    tau(:, i) = tau_all_gates;
    n_photons(:, i) = n_photons_all_gates;
end

%% save data
save([saveFileName '.mat'], 'laserProperties', 'chemicalProperties', 'numericProperties', ...
    'parameterStudyArray', 'laserPropCell', 'chemPropCell', 'grid', 'tau', 'n_photons')
save([saveFileName '.mat'], 'PO2', 'S_P', 'Pm', ...
     'k_rem', 'protein_conc', 'removal_ratio', '-append')
fprintf('Saved simulation data to %s.\n', [saveFileName '.mat'])

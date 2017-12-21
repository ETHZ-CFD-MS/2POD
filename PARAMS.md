Input variables
===============

Here is a typical example of a input file 'params.json' for simulations with oxygen diffusion
and singlet oxygen consumption:

    {
        "type": "O2_diffusion",

        "PO2": 50,
        "S_P": 5e-6,
        "kp": 2.174e4,
        "kq": 532.6,
        "kd": 2.4e5,
        "kr": 4.2242e4,
        "kqpr": 2.2177e5,
        "sigma2": 652e-58,
        "phip": 0.18,
        "D_O2": 2.18e-9,
        "temp": 309.65,
        
        "n_gates": 5,
        "Pm": 50e-3,
        "n_pulse": 2000,
        "frequency": 80e6,
        "t_pulse": 110e-15,
        "wavelength": 950e-9,
        "NA": 0.95,
        "n0": 1.33,
        "t_coll": 225e-6,
        "chi": 0.05,
        "PSF_type": "bessel",
        "scatt_length_ex": 47e-6,
        "scatt_depth": 0e-6,

        "r_max": 12e-6,
        "dr": 1e-7,
        "z_max": 15e-6,
        "dz": 1e-7,
        "r_grading": "@(r) ((r < 3e-6)*1 + (r >= 3e-6).*(1 + (r - 3e-6)*(3 - 1)/(8e-6 - 3e-6)))",
        "z_grading": "@(z) ((z < 3e-6)*1 + (z >= 3e-6).*(1 + (z - 3e-6)*(3 - 1)/(8e-6 - 3e-6)))"

        "abs_tol": 1e-10,
        "rel_tol": 1e-6
    }

For simulations with the assumption of fixed oxygen concentration, the key "type" should be omitted.
In that case, the keys "kd", "kr", "kqpr", "n_gates", "abs_tol" and "rel_tol" are not used.
Note that only one gate is needed as long as the collection period is sufficiently long for all the
probe in triplet state to decay back to ground state.

Explanation of the variables:

Variable          | Unit             | Signification
----------------- | ---------------- | -------------
type              | -                | Simulation type ("O2_diffusion" or omitted)
PO2               | mmHg             | Initial oxygen partial pressure
S_P               | mol/L            | Initial probe concentration
kp                | s^-1             | Phosphorescence decay rate with PO2 = 0
kq                | mmHg^-1 s^-1     | Phosphorescence quenching rate
kd                | s^-1             | Decay rate of singlet oxygen
kr                | s^-1             | Rate of permanent singlet oxygen removal
kqpr              | mmHg^-1 s^-1     | Quenching rate of singlet oxygen by organic molecules
sigma2            | m^4 s photon^-1  | Two-photon absorption cross section of the probe
phip              | -                | Phosphorescence quantum yield
D_O2              | m^2 s^-1         | Oxygen diffusion rate
temp              | K                | Medium temperature
n_gates           | -                | Number of gates to simulate
Pm                | W                | Mean laser power
n_pulse           | -                | Number of laser pulses per excitation gate
frequency         | s^-1             | Laser frequency
t_pulse           | s                | Laser pulse duration
wavelength        | m                | Laser wavelength
NA                | -                | Numerical aperture of the objective
n0                | -                | Refractive index of the medium between lens and specimen
t_coll            | s                | Duration of the collection period (off-phase)
chi               | -                | Collection efficiency
PSF_type          | -                | Model for point spread function ("bessel" or "gaussian")
scatt_length_ex   | m                | Attenuation length for scattering of the excitation light
scatt_depth       | m                | Depth for the computation of attenuation due to scattering
r_max             | m                | Radius of the computational domain
dr                | m                | Minimal grid cell width in the radial direction
z_max             | m                | Half-height of the computational domain
dz                | m                | Minimal grid cell height in the axial direction
r_grading         | -                | Function handle used for mesh grading in the radial direction
z_grading         | -                | Function handle used for mesh grading in the axial direction
abs_tol           | -                | Absolute tolerance in the numerical integration
rel_tol           | -                | Relative tolerance in the numerical integration





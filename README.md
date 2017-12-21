2POD
=====

2POD (2-Photon phosphorescence with Oxygen Diffusion) is a MATLAB library for the
simulation of phosphorescence decays in two-photon microscopy with
oxygen diffusion and consumption by organic molecules.

Getting Started
---------------

### Prerequisites

2POD was tested on computers running Linux and Mac OS using Matlab
versions starting from R2015a. No Matlab toolboxes are used.

### Installation

To run the code, the following folders have to be added to the MATLAB
path:

* /path/to/2pod/src
* /path/to/2pod/scripts
* /path/to/2pod/third_party/jsonlab-1.2

This can be done in the MATLAB GUI or by adding `addpath` statements to
the file `startup.m` as follows

    addpath /path/to/2pod/src

The file `startup.m` should be in the user path that is obtained with 
the command `userpath` in MATLAB:

### Running the code

The easiest way to start is to run the tutorials located in the
eponymous folder. Each subfolder contains a script 'run.m' that runs
the simulations and possibly plots results.

Additional information for running this code from the command line,
possibly in parallel, is given in the file [RUN.md](RUN.md). The meaning of 
the input parameters is explained in the file [PARAMS.md](PARAMS.md).

Features
--------

This library simulates the spatio-temporal evolution of the
concentration of a two-photon-sensitive nanoprobe in its ground state
and its triplet state. Additionally, the oxygen concentration in
triplet and singlet state can be simulated. Oxygen diffusion as well
consumption of singlet oxygen by organic compounds can be modeled. 

The illumination profile by the focused laser can be computed either
using a formulation based on Bessel functions or a Gaussian
approximation. Details and references are found in the package
'optics' in the 'src' folder.

The simulation code for phosphorescence decays with oxygen
diffusion and singlet oxygen removal is based on Chapter 5 of the PhD
dissertation by Adrien Luecker which is available from the [ETHZ
Research collection](https://www.research-collection.ethz.ch/handle/20.500.11850/181551).
The model implemented here extends that in 
[Finikova et al. (2008)](http://dx.doi.org/10.1002/cphc.200800296) 
and
[Sinks et al. (2010)](http://dx.doi.org/10.1021/jp100353v) 
(see references below), where the oxygen concentration was assumed to be zero 
and diffusion was absent.

License
-------

This library is licensed under the GNU General Public License 3.
Please see the file [LICENSE.md](LICENSE.md) for more details.

Although the GNU General Public License does not permit terms requiring users 
to cite the publications that this software is based one (see 
[here](https://www.gnu.org/licenses/gpl-faq.en.html#RequireCitation)), any research 
making use of this software should appropriately cite the references given below, 
in keeping with normal academic practice.

References
----------

Lücker A. Computational Modeling of Oxygen Transport in the Microcirculation -
From an Experiment-Based Model to Theoretical Analyses. PhD dissertation, ETH Zurich, 2017.
DOI: [10.3929/ethz-b-000181551](https://doi.org/10.3929/ethz-b-000181551)

Finikova OS, Lebedev AY, Aprelev A, Troxler T, Gao F, Garnacho C, Muro S, Hochstrasser RM 
and Vinogradov SA.
Oxygen Microscopy by Two-Photon-Excited Phosphorescence. ChemPhysChem 2008; 9(12), 1673-1679.
DOI: [10.1002/cphc.200800296](http://dx.doi.org/10.1002/cphc.200800296)

Sinks LD, Robbins GP, Roussakis E, Troxler T, Hammer DA and Vinogradov SA.
Two-Photon Microscopy of Oxygen: Polymersomes as Probe Carrier Vehicles.
The Journal of Physical Chemistry B 2010; 114(45), 14373-14382.
DOI: [10.1021/jp100353v](http://dx.doi.org/10.1021/jp100353v)

Authors
-------

2POD was developed by Adrien Lücker at ETH Zurich (Institute of Fluid
Dynamics).

Acknowledgements
----------------

The development of this library was made possible by the inputs and the
scientific support of Sergei Vinogradov whom we cordially thank.

This library uses the MATLAB toolbox JSONlab developed by Qianqian Fang at the 
Optics Division, Martinos Center for Biomedical Imaging, Massachusetts General 
Hospital/Harvard Medical School, available 
[here]( http://iso2mesh.sourceforge.net/cgi-bin/index.cgi?jsonlab) under the GNU 
General Public License version 3.

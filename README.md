![image](glm-examples/example_lakes_files/figure-gfm/lakenz.png)

# GLM-AED 
[![Latest release](https://badgen.net/github/release/Naereen/Strapdown.js)](https://github.com/AquaticEcoDynamics/glm-aed/releases)
[![Linux](https://svgshare.com/i/Zhy.svg)](https://svgshare.com/i/Zhy.svg)
[![macOS](https://svgshare.com/i/ZjP.svg)](https://svgshare.com/i/ZjP.svg)
[![Windows](https://svgshare.com/i/ZhY.svg)](https://svgshare.com/i/ZhY.svg)
[![GPLv3 license](https://img.shields.io/badge/License-GPLv3-blue.svg)](http://perso.crans.org/besson/LICENSE.html)
[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/AquaticEcoDynamics/glm-aed/HEAD?urlpath=rstudio)

<br>

<a href="url"><img src="glm-source/admin/glm-icon2.png" align="right" width="50" ></a> The **General Lake Model** (**GLM**) is a water balance and one-dimensional vertical stratification hydrodynamic model, which is dynamically coupled with the **AED** water quality modelling library. This repository houses the coupled model code libraries, example applications, and binaries (ready-to-run executable files). 

<a href="url"><img src="glm-source/admin/aed-icon2.png" align="right" width="50" ></a> GLM-AED is suitable for simulating conditions in a wide range of natural and engineered lakes, including shallow (well-mixed) and deep (stratified) systems. The model has been successfully applied to systems from the scale of individual ponds and wetlands, to actively operated reservoirs, upto the scale of the Great Lakes. 

<br>

## Repository organisation

The repository includes:

- `binaries` : model pre-compiled executables for mac, linux and windows.
- `glm-source` : model source code, including GLM and AED as linked sub-modules.
- `glm-examples` : model example simulations, including all required input files.
- `workflows` : github workflows for automated compilation and testing.

<br>

## Citing this code

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.6363500.svg)](https://doi.org/10.5281/zenodo.6363500) (BADGE PENDING RELEASE)

Pending Authors (Pending year). General Lake Model - Aquatic Ecosystem Dynamics (GLM-AED) V XXXX. [Software]. Zenodo. (Pending Zenado DOI)

<br>

## Getting the latest executables

For users who only need access to a model executable, the executable for your chosen platform can be downloaded without getting the full repository. Simply navigate to the binaries/os folder, click on the relevant file (e.g., `glm_3.3.0.zip`) and click the "*download*" button on the right.

<br>

## Cloning the repo with all sub-module code

To access the full repository, including the model examples, the repository must be cloned or downloaded in full. Note that a basic clone will not include the code/files in the linked sub-modules, so an extra argument is needed `--recurse-submodules`

### Cloning the latest code
```
git clone --recurse-submodules https://github.com/AquaticEcoDynamics/glm-aed.git
```

### Cloning a particular tag
```
git clone --recurse-submodules -b v3.3.0 https://github.com/AquaticEcoDynamics/glm-aed.git
```

<br>

## Additional information

See repository [Wiki](https://github.com/AquaticEcoDynamics/glm-aed/wiki) for additional information on getting started using GLM-AED, working with the repository, and updating or adding new example lakes.

<br>

[<img src="glm-source/admin/aed.png" alt="AED" width="100"/>](https://aquatic.science.uwa.edu.au)



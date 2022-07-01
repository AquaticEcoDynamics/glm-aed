![image](glm-examples/example_lakes_files/figure-gfm/lakenz.png)

# GLM-AED
[![GPLv3 license](https://img.shields.io/badge/License-GPLv3-blue.svg)](http://perso.crans.org/besson/LICENSE.html)
[![Linux](https://svgshare.com/i/Zhy.svg)](https://svgshare.com/i/Zhy.svg)
[![macOS](https://svgshare.com/i/ZjP.svg)](https://svgshare.com/i/ZjP.svg)
[![Windows](https://svgshare.com/i/ZhY.svg)](https://svgshare.com/i/ZhY.svg)
[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/AquaticEcoDynamics/glm-aed/HEAD?urlpath=rstudio)
[![Latest release](https://badgen.net/github/release/Naereen/Strapdown.js)](https://github.com/AquaticEcoDynamics/glm-aed/releases)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.6363500.svg)](https://doi.org/10.5281/zenodo.6363500) (BADGE PENDING RELEASE)

<br>

The **General Lake Model** (**GLM**) is a water balance and one-dimensional vertical stratification hydrodynamic model, which is dynamically coupled with the AED water quality modelling library. This repository houses the coupled model code libraries, example applications, and binaries. 

GLM is suitable for simulating conditions in a wide range of natural and engineered lakes, including shallow (well-mixed) and deep (stratified) systems. The model has been successfully applied to systems from the scale of individual ponds and wetlands, to actively operated reservoirs, upto the scale of the Great Lakes.

<br>

## Repository organisation

The repository includes:

- `glm-source` : model source code, including GLM and AED as linked sub-modules.
- `glm-examples` : model example simulations, including all required input files.

<br>

## Citing code

Pending Authors (Pending year). General Lake Model - Aquatic Ecosystem Dynamics (GLM-AED) V XXXX. [Software]. Zenodo. (Pending Zenado DOI)

## Cloning the repo with all submodule code

A basic clone will not include the code in the submodules so an extra argument is needed `--recurse-submodules`

### Cloning the latest code
```
git clone --recurse-submodules https://github.com/AquaticEcoDynamics/glm-aed.git
```

### Cloning a particular tag
```
git clone --recurse-submodules -b v3.3.0 https://github.com/AquaticEcoDynamics/glm-aed.git
```

## Archiving all code

If you want to create an archive of all the code (including the submodules), first clone the repository as described above and zip entire repository.  The zip file can be uploaded to Zenado to get a DOI.  An automated integration with Zenodo will not archive the code from the submodules.

## Additional information

See repository Wiki for additional information on editing the repository and adding new example lakes.

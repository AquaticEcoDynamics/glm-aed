# GLM-AED
[![GPLv3 license](https://img.shields.io/badge/License-GPLv3-blue.svg)](http://perso.crans.org/besson/LICENSE.html)
[![Linux](https://svgshare.com/i/Zhy.svg)](https://svgshare.com/i/Zhy.svg)
[![macOS](https://svgshare.com/i/ZjP.svg)](https://svgshare.com/i/ZjP.svg)
[![Windows](https://svgshare.com/i/ZhY.svg)](https://svgshare.com/i/ZhY.svg)
[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/AquaticEcoDynamics/glm-aed/HEAD?urlpath=rstudio)
[![Latest release](https://badgen.net/github/release/Naereen/Strapdown.js)](https://github.com/AquaticEcoDynamics/glm-aed/releases)

The General Lake Model (GLM) is a water balance and one-dimensional vertical stratification hydrodynamic model, which is dynamically coupled with the AED water quality modelling library. The repository houses the coupled model code libraries, example applications, and binaries. 


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
## Updating existing submodules

```
git submodule update --remote
git add .
git commit -m 'updating submodule X and X'
git push
```

## Adding new submodules
```
git submodule add https://github.com/AquaticEcoDynamics/libaed-new.git
```
where you replace the Github url with the url of the new module

## Archiving all code

Clone the repository as described above and zip entire repository.  The zip file can be uploaded to Zenado to get a DOI.  An automated integration with Zenodo will not archive the code from the submodules.

## Adding new example lake

You can add a new example lake that is automatically run using updated GLM-AED code.  

1. Add lake directory to `glm-examples` subdirectory.  The directory of the lake can not have spaces in the name.
2. Add configuration and driver files to the new lake directory.  In the glm3.nml, be sure that the output.nc and lake.csv are written to an output subdirectory.
3. Add lake to the github action file `glm-aed/.github/workflows/compile.yml`.  You should add it after the other example lakes. Here is an example:
```
      - name: run GLM Lake Alex
        run: |
          cd glm-examples/LakeAlexandrina
          $GITHUB_WORKSPACE/glm-source/GLM/glm
 ```         
5.  Update `.gitignore` to include the output.nc file from the new example.  For example this is the line that should be added for LakeAlexandrina:

```
glm-examples/LakeAlexandrina/output/output.nc
```

6. Add plotting of lake output to `glm-aed/glm-examples/example_lakes.Rmd`.  Use the plotting code for the other lakes as a template.


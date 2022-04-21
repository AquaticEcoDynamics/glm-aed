# Sparkling Lake

## Study Site
Sparkling Lake is an [oligotrophic, northern temperate lake](https://microbes.limnology.wisc.edu/sites/default/files/Modelling%20phytoplankton-zooplanktoninteractions%20in%20Sparkling%20Lake.pdf) (89.7 ºN, 46.3 ºW) in Winconsin, USA.
The lake has a surface area of 0.638 km<sup>2</sup>, and is about 20 m deep.

## Model Setup
The model is set-up to simulate the hydrological domain of Sparkling Lake for 2 years, from **1980-04-15** to **1982-04-15** (`&time`), with water balance and heat fluxes [hypothetically calculated](http://aed.see.uwa.edu.au/research/models/GLM/downloads/AED_GLM_v2_0b0_20141025.pdf) based on the lake configuration and input data. In this model, water quality functionality (AED2) (`&wq_setup`) is disabled, but snow-ice lake dynamics (`&snowice`) is enabled for the simulation .


#### Lake Configuration
The flexible model structure allow users to configure the switches of the individual model components, enabling the customization of the physical model, meteorological and flow conceptualisations.


**Physical Model Configuration**

| Configuration Flags | Description | Activation |
| ---------------- |:----------|:-----------:|
| `&morphometry` | Lake location (*latitude and longitude*) and bathymetry (*depth and area*) setup | - |
| `&wq_setup` | Water Quality setup | *Disabled* |
| `&init_profiles` | Initial lake conditions with depths (eg. *temperature and salinity* ) | - |
| `&output` | Specification of output file details | - |

**Meteorological Configuration**

| Configuration Flags | Description | Activation|
| ---------------- |:----------|:-----------:|
| `met_sw = .true.` | Surface meteorological forcing | *Enabled* |
| `lw_type = 'LW_IN'` | Incident longwave radiation is provided in the meteorological data | *Enabled* |
| `subdaily = .true.` | Subdaily meteorological input setup switch (in *hourly timesteps*; `dt = 3600`) | *Enabled* |
| `rain_threshold = 0.01` | Require a minimum of 0.01m rainfall amount to trigger runoff from exposed lake banks | *Enabled* |
| `runoff_coef = 0.3` | Runoff coefficient constant to convert rainfall to runoff in exposed lake banks | *Enabled* |
| `&snowice` | Snow-ice lake dynamics setup | *Enabled* |
| `&bird_model` | Incorporation of *Bird Solar Radiation* model which theoretically computes solar radiation based on available data| *Enabled* |
| `&sed_heat` | Sediment heat dynamics setup | *Enabled* |

**Flow Configuration**

As neither inflow, outflow nor seepage were being configured, the lake is mainly filled with precipitation and runoff.


#### Input Data
Model input includes a time-series of hourly meteorological conditions in the [specified format and column order](http://aed.see.uwa.edu.au/research/models/GLM/downloads/AED_GLM_v2_0b0_20141025.pdf) (Table 1).

**Table 1**  Input data for simulation of Lake Sparkling.

| Input Data     | Filename   | Code Section |
| ---------------- |:----------:|:-----------:|
| meteorological | *nldas_driver.csv*| `&meteorology`|


### Example Output
Following each simulation, the model produces a .csv of time-series reservoir conditions detailing heat fluxes/water balance (*lake.csv*), an optional .csv of lake overflow, an optional .csv of specific depth time-series water quality values (*WQ_17*), along with a NetCDF file detailing the values of each in-lake variables with time and depth (*output.nc*). For simple time-series plots, users can extract the values directly from the .csv file; For advanced plots, user may load the *output.nc* into MATLAB to produce the following outputs :

![alt text](https://2tbruw-dm2305.files.1drv.com/y4m3JMVD4fSNFk8iONXU2Ea3qH_Jbtyy0G-sapXCIkgTY6x7HEoBmioqZKWnMLcl2jxrJQ5buV53WdChIwVCn6YeLW-EsaFwy_4S4khpDiA_qRN1Fv-EY8nH-ZwBupFwM1oa1nfhOEJ2F7U4Qpu20p32jH4mIjtQcy4svlfGb5xd7CZZb9edYmPeHULz6cwpp9rkEnsVgtL_rmQmTL8stZQm5T7dBL_D8W9_XuDvjQl3S4?width=1460&height=565&cropmode=none)
**Figure 1** Time-series Heat Fluxes of Sparkling Lake over 2 years

![alt text](https://1jbruw-dm2305.files.1drv.com/y4m72P8XDV24YkzmHK5n4juTOkTvfNLUxe4GJfXfQ-8x04PyD_uoMoTJbFV9XcfhIRFDV17C0zmlzmqOnZ4Tz8G_Xs4G2tV_39Z11Ei85t4oK2XQn64K_VroBYScY7Nu_yhWIR2QSFlNbJy7DBJP-qHk7O7BPHzlGPV3_S6WrnW_a1oJAiFlEiEOzVzRwJb6neK71hPkl-7E8_C8qCCEEosJa65NNWF6kiFFuHI9r4vreU?width=1460&height=565&cropmode=none)
![alt text](https://3dbruw-dm2305.files.1drv.com/y4m2b_LoDkY0Y-qy8LsC5mIzDb3l2FGO04KjTBbmZepm0XAd2SkWz3X-DdAehRQCAFJ-OCzuiEq5yLiVcaAtZlvIUClkUdaplYrhNO5qcCLQ4-m3mQwzWbU2IgvNJASUbV2ij6VwSgaLP3JtV5jwxzuk9hpmtEVz5rzHDCEPpnEoKDeOP8KHUnhK8s2ZNXbhyYFdm0_iTwvOEX4tjG1_sS9I_YNneyOvRZFLylBgBJOqZQ?width=1460&height=565&cropmode=none)
**Figure 2** Time-series Water Balance of Sparkling Lake over 2 years


![alt text](https://2ja1ag-dm2305.files.1drv.com/y4mVCP5u-6J_NoeXoOQYQsvmxRsCRZyL2ZXqMfKcrt2a9l9vRfkaY4jzh46ex8TzgBZfmDiwyVCtqtXUJ8tUCbeSYRSH8gxgkQO7XQY_6-cMy0C6kvfzzHopoPZRSP-yv8oH5QTp0QEmSAt4e9FyGdrJbbz2pzC0z51uYt3ypWhlmtkv2TsQrLtMyLH5g4tI5vxW7rsAKOYMGbM6pgwLzu5P-M7gGVhsh8VxFe-IjYSy1w?width=875&height=656&cropmode=none)
**Figure 3** Temperature-Depth contour plot of Sparkling Lake over 2 years


## Further Notes
- Users can switch off individual model components of interest by inserting `!` before the codes.
- Users can tweak the resolution of model simulation by adjusting `min_layer_thick` and `max_layer_thick`.
- Users can set output directory/filenames under `&output`, along with the option of exporting modelled data at different specified depths.
- Users can choose to incorporate AED2 water quality module by switching on `&wq_setup` component (i.e. remove `!` before the codes).

# Falling Creek Reservoir (FCR)

## Study Site
Falling Creek Reservoir (37.29 ºN, 79.81 ºW) is created by damming of Falling Creek in 1898 and is situated in Vinton, Virginia (USA).
The reservoir has a surface area of 0.119 km<sup>2</sup>, and is about 9.3 m deep.

## Model Setup
The model is set-up to simulate the hydrological domain of FCR for X years, from **2011-07-01** to **2013-07-01** (`&time`), with water balance and heat fluxes  based on the lake configuration and input data. Water quality functionality (AED2) is included in thesimulation (`&wq_setup`).


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
| `lw_type = 'LW_CC'` | Compute longwave radiation based on cloud cover data | *Enabled* |
| `subdaily = .true.` | Subdaily meteorological input setup switch (in *hourly timesteps*; `dt = 3600`) | *Enabled* |
| `&snowice` | Snow-ice lake dynamics setup | *Enabled* |

**Flow Configuration**

| Configuration Flags | Description | Activation |
| ---------------- |:----------|:-----------:|
| `subm_flag = .false.` | Configuration of submerged inflow; Disable to activate surface inflow | *Disabled* by default|

#### Input Data
Model inputs include a time-series of hourly meteorological conditions, 1 daily inflow, and 1 daily outflow in the [specified format and column order](http://aed.see.uwa.edu.au/research/models/GLM/downloads/AED_GLM_v2_0b0_20141025.pdf) (Table 1).

**Table 1**  Input data for simulation of Woods Lake.

| Input Data     | Filename   | Code Section |
| ---------------- |:----------:|:-----------:|
| meteorological | *Woods2002-2013_met.csv*| `&meteorology`|
| inflows | *inflow_inf1_2002_2013.csv* |`&inflow`|
| outflows | *outflow_inf1_1999_2014.csv*|`&outflow`|

### Example Output
Following each simulation, the model produces a .csv of time-series reservoir conditions detailing heat fluxes/water balance (*lake.csv*), an optional .csv of withdrawal outlet conditions (*outlet_00.csv*), an optional .csv of specific depth time-series water quality values (*WQ_2*), along with a NetCDF file detailing the values of each in-lake variables with time and depth (*output.nc*). For simple time-series plots, users can extract the values directly from the .csv file; 

## Further Notes
- Users can switch off individual model components of interest by inserting `!` before the codes.
- Users can tweak the resolution of model simulation by adjusting `min_layer_thick` and `max_layer_thick`.
- Users can set output directory/filenames under `&output`, along with the option of exporting modelled data at different specified depths.
- Users can choose to remove AED2 water quality module by switching off `&wq_setup` component (i.e. add `!` before the codes).

# *Grosse Dhuenn* Reservoir

## Study Site
*Grosse Dhuenn* is a [multi-purpose reservoir with an optimized withdrawal scheme](http://www.sciencedirect.com/science/article/pii/S0301479717302189) (51.07 ºN, 7.22 ºE) situated in a densely populated area of Cologne, Western Germany.
The reservoir has a surface area of 3.7501 km<sup>2</sup>, and is about 48 m deep.

## Model Setup
The model is set-up to simulate the hydrological domain of *Grosse Dhuenn* reservoir for 2 years, from **1996-01-01** to **1998-01-01** (`&time`), with water balance and heat fluxes [hypothetically calculated](http://aed.see.uwa.edu.au/research/models/GLM/downloads/AED_GLM_v2_0b0_20141025.pdf) based on the reservoir configuration and input data. Water quality functionality (AED2) is disabled for the simulation (`&wq_setup`).


#### Reservoir Configuration
The flexible model structure allow users to configure the switches of the individual model components, enabling the customization of the physical model, meteorological and flow conceptualisations.


**Physical Model Configuration**

| Configuration Flags | Description | Activation |
| ---------------- |:----------|:-----------:|
| `&morphometry` | Reservoir location (*latitude and longitude*) and bathymetry (*depth and area*) setup | - |
| `&wq_setup` | Water Quality setup | *Disabled* |
| `&init_profiles` | Initial reservoir conditions with depths (eg. *temperature and salinity* ) | - |
| `&output` | Specification of output file details | - |

**Meteorological Configuration**

| Configuration Flags | Description | Activation|
| ---------------- |:----------|:-----------:|
| `met_sw = .true.` | Surface meteorological forcing | *Enabled* |
| `lw_type = 'LW_CC'` | Compute longwave radiation based on cloud cover data | *Enabled* |
| `subdaily = .true.` | Subdaily meteorological input setup switch (in *hourly timesteps*; `dt = 3600`) | *Enabled* |
| `&bird_model` | Incorporation of *Bird Solar Radiation* model which theoretically computes solar radiation based on available data| *Enabled* |


**Flow Configuration**

| Configuration Flags | Description | Activation |
| ---------------- |:----------|:-----------:|
| `subm_flag = .false.` | Configuration of submerged inflow; Disable to activate surface inflow | *Disabled* by default|
| `flt_off_sw = .false.` | Configuration of floating offtake; Disable to allow users to specify the absolute elevation of groundwater withdrawal under `outl_elvs`; Can be switched on to enable adaptive offtake functionality  | *Disabled* by default |
| `seepage = .false.` | Deactivation of seepage processing | *Disabled* by default|


#### Input Data
Model inputs include a time-series of hourly meteorological conditions, 3 daily inflows, and 7 daily outflows in the [specified format and column order](http://aed.see.uwa.edu.au/research/models/GLM/downloads/AED_GLM_v2_0b0_20141025.pdf) (Table 1).

**Table 1**  Input data for simulation of *Groose Dhuenn* Reservoir.

| Input Data     | Filename   | Code Section |
| ---------------- |:----------:|:-----------:|
| meteorological | *met_hourly_cc_kb_1996_2014.csv*| `&meteorology`|
| inflows | *inflow1_v2_1996-2015_moving_4d_meanKB.csv*, *inflow2_v2_1996-2015_moving_4d_meanKB.csv*, *inflow3_v2_1996-2015_moving_4d_meanKB.csv*,|`&inflow`|
| outflows | *outflowdep_1v2_1996-2014.csv*, *outflowdep_2v2_1996-2014.csv*, *outflowdep_3v2_1996-2014.csv*, *outflowdep_4v2_1996-2014.csv*, *outflowdep_5v2_1996-2014.csv*, *outflowdep_6v2_1996-2014.csv*, *outflow_loos_v2_1996-2015.csv*|`&outflow`|

### Example Output
Following each simulation, the model produces a .csv of time-series reservoir conditions detailing heat fluxes/water balance (*lake.csv*), an optional .csv of specific depth time-series water quality values (*WQ_2*), along with a NetCDF file detailing the values of each in-lake variables with time and depth (*output.nc*). For simple time-series plots, users can extract the values directly from the .csv file; For advanced plots, user may load the *output.nc* into MATLAB to produce the following outputs :

![alt text](https://eexlxq-dm2305.files.1drv.com/y4meK9F-H3_xMIcTz3R9BUYUNOxT2XYPkLJy36pIQf9SwDYIgmYgXg3omF7o6Bu5E629fpXLXeb3fN-_-bFw9AxgzUvxtxrh7R_QL_rJL1q40hrjOUYm3MfbUtw30Ma5s-tbxp5fym5USvNOhBFtb7UQ2BXw8Gsp0lBa2AxHHiaEw7tJQ_9lp6vFxj26lnen7QmuTYU6fkmquWX835i3Z7qwsVYhQA57VgzQnFoaoPoM-k?width=1460&height=565&cropmode=none)
**Figure 1** Time-series Heat Fluxes of *Groose Dhuenn* Reservoir over 2 years

![alt text](https://fuxlxq-dm2305.files.1drv.com/y4mcCn3gualBc3K1WWBiaRMVzbegzeu5DLjVRjAKk-OA3GzRS1JCq6WACiFpYIHhbIJwFFOJj_ZM_6MtspAyBa2CXAlnyppmfLePbM5wtaC1jhOkY-eJjmgff-cuy7NeQ-VT6TOqbNT5ZL-ja6sqKuOCVMB73QwQukJtrZRMXjBS4qwF6GTTk3VgZnhAk-DMP0ApKr1ECZHL4lVQvJKdKvDBfs0d2h3pBVmhavqkkmcV28?width=1460&height=565&cropmode=none)
![alt text](https://foxlxq-dm2305.files.1drv.com/y4m95Le4Bb9BAwnOmTV2JRW7mo9hS-6j18l2NvG5zl2tRPIpBhlz41VdOFWqYzcKKMVvIkZy5H6B-514RSh_1I7-2ouxgDxc0w3jZ3Ty1h2d4x98FojpebeM8i_YHLeYLABuuA49bCkSGMr5T0QIFYp_NRBrJUyzQkLMFQfimoxVRVnqh6pd_iUNXuVP5r_5f5O__45nu3ollQI1frDWNkYlZcWL_YL0iilsW0KA4_6ydc?width=1460&height=565&cropmode=none)
**Figure 2** Time-series Water Balance of *Groose Dhuenn* Reservoir over 2 years


![alt text](https://epwaog-dm2305.files.1drv.com/y4mW6uUnc81glHf4V0vL6At-deUAs_Wxx8Wdy3PmIfAZ8DiJ-ysEeHJoAHBbgvPuC3Vl3S_E1k7iFtgqcL0-WDgQuuRBqIngr4D4iTKIVgcjO8BPBpFP8zwHQ35VJ3VmPoFQ8CgPhxUONW_qf8aAqnyM6C1nijltUnzzgSvs_bfjfJR870VACXVQowNoqPZoeO-dtcVNztjbcLWy6Cq9Ovgn4yybfYQlOwXjbyg4Oz_WDQ?width=875&height=656&cropmode=none)
**Figure 3** Temperature-Depth contour plot of *Groose Dhuenn* Reservoir over 2 years


## Further Notes
- Users can switch off individual model components of interest by inserting `!` before the codes.
- Users can tweak the resolution of model simulation by adjusting `min_layer_thick` and `max_layer_thick`.
- Users can set output directory/filenames under `&output`, along with the option of exporting modelled data at different specified depths.
- Users can choose to incorporate AED2 water quality module by switching on `&wq_setup` component (i.e. remove `!` before the codes).

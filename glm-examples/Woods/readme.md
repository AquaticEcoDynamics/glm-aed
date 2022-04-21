# Woods Lake

## Study Site
Woods Lake (42 ºS, 147 ºE) is created by [damming of Lake River](https://m.ifs.tas.gov.au/about-us/publications/woods-lake-brochure), and is situated in Tasmania.
The reservoir has a surface area of 12.4 km<sup>2</sup>, and is about 5.5 m deep.

## Model Setup
The model is set-up to simulate the hydrological domain of Woods Lake for 2 years, from **2011-07-01** to **2013-07-01** (`&time`), with water balance and heat fluxes [hypothetically calculated](http://aed.see.uwa.edu.au/research/models/GLM/downloads/AED_GLM_v2_0b0_20141025.pdf) based on the lake configuration and input data. Water quality functionality (AED2) is disabled for the simulation (`&wq_setup`).


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
| `&bird_model` | Incorporation of *Bird Solar Radiation* model which theoretically computes solar radiation based on available data| *Enabled* |

**Flow Configuration**

| Configuration Flags | Description | Activation |
| ---------------- |:----------|:-----------:|
| `subm_flag = .false.` | Configuration of submerged inflow; Disable to activate surface inflow | *Disabled* by default|
| `seepage = .false.` | Deactivation of seepage processing | *Disabled* by default|


#### Input Data
Model inputs include a time-series of hourly meteorological conditions, 1 daily inflow, and 1 daily outflow in the [specified format and column order](http://aed.see.uwa.edu.au/research/models/GLM/downloads/AED_GLM_v2_0b0_20141025.pdf) (Table 1).

**Table 1**  Input data for simulation of Woods Lake.

| Input Data     | Filename   | Code Section |
| ---------------- |:----------:|:-----------:|
| meteorological | *Woods2002-2013_met.csv*| `&meteorology`|
| inflows | *inflow_inf1_2002_2013.csv* |`&inflow`|
| outflows | *outflow_inf1_1999_2014.csv*|`&outflow`|

### Example Output
Following each simulation, the model produces a .csv of time-series reservoir conditions detailing heat fluxes/water balance (*lake.csv*), an optional .csv of withdrawal outlet conditions (*outlet_00.csv*), an optional .csv of specific depth time-series water quality values (*WQ_2*), along with a NetCDF file detailing the values of each in-lake variables with time and depth (*output.nc*). For simple time-series plots, users can extract the values directly from the .csv file; For advanced plots, user may load the *output.nc* into MATLAB to produce the following outputs :

![alt text](https://gpzrlw-dm2305.files.1drv.com/y4m1n5PmlM2J0jwdt5QfnIBTZc3aixyjwLj93AMO3zfdACQgPSuO2m1r9wgeGXt67EREY6wdawS51xkATHWF9v-d4b72IRiLWkJnvzp4WHvhikgi1LmG_GwMcbcTet06AdYzSdjGRmOiKHruDZ1-0iF0PzSGBOqV8PI-fGSgcLMWDB8T31y7Q9FpJcnpiWErVsoPUs1NpV_HypalDXmb7Gx9NoUsXc-Zwkv4aHVFDYPQn0?width=1460&height=565&cropmode=none)
**Figure 1** Time-series Heat Fluxes of Woods Lake over 2 years

![alt text](https://eezyqw-dm2305.files.1drv.com/y4mHdyrNmzTSEUs0j6tmf4xNJlA_5d8cFcAW1dORBYNtPDeYRYb-q9O1SBoHpTLelJilk8KKZZqjiT8XvFmBkdkDoKcqxXtC9HMDelx05s6HFluBhzlsXRUjTWQZ8dBapicU3uIZRn545ySwQFvrLBl52f0MJZG0v90JiUH5MVp4_s56hjh3e99FY9qKU-JchvfG5b17et5ILtIC_iyOG0IFi55gxTeysp2ivB0cgPHew8?width=1460&height=565&cropmode=none)
![alt text](https://euzyqw-dm2305.files.1drv.com/y4mmdaXxbEODEvvU72qYO_QVHqw4g1p5K-gv9BEfkACvn_ngzw5G7ptlBiycbtSNVBdCal2q9AP0x9WfIH31yTIxX66GfayyIod7REC8aMG_bLvqToS1O54NlOu9PD41lgkmBDqgYNdjutsBTbF9fxOLv9T4g2MkWqDMUKOwWwASSZGCSYaFff8iiukbJgc3cZphym7RQqpZ3VtV2KpDfCY3QCJpvyMSsxqxH4uiU2M5Nk?width=1460&height=565&cropmode=none)
**Figure 2** Time-series Water Balance of Woods Lake over 2 years


![alt text](https://fpxsda-dm2305.files.1drv.com/y4mhcTnLLAyNOIkX9-bPP_URFHn3cUIoVZgitdoUJSlYWC8G8Su9RjVk2_3RiH9LAjvbQ6Yj22zeefAIeRLuAjugYhaujOFDcvN-XZMC_6Dm7dvApV1ohU7F8n90yF6n8LHkPIM1HYljK1QfXUEjZ0WSvB77lsrAYkzEAv4mETfJeo3yYNOohsB8rXbIDSl0IK9XjNm_qFvnC6qwdK2p9qCrWv4EFdcVgpK54Y9RNTq2yU?width=875&height=656&cropmode=none)
**Figure 3** Temperature-Depth contour plot of Woods Lake over 2 years


## Further Notes
- Users can switch off individual model components of interest by inserting `!` before the codes.
- Users can tweak the resolution of model simulation by adjusting `min_layer_thick` and `max_layer_thick`.
- Users can set output directory/filenames under `&output`, along with the option of exporting modelled data at different specified depths.
- Users can choose to incorporate AED2 water quality module by switching on `&wq_setup` component (i.e. remove `!` before the codes).

# Ellen Brook Wetland Model

## Study Site
Ellen Brook is a [natural, ephemeral waterway](https://www.water.wa.gov.au/__data/assets/pdf_file/0004/8392/110152.pdf) that forms the largest sub-catchment (715 km<sup>2</sup>) within Swan Canning Catchment (35 ºS, 32 ºE). The catchment is situated adjacent to an agricultural land and urban settlements, with a history of [nutrient intervention and changed management practices](http://www.newwaterways.org.au/downloads/Resources%20-%20Policy%20and%20Guidelines/Government/WQIP/ellen-brook%20WQIP.pdf).
In this modelling study, the ephemeral wetland model covers about 0.345 km<sup>2</sup>, and is filled with precipitation during wet season (May to December).

## Model Setup
The model is set-up to simulate the wetland model of Ellen Brook catchment for 2 years, from **2010-01-26** to **2012-01-26** (`&time`), with water balance and heat fluxes [hypothetically calculated](http://aed.see.uwa.edu.au/research/models/GLM/downloads/AED_GLM_v2_0b0_20141025.pdf) based on the model configuration and input data. Water quality functionality (AED2) is disabled for the simulation (`&wq_setup`).


#### Wetland Configuration
The flexible model structure allow users to configure the switches of the individual model components, enabling the customization of the physical model, meteorological and flow conceptualisations.


**Physical Model Configuration**

| Configuration Flags | Description | Activation |
| ---------------- |:----------|:-----------:|
| `&morphometry` | Wetland location (*latitude and longitude*) and bathymetry (*depth and area*) setup | - |
| `&wq_setup` | Water Quality setup | *Disabled* |
| `&init_profiles` | Initial wetland conditions with depths (eg. *temperature and salinity* ) | - |
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
| `seepage = .true.` | With no inflow or outflow configured, activation of constant seepage rate is necessary to simulate the ephemeral wetland condition| Enabled|


#### Input Data
Model input includes a time-series of hourly meteorological conditions in the [specified format and column order](http://aed.see.uwa.edu.au/research/models/GLM/downloads/AED_GLM_v2_0b0_20141025.pdf) (Table 1).

**Table 1**  Input data for simulation of Ellen Brook wetland model

| Input Data     | Filename   | Code Section |
| ---------------- |:----------:|:-----------:|
| meteorological | *met_ebnr_2010_2013.csv*| `&meteorology`|


### Example Output
Following each simulation, the model produces a .csv of time-series wetland conditions detailing heat fluxes/water balance (*lake.csv*), an optional .csv of wetland overflow (*overflow.csv*), an optional .csv of specific depth time-series water quality values (*WQ_17*), along with a NetCDF file detailing the values of each variables with time and depth (*output.nc*). For simple time-series plots, users can extract the values directly from the .csv file; For advanced plots, user may load the *output.nc* into MATLAB to produce the following outputs :

![alt text](https://prynxw-dm2305.files.1drv.com/y4mKkpZCWDa2YRJqmXERJLSZuYt3p84dStueWZ9CueXAxx7Y8yZBdBSPQUPkMwgkI6i9kE2KibXmLh_PXPsOLIACnMR6MlqcrMhPSnzqWfvk7yLn6AsfMOEw-b8wk4DhRapW3hpuvq74sJxZLQ8_wxkVToo_VxrXA2UpOi2zG8jrIvy6SrYbP0E_8dz9BvNOabc6YmSTQOGtLHDrhFNgKz9I7C_GotP49KM64ZMQ6svcl8?width=1460&height=565&cropmode=none)
**Figure 1** Time-series Heat Fluxes of Ellen Brook wetland over 2 years

![alt text](https://qbxx3g-dm2305.files.1drv.com/y4m1UefTkazvo8IWwKQrdnQMjlb2ScGmEf5Ur79RdvQjttoGlZUYyA2t9WNaORFlwbAUQqwe8c_YA5TpzjCKmA7_2p6_EIirZHvzlbq3PnBubP5otWbfKPcQ_OG0OcBTFQ32RtdI3S9eZmvAQEuEXF_DE-SGGr82PQlPHV3s5YP4IjwngX9J200OH6X2sZcPrbrRAd-hzLJdgB5HMJp1_hAQRt1MG-vVFcpHBmf-qiakkw?width=1460&height=565&cropmode=none)
![alt text](https://o7xx3g-dm2305.files.1drv.com/y4mxmgy_oorP5BvYtWO9rlK1NZHrkJvBatd52xddxxDFYJCa4xgBNVApf8mvK-a4BawMbh2VXPA3dAk1vcoV5szNqJBPKeVmhICVUCblwaK3jmSZjPiyoB2BaQs-fECuezN6c-brgfWZXT3kip2UMiDgk9c2NHl7Ofl4D8QmW8RSaoVmm0ZEpcv3XFv6WdD-reD8jyQJt7w06uQ9MJriS-NCtrGxTxd-lM3JFv_DHh2ZQQ?width=1460&height=565&cropmode=none)
**Figure 2** Time-series Water Balance of Ellen Brook wetland over 2 years


![alt text](https://pby8aq-dm2305.files.1drv.com/y4mHn4rwGy4Wg3b5sY6VIQFWVd4DdzBPRyRBVMuZ4mBHfm4-cAVwH3rIWpUigdRtfwfg69rS_ivQRJxnBM79yv1iWtniXxxQzIYKmtWeZgA9GIS7z9yrK39ulzBabPL0EAR2VUSu7_QjVMpC_gPRuGVaDTMS-UCOviViXIPRGgw5k9-5xxmKjLfQ5QCWLeyRzNe3Rj126br8tHZ0AT2ItqofmM4oeYrnvjkBEu-00ePKOE?width=875&height=656&cropmode=none)
**Figure 3** Temperature-Depth contour plot of Ellen Brook wetland over 2 years


## Further Notes
- Users can switch off individual model components of interest by inserting `!` before the codes.
- Users can tweak the resolution of model simulation by adjusting `min_layer_thick` and `max_layer_thick`.
- Users can set output directory/filenames under `&output`, along with the option of exporting modelled data at different specified depths.
- Users can choose to incorporate AED2 water quality module by switching on `&wq_setup` component (i.e. remove `!` before the codes).

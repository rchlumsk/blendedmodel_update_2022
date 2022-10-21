#########################################################################                                  
# :FileType          rvc ASCII Raven rev337 (v3.1.0)                                                                             
# :WrittenBy         James Craig, Juliane Mai and Robert Chlumsky 
# AdditionalContributors  Bryan Tolson and Rezgar Arabzadeh
# :CreationDate      October 2021
#
# RAVEN run of WSC/USGS {props[id]} ({props[name]}) using weighted model options                                                             
#------------------------------------------------------------------------

# meteorological forcings
:Gauge
  :Latitude   {props[lat_deg]}
  :Longitude  {props[lon_deg]}
  :Elevation  {props[elevation_m]}
  #
  :RainCorrection       par_x33
  :SnowCorrection       par_x34
  #
  :RedirectToFile ../data_obs/{props[id]}_meteo_daily.rvt
:EndGauge

# observed streamflow
:RedirectToFile ../data_obs/{props[id]}_Qobs_daily.rvt

# observation weights
# :RedirectToFile data_obs/General-ObsWeights_Qdaily.rvt

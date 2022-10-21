#########################################################################                                  
# :FileType          rvc ASCII Raven rev337 (v3.1.0)                                                                             
# :WrittenBy         James Craig, Juliane Mai and Robert Chlumsky 
# AdditionalContributors  Bryan Tolson and Rezgar Arabzadeh
# :CreationDate      October 2021
#
# RAVEN run of WSC/USGS {props[id]} ({props[name]}) using weighted model options                                                    
#------------------------------------------------------------------------
#

:StartDate               1970-01-01 00:00:00 
:EndDate                 1984-01-01 00:00:00       
#:EndDate                 1990-01-01 00:00:00       
:TimeStep                1.0                                                                                   
:Method                  ORDERED_SERIES 

:SoilModel               SOIL_MULTILAYER 3

:Evaporation           PET_BLENDED
# :BlendedPETWeights [PET method 1] [wt1] [PET method 2] [wt2] …
# :BlendedPETWeights [PET method 1] [rn1] [PET method 2] ... [rnN-1] [PET method N]
:BlendedPETWeights PET_GRANGERGRAY par_x76 PET_HAMON par_x77 PET_PENMAN_MONTEITH
# :BlendedPETWeights PET_GRANGERGRAY {par_[nw76]} PET_HAMON {par_[nw77]} PET_PENMAN_MONTEITH

:PotentialMeltMethod           POTMELT_BLENDED
# :BlendedPotMeltWeights [POTMELT method 1] [wt1] [POTMELT method 2] [wt2] …
# :BlendedPotMeltWeights [POTMELT method 1] [rn1] [POTMELT method 2] ... [rnN-1] [POTMELT method N]
:BlendedPotMeltWeights POTMELT_HMETS par_x79 POTMELT_RESTRICTED 
# :BlendedPotMeltWeights POTMELT_HMETS {par_[nw79]} POTMELT_RESTRICTED 

:RainSnowFraction        RAINSNOW_HBV        # RAINSNOW_DATA
#:SWRadiationMethod      SW_RAD_NONE         # commented out - defaults to SW_RAD_DEFAULT

:PrecipIceptFract   PRECIP_ICEPT_USER

:CatchmentRoute          ROUTE_DUMP
:Routing                 ROUTE_NONE 

:Alias DELAYED_RUNOFF CONVOLUTION[1] 

:HydrologicProcesses
  :Precipitation                 RAVEN_DEFAULT           ATMOS_PRECIP   MULTIPLE 
  :CanopyDrip                    CANDRIP_RUTTER          CANOPY         PONDED_WATER
  :Abstraction                   ABST_PERCENTAGE         PONDED_WATER   DEPRESSION
  :OpenWaterEvaporation          OPEN_WATER_EVAP         DEPRESSION     ATMOSPHERE
  :CanopyEvaporation             CANEVP_MAXIMUM          CANOPY         ATMOSPHERE
  :CanopySnowEvap                CANEVP_MAXIMUM          CANOPY_SNOW    ATMOSPHERE
  :Seepage                       SEEP_LINEAR             DEPRESSION     SOIL[1]
  :Infiltration    INF_HMETS               PONDED_WATER   MULTIPLE 
         :Overflow      OVERFLOW_RAVEN          SOIL[0]        DELAYED_RUNOFF
   :ProcessGroup #quickflow/interflow group
                :Baseflow        BASE_POWER_LAW          SOIL[0]        SURFACE_WATER
                :Baseflow        BASE_THRESH_POWER       SOIL[0]        SURFACE_WATER 
  :EndProcessGroup CALCULATE_WTS par_x68 
  :Percolation                   PERC_LINEAR             SOIL[0]        SOIL[1]         # recharge
  :CapillaryRise                 CRISE_HBV               SOIL[1]        SOIL[0]
  :Overflow                      OVERFLOW_RAVEN          SOIL[1]        DELAYED_RUNOFF
  :Percolation                   PERC_LINEAR             SOIL[1]        SOIL[2]         # loss to deep gw
  :CapillaryRise                 CRISE_HBV               SOIL[2]        SOIL[1]
  :ProcessGroup #evaporation group
                :SoilEvaporation SOILEVAP_ALL            SOIL[0]        ATMOSPHERE      # AET
                :SoilEvaporation SOILEVAP_ROOT           SOIL[0]        ATMOSPHERE      # AET
				:SoilEvaporation SOILEVAP_SEQUEN         SOIL[0]        ATMOSPHERE      # AET
  :EndProcessGroup CALCULATE_WTS  par_x70  par_x71
  :Convolve                      CONVOL_GAMMA            CONVOLUTION[0] SURFACE_WATER   # 'surface runoff'
  :Convolve                      CONVOL_GAMMA_2          DELAYED_RUNOFF SURFACE_WATER   # 'delayed runoff'
    :ProcessGroup #baseflow group
                :Baseflow        BASE_POWER_LAW          SOIL[1]        SURFACE_WATER
				:Baseflow        BASE_THRESH_POWER       SOIL[1]        SURFACE_WATER
  :EndProcessGroup CALCULATE_WTS  par_x72 
  :SnowBalance     SNOBAL_HBV              MULTIPLE       MULTIPLE
:EndHydrologicProcesses
#---------------------------------------------------------
# Output Options
#

:EvaluationPeriod CALIBRATION 1972-01-01 1983-12-31  
#:EvaluationPeriod VALIDATION 1984-01-01 1989-12-31  

:EvaluationMetrics KLING_GUPTA
:SilentMode
:SuppressOutput
:DontWriteWatershedStorage


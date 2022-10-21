#########################################################################                                  
# :FileType          rvc ASCII Raven rev337 (v3.1.0)                                                                             
# :WrittenBy         James Craig, Juliane Mai and Robert Chlumsky 
# AdditionalContributors  Bryan Tolson and Rezgar Arabzadeh
# :CreationDate      October 2021
#
# RAVEN run of WSC/USGS {props[id]} ({props[name]}) using weighted model options                                                                
#------------------------------------------------------------------------                                 
#

# tied parameters:
# (it is important for OSTRICH to find every parameter place holder somewhere in this file)
# (without this "par_x(25)" and "par_x(14)" and "par_x(10)" wouldn't be detectable)
#    par_sum_x24_x25 = {dpar[sum_x24_x25]} =  par_x24 + par_x25 = {par[x24]} + {par[x25]}
## (not used)   par_sum_x13_x14 = {dpar[sum_x13_x14]} =  par_x13 + par_x14 = {par[x13]} + {par[x14]}
#    par_sum_x09_x10 = {dpar[sum_x09_x10]} =  par_x09 + par_x10 = {par[x09]} + {par[x10]}
#    par_pow_x04     = {dpar[pow_x04]}     =  10^(par_x04)       = 10^{par[x04]}
#    par_pow_x11     = {dpar[pow_x11]}     =  10^(par_x11)       = 10^{par[x11]}
#    par_pow_x37     = {dpar[pow_x37]}     =  10^(par_x37)       = 10^{par[x37]}
#    par_pow_x40     = {dpar[pow_x40]}     =  10^(par_x40)       = 10^{par[x40]}
#    par_half_x25    = {dpar[half_x25]}    =  par_x25 / 2        = {par[x25]} / 2   


#-----------------------------------------------------------------
# Soil Classes
#-----------------------------------------------------------------
:SoilClasses
  :Attributes,
  :Units,
  TOPSOIL,
  PHREATIC,  
  DEEP_GW
:EndSoilClasses

#-----------------------------------------------------------------
# Land Use Classes
#-----------------------------------------------------------------
:LandUseClasses, 
  :Attributes,        IMPERM,    FOREST_COV, 
       :Units,          frac,          frac, 
       FOREST,           0.0, {props[forest_frac]},  
:EndLandUseClasses

#-----------------------------------------------------------------
# Vegetation Classes
#-----------------------------------------------------------------
:VegetationClasses, 
  :Attributes,        MAX_HT,       MAX_LAI, MAX_LEAF_COND, 
       :Units,             m,          none,      mm_per_s, 
       FOREST,             4,             5,             5,     
:EndVegetationClasses

#-----------------------------------------------------------------
# Soil Profiles
#-----------------------------------------------------------------
:SoilProfiles
         LAKE, 0
         ROCK, 0
  DEFAULT_P, 3, TOPSOIL, par_x29, PHREATIC, par_x30, DEEP_GW, 1e6 
# DEFAULT_P, 3, TOPSOIL,      x(29), PHREATIC,      x(30), DEEP_GW, 1e6
:EndSoilProfiles

#-----------------------------------------------------------------
# Terrain Classes
#-----------------------------------------------------------------
# :TerrainClasses
#   :Attributes,        hillslope_len, drainage_dens,            lambda,       
#        :Units,                   ??,            ??,                ??
#     DEFAULT_T,                  1.0,           1.0,        par_x07    
#   DEFAULT_T,                  1.0,           1.0,        {par[x07]}    
#                                                     TOPMODEL_LAMBDA x(7)  
# :EndTerrainClasses

#-----------------------------------------------------------------
# Global Parameters
#-----------------------------------------------------------------
:GlobalParameter        RAINSNOW_TEMP   par_x31 
:GlobalParameter        RAINSNOW_DELTA  par_x32
:GlobalParameter         SNOW_SWI_MIN par_x13            # x(13)    
:GlobalParameter         SNOW_SWI_MAX par_sum_x13_x14    # x(13)+x(14) 
# note: SNOW_SWI_MAX calculated as par_x13 + par_x14
:GlobalParameter     SWI_REDUCT_COEFF par_x15            # x(15)
:GlobalParameter             SNOW_SWI par_x19            # x(19)
# :GlobalParameter             MAX_SWE_SURFACE par_x48     # x(48)
#:GlobalParameter      TOC_MULTIPLIER 1.0                # 

#-----------------------------------------------------------------
# Soil Parameters
#-----------------------------------------------------------------
:SoilParameterList
  :Parameters,        POROSITY,      HYDRAUL_COND, WETTING_FRONT_PSI,  PERC_COEFF,  PET_CORRECTION,  BASEFLOW_COEFF,          B_EXP,   MAX_BASEFLOW_RATE,  BASEFLOW_N,   FIELD_CAPACITY,   SAT_WILT,  BASEFLOW_THRESH, MAX_CAP_RISE_RATE,
       :Units,               -,      		mm/d,				 -mm,        1/d,               -,             1/d,           mm/d,  
      TOPSOIL,             1.0,       par_pow_x37, 		     par_x36, 	 par_x28,      par_x08, 	    par_pow_x04, 	par_x02, 	  		 par_x05,     par_x06, 	par_sum_x09_x10, 	par_x09,		par_x38,    par_x53,
      PHREATIC,             1.0,     		  0.0, 			     0.0, 	 par_x35,          0.0,         par_pow_x11,            0.0,         	 par_x44,     par_x12,              0.0,        0.0,		par_x39,    par_x54,
      DEEP_GW,             1.0,      		  0.0,               0.0,		 0.0,		   0.0,          	    0.0,            0.0,            	 0.0,         0.0,              0.0,        0.0,		   0.0,      0.0,
# 	  TOPSOIL,             1.0,      {par[x28]},      {par[x08]}, {dpar[pow_x04]}, {par[x02]}, {par[x03]},        {par[x05]}, {par[x06]}, {dpar[sum_x09_x10]}, {par[x09]},
#     PHREATIC,             1.0,             0.0,             0.0, {dpar[pow_x11]},        0.0,        0.0,               0.0, {par[x12]},                 0.0,        0.0,   
#     DEEP_GW,             1.0,             0.0,             0.0,             0.0,        0.0,        0.0,               0.0,        0.0,                 0.0,        0.0,
:EndSoilParameterList

# note: TOPSOIL FIELD_CAPACITY calculated as par_x9 + par_x10
# note: TOPSOIL BASEFLOW_COEFF calculated as  10^ (par_x04)
# note: PHREATIC BASEFLOW_COEFF calculated as  10^ (par_x11)
# note: TOPSOIL HYDRAULIC_COND calculated as  10^ (par_x37)


#-----------------------------------------------------------------
# Land Use Parameters
#-----------------------------------------------------------------
:LandUseParameterList
  :Parameters, MIN_MELT_FACTOR,     MAX_MELT_FACTOR,    MELT_FACTOR,   DD_MELT_TEMP,  DD_AGGRADATION, REFREEZE_FACTOR, REFREEZE_EXP, DD_REFREEZE_TEMP, HMETS_RUNOFF_COEFF, DEP_SEEP_K, ABST_PERCENT, DEP_MAX,  AET_COEFF,
       :Units,          mm/d/C,              mm/d/C,         mm/d/C,               C,            1/mm,          mm/d/C,            -,                C,                  -,        1/d,            -,    [mm],     -,
    [DEFAULT],      par_x24, 		par_sum_x24_x25, par_sum_x24_halfx25,      par_x26,      par_x27,      			par_x18,   par_x17,       par_x16,         par_x01,        par_pow_x40,      par_x41, par_x42,    par_x43,
#   [DEFAULT],      {par[x24]}, {dpar[sum_x24_x25]}, {dpar[sum_x24_halfx25]},       {par[x26]},      {par[x27]},      {par[x18]},   {par[x17]},       {par[x16]},         {par[x01]},  {dpar[pow_x40]}, {par[x41]}, {par[x42]},  {par[x43]}, 
#                        x(24),         x(24)+x(25),  x(24)+0.5*x(25),          x(26),           x(27),           x(18),        x(17),            x(16),              x(01),        
:EndLandUseParameterList
:LandUseParameterList
  :Parameters,   GAMMA_SHAPE,     GAMMA_SCALE,    GAMMA_SHAPE2,    GAMMA_SCALE2,    FOREST_SPARSENESS,   ROUGHNESS,   WIND_EXPOSURE,   
       :Units,             -,               -,               -,               -,                    -,            m,            -,        
    [DEFAULT],    par_x20,       	par_x21,          par_x22,      	par_x23,      par_x48,      			   0.5,          par_x45,    
#   [DEFAULT],    {par[x20]},       {par[x21]},      {par[x22]},      {par[x23]},     0.0,  	     		   0.5,      {par[x45]},   
    #                  x(20),           x(21),           x(22),           x(23),      0.0, 	      			   0.5,         x(45),      
:EndLandUseParameterList

## GAMMA_SCALE:   par_x21  = {par[x21]}    =  par_one / par_ratio_x21       = 1 / {dpar[ratio_x21]}
## GAMMA_SCALE2:  par_x23  = {par[x23]}    =  par_one / par_ratio_x23       = 1 / {dpar[ratio_x23]} 

#-----------------------------------------------------------------
# Vegetation Parameters
#-----------------------------------------------------------------

## tied parameters - assume that MAX_SNOW_CAPACITY is a fixed ratio of MAX_CAPACITY, and
### 					same proportion applies to relating SNOW_ICEPT_PCT and RAIN_ICEPT_PCT
### constant multiplier = {par[x56]}  =  par_x56
### SNOW_ICEPT_PCT    = RAIN_ICEPT_PCT*constant   = par_x49*par_x56 = {par[x49]}*{par[x56]} = par_prod_x49_x56
### MAX_SNOW_CAPACITY = MAX_CAPACITY*constant     = par_x52*par_x56 = {par[x52]}*{par[x56]} = par_prod_x52_x56
#
:VegetationParameterList
  :Parameters,  RAIN_ICEPT_PCT,  SNOW_ICEPT_PCT,    SAI_HT_RATIO,  DRIP_PROPORTION,   MAX_CAPACITY,  MAX_SNOW_CAPACITY
       :Units,               -,               -,               -,           -,            mm,                  mm,
    [DEFAULT],        par_x49,   par_prod_x49_x56,          0.0,        par_x51,       par_x52,         par_prod_x52_x56
:EndVegetationParameterList

:SeasonalRelativeLAI
  FOREST, par_sum_RLAI_01,par_sum_RLAI_02,par_sum_RLAI_03,par_sum_RLAI_04,par_sum_RLAI_05,par_sum_RLAI_06,par_sum_RLAI_07,par_sum_RLAI_08,par_sum_RLAI_09,par_sum_RLAI_10,par_sum_RLAI_11,par_sum_RLAI_12,
:EndSeasonalRelativeLAI
:SeasonalRelativeHeight
  FOREST, 1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0
:EndSeasonalRelativeHeight

## tied parameter for SeasonalRelativeLAI
## par_x55 = {par[x55]} = proportion of prescribed decrease in relative LAI for each month
### January relative LAI   = 1 - par[x55]*0.8 = 1 - par_x55*0.8 = par_sum_RLAI_01
### February relative LAI  = 1 - par[x55]*0.8 = 1 - par_x55*0.8 = par_sum_RLAI_02
### March relative LAI     = 1 - par[x55]*0.7 = 1 - par_x55*0.7 = par_sum_RLAI_03
### April relative LAI     = 1 - par[x55]*0.5 = 1 - par_x55*0.5 = par_sum_RLAI_04
### May relative LAI       = 1 - par[x55]*0.3 = 1 - par_x55*0.3 = par_sum_RLAI_05
### June relative LAI      = 1 - par[x55]*0.1 = 1 - par_x55*0.1 = par_sum_RLAI_06
### July relative LAI      = 1 - par[x55]*0.0 = 1 - par_x55*0.0 = par_sum_RLAI_07
### August relative LAI    = 1 - par[x55]*0.0 = 1 - par_x55*0.0 = par_sum_RLAI_08
### September relative LAI = 1 - par[x55]*0.2 = 1 - par_x55*0.2 = par_sum_RLAI_09
### October relative LAI   = 1 - par[x55]*0.4 = 1 - par_x55*0.4 = par_sum_RLAI_10
### November relative LAI  = 1 - par[x55]*0.6 = 1 - par_x55*0.6 = par_sum_RLAI_11
### December relative LAI  = 1 - par[x55]*0.7 = 1 - par_x55*0.7 = par_sum_RLAI_12

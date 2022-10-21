#########################################################################                                  
# :FileType          rvc ASCII Raven rev337 (v3.1.0)                                                                             
# :WrittenBy         James Craig, Juliane Mai and Robert Chlumsky 
# AdditionalContributors  Bryan Tolson and Rezgar Arabzadeh
# :CreationDate      October 2021
#
# RAVEN run of WSC/USGS {props[id]} ({props[name]}) using weighted model options                                                             
#------------------------------------------------------------------------                            
#                                                                                                           
#                                                                                                               
:SubBasins                                                                                                              
        :Attributes     NAME    DOWNSTREAM_ID   PROFILE   REACH_LENGTH    GAUGED                                                          
        :Units          none    none            none      km              none                                                                                                    
        1,       {props[id]},   -1,             NONE,     _AUTO,          1
:EndSubBasins                                                                                                                           
                                                                                                                
:HRUs                                                                                                           
        :Attributes     AREA    ELEVATION  LATITUDE    LONGITUDE  BASIN_ID  LAND_USE_CLASS  VEG_CLASS SOIL_PROFILE AQUIFER_PROFILE TERRAIN_CLASS    SLOPE   ASPECT  
        :Units           km2            m       deg          deg      none            none       none         none            none          none      deg      deg     
                 1    {props[area_km2]} {props[elevation_m]} {props[lat_deg]} {props[lon_deg]}         1          FOREST     FOREST    DEFAULT_P         [NONE]     [NONE]      {props[slope_deg]}        0
:EndHRUs

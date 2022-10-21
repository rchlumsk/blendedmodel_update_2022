  
### set array number ----
# note that this needs to be consistent with that in the sub_array_run.sh file
number_arrays <- 5 # number of replicates per mopex set
mopex_set <- seq(13,14) # seq(1,12) # mopex catchments to create folders for, index of basin_chars! (not actual IDs)
mvset <- c(36) # blended model version number  
    
### set other parameters    
randomstart <- TRUE # (default)
randomseed <- TRUE
maxiterations <- 3
purge <- FALSE # TRUE # whether to delete folder if it already exists
copy_foldernames_only <- FALSE # whether to only write directory names to .txt (skip copy file block entirely)
# model start/end, evaluation period?

### end of manual entry for setup 
##### ---====---===---===---

## read other things
basin_chars <- read.table("basin_physical_characteristics.txt", sep=";", header=TRUE,
                          colClasses=c("character","character",rep("numeric",6)))

# number_actual_array
number_arrays*length(mopex_set)*length(mvset)

  ### copy out folders ----

if (!copy_foldernames_only) {
  
  for (modelv in mvset) {
    
    ## copy ostIn_base.txt to _calibration_000_000_000 folder
    system(sprintf("cp -rp ./basetemplates/ostIn_base_modelversion%03d.txt _calibration_000_000_000/ostIn_base.txt",modelv))
    
    for (catchid in mopex_set) {
      for (arrayid in 1:number_arrays) {
        
        new_folder <- sprintf("calibration_%03d_%03d_%03d",modelv,catchid,arrayid)
        
        if (dir.exists(new_folder) & purge) {unlink(new_folder, recursive = TRUE)}
        
        system(sprintf("cp -rp _calibration_000_000_000 %s",new_folder))
        
        ### update ostIn.txt 
        ### random seed and max iterations in each ostin_base.txt file in each folder ----
        
        # base file
        ffbase <- sprintf("./%s/ostIn_base.txt",new_folder)
        basefile <- readLines(ffbase)
        
        # initialize writing new file
        ffwrite <- sprintf("./%s/ostIn.txt",new_folder)
        fw <- file(ffwrite,"w+")
        ## maxiterations
        basefile <- gsub(x=basefile, pattern="MaxIterations 1", 
                         replacement=sprintf("MaxIterations %i", maxiterations))
        ## randomseed
        if (randomseed) {
          basefile <- gsub(x=basefile, pattern="#RandomSeed 123456789", 
                           replacement=sprintf("RandomSeed %i", 20201114*arrayid+catchid))
        }
        ## randomstart
        if (!randomstart) {
          basefile <- gsub(x=basefile, pattern="UseRandomParamValues", 
                           replacement="UseInitialParamValues")
        }
        ## write ostIn.txt
        writeLines(basefile,fw)
        close(fw)
        
        ### update template files for folder
        
        ### Write rvi.tpl file ----
        ffbase <- sprintf("./basetemplates/modelname_modelversion%03d.rvi.tpl",modelv)
        basefile <- readLines(ffbase)
        
        basefile <- gsub(x=basefile, pattern=as.character("{props[id]}"), 
                         replacement=sprintf("%s",basin_chars$basin_id[catchid]),
                         fixed=TRUE)
        basefile <- gsub(x=basefile, pattern=as.character("{props[name]}"), 
                         replacement=as.character(basin_chars$basin_name[catchid]),
                         fixed=TRUE)
        
        ffwrite <- sprintf("./%s/templates/modelname.rvi.tpl",new_folder)
        fw <- file(ffwrite,"w+")
        writeLines(basefile,fw)
        close(fw)
          
        ### Write rvc.tpl file ----
        ffbase <- sprintf("./basetemplates/modelname_modelversion%03d.rvc.tpl",modelv)
        basefile <- readLines(ffbase)
        
        basefile <- gsub(x=basefile, pattern=as.character("{props[id]}"), 
                         replacement=sprintf("%s",basin_chars$basin_id[catchid]),
                         fixed=T)
        basefile <- gsub(x=basefile, pattern=as.character("{props[name]}"), 
                         replacement=as.character(basin_chars$basin_name[catchid]),
                         fixed=T)
        
        ffwrite <- sprintf("./%s/templates/modelname.rvc.tpl",new_folder) 
        fw <- file(ffwrite,"w+")
        writeLines(basefile,fw)
        close(fw)
        
        ### Write rvp.tpl file ----
        ffbase <- sprintf("./basetemplates/modelname_modelversion%03d.rvp.tpl",modelv)
        basefile <- readLines(ffbase)
        
        basefile <- gsub(x=basefile, pattern=as.character("{props[id]}"), 
                         replacement=sprintf("%s",basin_chars$basin_id[catchid]),
                         fixed=T)
        basefile <- gsub(x=basefile, pattern=as.character("{props[name]}"), 
                         replacement=as.character(basin_chars$basin_name[catchid]),
                         fixed=T)
        basefile <- gsub(x=basefile, pattern=as.character("{props[forest_frac]}"), 
                         replacement=as.character(basin_chars$forest_frac[catchid]),
                         fixed=T)
        
        ffwrite <- sprintf("./%s/templates/modelname.rvp.tpl",new_folder) 
        fw <- file(ffwrite,"w+")
        writeLines(basefile,fw)
        close(fw)
        
        
        ### Write rvt.tpl file ----
        ffbase <- sprintf("./basetemplates/modelname_modelversion%03d.rvt.tpl",modelv)
        basefile <- readLines(ffbase)
        
        basefile <- gsub(x=basefile, pattern=as.character("{props[id]}"), 
                         replacement=sprintf("%s",basin_chars$basin_id[catchid]),
                         fixed=T)
        basefile <- gsub(x=basefile, pattern=as.character("{props[name]}"), 
                         replacement=as.character(basin_chars$basin_name[catchid]),
                         fixed=T)
        basefile <- gsub(x=basefile, pattern=as.character("{props[lat_deg]}"), 
                         replacement=as.character(basin_chars$lat[catchid]),
                         fixed=T)
        basefile <- gsub(x=basefile, pattern=as.character("{props[lon_deg]}"), 
                         replacement=as.character(basin_chars$lon[catchid]),
                         fixed=T)
        basefile <- gsub(x=basefile, pattern=as.character("{props[elevation_m]}"), 
                         replacement=as.character(basin_chars$elevation_m[catchid]),
                         fixed=T)
        
        ffwrite <- sprintf("./%s/templates/modelname.rvt.tpl",new_folder) 
        fw <- file(ffwrite,"w+")
        writeLines(basefile,fw)
        close(fw)
        
        ### Write rvh file ----
        ffbase <- sprintf("./basetemplates/modelname_modelversion%03d.rvh.tpl",modelv)
        basefile <- readLines(ffbase)
        
        basefile <- gsub(x=basefile, pattern=as.character("{props[id]}"), 
                         replacement=sprintf("%s",basin_chars$basin_id[catchid]),
                         fixed=T)
        basefile <- gsub(x=basefile, pattern=as.character("{props[name]}"), 
                         replacement=as.character(basin_chars$basin_name[catchid]),
                         fixed=T)
        basefile <- gsub(x=basefile, pattern=as.character("{props[lat_deg]}"), 
                         replacement=as.character(basin_chars$lat[catchid]),
                         fixed=T)
        basefile <- gsub(x=basefile, pattern=as.character("{props[lon_deg]}"), 
                         replacement=as.character(basin_chars$lon[catchid]),
                         fixed=T)
        basefile <- gsub(x=basefile, pattern=as.character("{props[elevation_m]}"), 
                         replacement=as.character(basin_chars$elevation_m[catchid]),
                         fixed=T)
        basefile <- gsub(x=basefile, pattern=as.character("{props[area_km2]}"), 
                         replacement=as.character(basin_chars$area_km2[catchid]),
                         fixed=T)
        basefile <- gsub(x=basefile, pattern=as.character("{props[slope_deg]}"), 
                         replacement=as.character(basin_chars$slope_deg[catchid]),
                         fixed=T)
        
        # ffwrite <- sprintf("./%s/templates/modelname.rvh.tpl",new_folder) 
        ffwrite <- sprintf("./%s/model/modelname.rvh",new_folder) 
        fw <- file(ffwrite,"w+")
        writeLines(basefile,fw)
        close(fw)
        
        ### Copy relevent data_obs
        # system(sprintf("cp ./data_obs/General-ObsWeights_Qdaily.rvt ./%s/data_obs/.",new_folder)) # use evaluation period instead
        system(sprintf("cp -rp ./data_obs/%s* ./%s/data_obs/.",basin_chars$basin_id[catchid],new_folder))
        
      }
    }
  }
}


### write in folder list text file ----
fw <- file("folder_list.txt","w+")
for (modelv in mvset) {
  for (j in mopex_set) {
    for (i in 1:number_arrays) {
      writeLines(sprintf("calibration_%03d_%03d_%03d",modelv,j,i),fw)
    }
  }
}
close(fw)


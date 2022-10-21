
options(stringsAsFactors = F)

# run_mode <- as.numeric(read.table("run_mode.txt"))
# # run_mode <- 1 # XXX TEMP
# if (run_mode == 1) {
#   number_models <- 3 # debugging and testing with only 3 models
# } else {
#   number_models <- 110
# }

# library(dplyr)
# library()

# dd <- dir(pattern="^calibration_*")

## set for specific model versions to process
dd <- c(dir(pattern="^calibration_000")
)

# diagnostics df
df <- data.frame(matrix(nrow=length(dd), ncol=5))
names(df) <- c("modelversion","watershedID","iteration","calib_kge","valid_kge")

missing_files <- c()

# param df
for (i in 1:length(dd)) {
  ss <- as.numeric(unlist(strsplit(dd[i], split="_"))[-1])
  ff <- sprintf("./%s/best/Diagnostics_validation.csv",dd[i])
  if (file.exists(ff)) {
    temp <- read.csv(ff)
    calib_kge <- temp[1,3]
    valid_kge <- temp[2,3]
    df[i, ] <- c(ss,calib_kge,valid_kge) 
  } else {
    missing_files <- c(missing_files, ff)
    warning(sprintf("file %s is missing (iteration %i)", ff, i))
  }
}

# filter for additional watersheds
df <- df[df$watershedID %in% seq(13,24),]

write.csv(df, file="../results_summary/blended_modelv000_catch13-24_diagnostics_KGE_20220518.csv",
          quote=FALSE, row.names=FALSE)




## read in parameters

tempdd <- data.frame(matrix(data=as.numeric(unlist(strsplit(dd, split="_"))), 
                            ncol=4, byrow = TRUE))[,-1]
names(tempdd) <- c("modelversion","watershedID","iteration")

missing_files <- c()

for (modelv in unique(tempdd$modelversion)) {
  
  temp <- tempdd[tempdd$modelversion==modelv,]
  
  params <- read.csv(sprintf("./calibration_%03d_%03d_%03d/best/bestparams.csv",
                             modelv, temp$watershedID[1], temp$iteration[1]))
  param_df <- data.frame(matrix(nrow=nrow(temp),
                                ncol=nrow(params)))
  names(param_df) <- params$param
  
  for (i in 1:nrow(temp)) {
  
    ff <- sprintf("./calibration_%03d_%03d_%03d/best/bestparams.csv",
                    modelv, temp$watershedID[i], temp$iteration[i])
    
    if (file.exists(ff)) {
      params <- read.csv(ff)
      param_df[i, ] <- params$optvalue
    } else {
      missing_files <- c(missing_files, ff)
      warning(sprintf("file %s is missing (iteration %i)", ff, i))
    }
  }
  
  write.csv(x=cbind(temp,param_df),
            file=sprintf("../results_summary/blended_modelv%03d_optparameters_catch13-24_20220518.csv",modelv),
            quote=FALSE, row.names=FALSE)
}


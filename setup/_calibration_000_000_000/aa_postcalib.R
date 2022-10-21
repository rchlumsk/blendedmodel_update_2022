
## read in OstOutput0.txt and process the file to write 
## calibration runs and final parameter set to file

# iter <- as.numeric(read.csv("iter.txt", header=F)[1])

ffbase <- "OstOutput0.txt"
basefile <- readLines(ffbase)
setup_start <- which(basefile == "Ostrich Setup")
setup_stop <- grep(pattern="Penalty Method              :", basefile)+1
param_start <- which(basefile == "Optimal Parameter Set")
param_stop <- which(basefile == "Summary of Constraints")-1

# write new file - OstOutput0
# ffwrite <- sprintf("calib_runs/best_%i/OstOutput0_%i.txt",iter,iter)
ffwrite <- "./best/OstOutput0_trim.txt"
fw <- file(ffwrite,"w+")
writeLines(basefile[setup_start:setup_stop], fw)
writeLines(basefile[param_start:param_stop], fw)
close(fw)

# write new file - optimal parameters
temp <- strsplit(basefile[(param_start+2):(param_stop-1)], split=":")
df <- data.frame(matrix(nrow=length(temp), ncol=2))
names(df) <- c("param","optvalue")
for (i in 1:nrow(df)) {
  df[i,] <- trimws(temp[[i]])
}
df[,2] <- as.numeric(df[,2])

ffwrite <- "./best/bestparams.csv"
write.csv(df,ffwrite,
          quote=FALSE,row.names = FALSE)


## copy best model files
system("cp -rp best/modelname* model/.")


## rewrite model period for validation

### Rewrite rvi file ----
ffbase <- "./model/modelname.rvi"
basefile <- readLines(ffbase)

# comment out old EndDate, uncomment new one
basefile <- gsub(x=basefile, 
                 pattern    =":EndDate                 1984-01-01 00:00:00", 
                 replacement="#:EndDate                 1984-01-01 00:00:00", 
                 fixed=TRUE)
basefile <- gsub(x=basefile, 
                 pattern    ="#:EndDate                 1990-01-01 00:00:00", 
                 replacement=":EndDate                 1990-01-01 00:00:00", 
                 fixed=TRUE)

# uncomment VALIDATION evaluation period
basefile <- gsub(x=basefile, 
                 pattern    ="#:EvaluationPeriod VALIDATION 1984-01-01 1989-12-31", 
                 replacement=":EvaluationPeriod VALIDATION 1984-01-01 1989-12-31", 
                 fixed=TRUE)

ffwrite <- ffbase
fw <- file(ffwrite,"w+")
writeLines(basefile,fw)
close(fw)

## re-run Raven model
system("./ost_raven.sh")

## copy Diagnostics file to best
system("cp -rp model/output/Diagnostics.csv best/Diagnostics_validation.csv")

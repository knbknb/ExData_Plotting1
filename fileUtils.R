# fileUtils.R
###################################################################
## a simple helper function for testing and setting the working directory
# input: a dirname string
check_directory <- function(dirname){
        rcflag = FALSE
        if (file.exists(dirname)){
                message(sprintf("Good: Subdir '%s'' found. Assuming it contains *.txt data files with the Electrical Power-Consumption dataset.", dirname))
        } else {
                ## Set home directory
                d = "/home/knut/Documents/coursera/datascience/getting_data/twitter"
                if(! file.exists(d)){
                        warning(sprintf("Directory '%s' not found. Enter full path to its parent directory on your computer.", d ), immediate.=TRUE)
                        n <- FALSE;
                        while(! n){
                                cat("Path (Ctrl-C to exit):")
                                d <- readLines(con="stdin", n=1)
                                n <- ifelse(! file.exists(d),FALSE, TRUE)
                                #if(n == "0"){break}  # breaks when hit enter
                                
                        }
                        setwd(d)
                        warning(paste0("Now inside working directory", getwd()), immediate.=TRUE)
                } else {
                        setwd(d)
                }
                rcflag = TRUE
        }
        
        
        if(! file.exists(dirname)){      
                stop(paste0("Subdir '", dirname, "' not found. Must already exist and contain *.txt data files. Create the directory and put unzipped files there."))
                
                #message("You can run helper script download-and-extract.R to download and unzip necessary data files")
                #source("download-and-extract.R")
                #message(paste0("Subdir ", dirname, " not found,. Must already exist and contain data files."))
                #message("You can run helper script download-and-extract.R to download and unzip necessary data files")
                #source("download-and-extract.R")
        }
        rcflag
        
}


###################################################################
# these functions do a lot of heavy lifting (memory-intensive file I/O)
#
# Input: a data frame of file names (full paths)
# output: a single data frame containing contents of files, all were read in all and appended  
# WORKS!  returns df with 561 columns/variables
read_data <- function(df, colclasses=NA, nRow=NA){
        do.call("rbind",lapply(df ,
                               FUN=function(files){
                                       read.table(files, nrows=nRow, colClasses = colclasses, sep=";", na.strings="?", stringsAsFactors=FALSE, header=TRUE)}))
}


###################################################################
## a simple helper function reporting on presence of NA Values in numeric data frame
# input: colsums of data frame, rowcount, colcount
msg_parse_result <- function(colsums, r, c){
        #rndv <- as.integer(abs(rnorm(n=10)) * 10)
        #colsums[rndv]<- rndv
        #colsums
        good.flag <- all(colsums == 0)
        msg <- sprintf("There are  %s NA values in your dataset of length n = %s rows x %s columns",  sum(colsums[colsums != 0]),r, c)
        if(! good.flag){
                warning(paste0("Bad! ", msg))
        } else{
                message(paste0("Good! No NAs found. ", msg))
        }
}
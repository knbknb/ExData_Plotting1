# plot1.R
# expects that wc pogram is available (is a standard tool on linux/unix)
# plotting code starts in line 60
#
setwd("/home/knut/Documents/coursera/datascience/4-exploratory-research/project1/ExData_Plotting1/")
source("fileUtils.R")


library(lubridate)
###################################################################
###################################################################
# Main part of script
###################################################################
###################################################################
# make sure there is no rounding in display
options(digits=15)

## We assume file has been downloaded and extracted already
subdir <- "powerdata"


dataset_found <- check_directory(subdir)
###read in all filenames (as full paths) extracted from the zip-file, will filter this list of strings many times, later on.
file.list <- list.files(subdir, full.names=TRUE, recursive=TRUE, pattern="*.txt")


n <- 1
datafiles.sampled <- head(file.list,n)
#data.sampled <- read_data_fwf(datafiles.sampled)
#to get datatypes of columns, sample 2 rows from 1 file first
nr <- 3

data.sampled <- read_data(datafiles.sampled, nRow=nr)
data.sampled 
classes <- sapply(data.sampled[1,], class)

n <- length(file.list)
datafile.use <- head(file.list,n)
datafile.use 
f <- datafile.use[[1]]

# assume unix operating system
nr <- system(paste0("wc -l " , f))

#convert  datatypes in date and time columns
data <- read_data(datafile.use, colclasses=classes, nRow=nr)
data$Date <- as.Date(data$Date, format="%d/%m/%Y")
data$Time <- hms(data$Time)

data2 <- data[data$Date >= as.Date("2007-02-01") & data$Date <= as.Date("2007-02-02"), ]

data2$dt <- data2$Date + data2$Time
labels <- c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")


data2$wday <- ordered(as.POSIXlt(data2$dt)$wday + 1, levels=1:7, labels=labels)

# check that there are no NAs in the dataset
msg_parse_result(colSums(is.na(data2)), nrow(data2),  length(names(data2))) 
message(sprintf("Data as read from input files (contains many more rows and  columns, ncol= %i)", ncol(data)))
head(data2[,1:11])


#create plots  -----------------------------------------------------------------------------------------



png(file="plot3.png", width=480, height=480)


with (
        data2,
        plot(dt, Global_active_power, type="n", ylab="Energy Sub Metering", xlab="", ylim = c(0, max(Sub_metering_1)))
)

with(data2,  lines(dt, Sub_metering_1, col="black"))
with(data2,  lines(dt, Sub_metering_2, col="red"))
with(data2,  lines(dt, Sub_metering_3, col="blue"))
legend("topright", col=c("black", "red", "blue"), legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), lty=1)
dev.off()

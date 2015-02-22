# sourcing script ("load_data.R") to load the data - so I can create the file just sourcing it.
# But in the homework, you must create a .R that create the plot from nothing, so you need to write all
# the lines every time
# source("load_data.R")

#####################################################################
###############   PART 1: DOWNLOAD THE DATA #########################
#####################################################################

# create proper directory about Exploratory Data Analysis course
# and set the new Working Directory
orig_wd <- getwd()
main_dir <- "Exploratory_Data_Analysis"
sub_dir <- "Ex_Plotting2"
if(!file.exists(main_dir)){dir.create(main_dir)}
setwd(file.path(orig_wd, main_dir))
if(!file.exists(sub_dir)){dir.create(sub_dir)}
setwd(file.path(orig_wd, main_dir, sub_dir))

# download file data
if(!file.exists("./NEIdata.zip"))
{
    url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
    download.file(url, destfile="./NEIdata.zip")
    unzip("./NEIdata.zip")
    print(list.files())
}

# Check if both data exist in the environment. If not, load the data.
if (!"NEI_Data" %in% ls()) {
    NEI_Data <- readRDS("./summarySCC_PM25.rds")
}
if (!"source_Data" %in% ls()) {
    source_Data <- readRDS("./Source_Classification_Code.rds")
}

message("In the current directory")
print(file.path(orig_wd, main_dir, sub_dir))
message("the following files are present:")
print(list.files())

#####################################################################
###############   PART 2: CREATING THE PLOT #########################
#####################################################################

library(dplyr)
library(ggplot2)
library(ggthemes)

# Using "dplyr" package, I filtered the data with the correct "fips" = 24510 (Baltimore)
baltimore <- filter(NEI_Data, fips == "24510")

# creating "plot5.png" using basic plot.
# Dimensions are not specified, so I used standard 480px * 480px
# next question os about finding emissions by ALL motor combustion-related sources, (similar to plot4.R)
# so I searched "motor" using grep inside "Short.name" column
par("mar"=c(5.1, 4.5, 4.1, 2.1))
png(filename = "./plot5.png",
    width=480, 
    height=480, 
    units='px'
)

motor <- grep("motor", source_Data$Short.Name, ignore.case = T)
motor <- source_Data[motor, ]
motor <- baltimore[baltimore$SCC %in% motor$SCC, ]
motorEmissions <- aggregate(motor$Emissions, list(motor$year), FUN = "sum")

plot(motorEmissions,
     type = "o",
     xlab = "Year", 
     main = "Total Emissions From Motor Vehicle Sources\n from 1999 to 2008 in Baltimore City", 
     ylab = expression('Total PM'[2.5]*" Emission"))

# always close graph device!
dev.off()

# reset original Working Directory
setwd(orig_wd)
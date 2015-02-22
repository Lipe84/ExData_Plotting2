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

# creating "plot4.png" using basic plot.
# Dimensions are not specified, so I used standard 480px * 480px
# next question os about finding emissions by ALL coal combustion-related sources, 
# so I searched "coal" using grep inside "Short.name" column
par("mar"=c(5.1, 4.5, 4.1, 2.1))
png(filename = "./plot4.png",
    width=480, 
    height=480, 
    units='px'
)
coal <- grep("coal", source_Data$Short.Name, ignore.case = T)
coal <- source_Data[coal, ]
coal <- NEI_Data[NEI_Data$SCC %in% coal$SCC, ]
coalEmissions <- aggregate(coal$Emissions, list(coal$year), FUN = "sum")

plot(coalEmissions,
     type = "o",
     xlab = "Year", 
     main = "Total Emissions From Coal Combustion-related\n Sources from 1999 to 2008", 
     ylab = expression('Total PM'[2.5]*" Emission"))

# always close graph device!
dev.off()

# reset original Working Directory
setwd(orig_wd)
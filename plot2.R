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
library(graphics)

# Using "dplyr" package, I filtered the data with the correct "fips" = 24510 (Baltimore)
# and then I made the same code in "plot1.R"
baltimore <- filter(NEI_Data, fips == "24510")
total_baltimore <- aggregate(baltimore$Emissions, by=list(baltimore$year), FUN=sum)

# creating "plot2.png" using base plotting sistem.
# Dimensions are not specified, so I used standard 480px * 480px
# TIPS: * type="o" to plot using lines AND dots
#       * /n to break the main title in multiple lines
png(filename = "./plot2.png",
    width=480, 
    height=480, 
    units='px', 
    bg="transparent")

plot(total_baltimore, 
     type="o",
     xlab="Year",
     ylab=expression('Total Emissions of PM'[2.5]*'  (tons)'),
     main=expression('Total Emissions of PM'[2.5]~'pollutant in BALTIMORE CITY') 
    )
# always close graph device!
dev.off()

# reset original Working Directory
setwd(orig_wd)
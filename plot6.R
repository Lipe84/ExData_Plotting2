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

# subsetting original data, creating Baltimore_LA dataset:
# Baltimore = fips 24510 AND Los Angeles County, California fips == "06037"
Baltimore_LA <- NEI_Data[NEI_Data$fips == "24510"|NEI_Data$fips == "06037", ]

# creating "plot6.png" using ggplot2.
# Dimensions are not specified, so I used standard 480px * 480px
# Compare emissions from motor vehicle sources in Baltimore City with emissions in Los Angeles
par("mar"=c(5.1, 4.5, 4.1, 2.1))
png(filename = "./plot6.png", 
    width = 480, height = 480, 
    units = "px", bg = "transparent")

motor <- grep("motor", source_Data$Short.Name, ignore.case = T)
motor <- source_Data[motor, ]
motor <- Baltimore_LA[Baltimore_LA$SCC %in% motor$SCC, ]

graph <- ggplot(motor, aes(year, Emissions, color = fips))
graph <- graph + geom_line(stat = "summary", fun.y = "sum") + geom_point(stat = "summary", fun.y = "sum", size=8) +
         xlab("Year") +
         ylab(expression('Total Emissions PM'[2.5]*' (tons)')) +
         ggtitle("Comparison of Total Emissions From Motor\n Vehicle Sources in Baltimore City\n and Los Angeles County from 1999 to 2008") +
# next command is to change names in the legend
         scale_colour_discrete(name = "Group", label = c("Los Angeles","Baltimore"))
print(graph)

# always close graph device!
dev.off()

# reset original Working Directory
setwd(orig_wd)
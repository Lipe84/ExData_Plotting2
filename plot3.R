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
# and then made the same code in "plot1.R"
baltimore <- filter(NEI_Data, fips == "24510")

# creating "plot3.png" using ggplot2.
# Dimensions are not specified, so I used standard 480px * 480px
par("mar"=c(5.1, 4.5, 4.1, 2.1))
png(filename = "./plot3.png",
    width=480, 
    height=480, 
    units='px'
    )
# there are some commented lines of code, where I was trying new parameter for plotting
# this graph is not very clear in layout, but I wanted to change and to try something new ;)
graph <- ggplot(baltimore, aes(x=year, y=Emissions, color=type))
graph <- graph + geom_line(stat = "summary", fun.y = "sum") + geom_point(stat = "summary", fun.y = "sum", size=8)
graph <- graph + xlab("Year") + 
                 ylab(expression('Total Emissions PM'[2.5]*' (tons)')) +
                 ggtitle(expression('Total Emissions of PM'[2.5]~'pollutant in BALTIMORE CITY'))
    #graph <- graph + theme(panel.background=element_rect(fill="khaki1"))
    #graph <- graph + theme(panel.grid.major = element_line(colour = "orange", size=0.5))
    #graph <- graph + theme(panel.grid.minor = element_line(colour = "blue"))
    #graph <- graph + scale_color_manual(values=c("dodgerblue4", "darkolivegreen4", "darkorchid3", "goldenrod1"))
graph <- graph + theme_economist() + scale_colour_economist()
print(graph)

# always close graph device!
dev.off()

# reset original Working Directory
setwd(orig_wd)
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
message("In the current directory")
print(file.path(orig_wd, main_dir, sub_dir))
message("the following files are present:")
print(list.files())

# load the data and source classification
NEI_Data <- readRDS("./summarySCC_PM25.rds")
source_Data <- readRDS("./Source_Classification_Code.rds")

# reset original Working Directory
setwd(orig_wd)
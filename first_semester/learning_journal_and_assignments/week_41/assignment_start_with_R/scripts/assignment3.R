# 3) Inside your R Project (.Rproj), install the 'tidyverse' package and use the download.file() and read_csv() function to 
# read the SAFI_clean.csv dataset into your R project as 'interviews' digital object 
# (see instructions in https://datacarpentry.org/r-socialsci/setup.html and 'Starting with Data' section). 
# Take a screenshot of your RStudio interface showing 
# a) the script you used to create the object, 
# b) the 'interviews' object in the Environment and the 
# c) structure of your R project in the bottom right Files pane. 
# Save the screenshot as an image and put it in your AUID_lastname_firstname repository inside our Github organisation 
# (github.com/Digital-Methods-HASS). 
# Place here the URL leading to the screenshot in your repository.

#Install tidyverse package
install.packages("tidyverse")

#Access tidyverse package
library(tidyverse)

#Download SAFI_Clean into the data folder
download.file("https://ndownloader.figshare.com/files/11492171",
              "data/SAFI_clean.csv", mode = "wb")

#Create a digital object called "interviews" containing the dataset SAFI_Clean and repalce "NULL" with NA.
interviews <- read_csv("data/SAFI_clean.csv", na = "NULL")

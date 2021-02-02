getwd()
download.file("https://ndownloader.figshare.com/files/11492171",
              "data/SAFI_clean.csv", mode = "wb")
library(tidyverse)
(area_hectares <- 1.0)
area_hectares
area_hectares*2.47
area_hectares <- 2.5
area_hectares
area_acres <- 2.47 * area_hectares
area_acres
area_hectares <- 50
area_acres
# Hashtags laver funktioner.
length <- 1
width <- 1
area <- length * width
area
length <- 18
area
sqrt(9)
round(2.3242)
help(round)
round(2.32424, 2)
round(2, 3.141959)
round(digits = 2, x = 3.145352)
hh_members <- c(3,7,10,6)
respondent_wall_type <- c("muddaub", "bruntbricks", "sunbricks")
length(hh_members)
class(respondent_wall_type)
str(hh_members)

possesions <- c("bicycle", "radio", "television")
possesions <- c(possesions, "mobile_phone")
possesions <- c("car", possesions)
length(possesions)
str(possesions)

num_char <- c(1, 2, 3, "a")
num_logical <- c(1, 2, 3, TRUE)
char_logical <- c("a", "b", "c", TRUE)
tricky <- c(1, 2, 3, "4")

num_char
num_logical
tricky
char_logical
possesions[4]
possesions[2:4]
possesions[2,4]
possesions [c(2, 3, 1, 3, 1, 2, 3, 4)]
possesions[c(5, 4, 3, 2, 1)]
possesions[c(1, 3, 5)]
hh_members[hh_members>7]
rooms <- c(2, 1, 1, na, 4)
mean(rooms)

# Week 5
download.file("https://ndownloader.figshare.com/files/11492171",
              "data/SAFI_clean.csv", mode = "wb") #Download fil
interviews <- read_csv("data/SAFI_clean.csv") #gem filen i et objekt
class(interviews)#Hvilken datatype er dette? (Hvs tbl så er det en tibble)
#En tipple er en lille del af datasættet




# Load relevant libraries -------------------------------------------------
library(tidyverse) #Cleaning data
library(lubridate) #Cleaning Dates
library(zoo) #Dealing with na's

# Make list of candidates a tibble ------------------------------------------------
candidates <- read.csv(file = "./data/candidates_since_1960.csv", sep = ";") #Load csv
candidates <- tibble(candidates) %>%  #make data frame a tibble.
  mutate(last_name = toupper(last_name)) #Make all names uppercase


# Save transcripts as csv and create a tibble --------------------------------------------------------------
all_debates <- read.csv("./data/all_debates_raw.csv") #load csv
all_debates <- tibble(all_debates) #make data frame a tibble

# Clean names in debate column ----------------------------------------------
#Functions that cleans names by replacing an existing string with a new string
clean_dates <- function(dataset, old_pattern, new_replacement) {
  mutate_if(dataset, #Only mutate if the provided data is a string.
            is.character,
            str_replace_all, pattern = old_pattern, replacement = new_replacement)
}

#Find the wrong names
wrong_dates <- all_debates %>% 
  filter(!grepl("[A-Za-z]+-\\d+-\\d+", date)) %>%
  select(date) %>% 
  unique()

#Remove translations page 
all_debates <- all_debates[!(all_debates$date == "/voter-education/debate-transcripts/2000-debate-transcripts-translations/"),]

# Replace wrong dates with correct date ------------------------------------
all_debates <- clean_dates(all_debates, old_pattern = "voter-education/debate-transcripts/vice-presidential-debate-at-the-university-of-utah-in-salt-lake-city-utah/",
                           new_replacement = "october-7-2020")

all_debates <- clean_dates(all_debates, old_pattern ="/voter-education/debate-transcripts/2008-debate-transcript/",
                           new_replacement = "september-26-2008")

all_debates <- clean_dates(all_debates, old_pattern ="/voter-education/debate-transcripts/2008-debate-transcript-2/",
                           new_replacement = "october-2-2008")

# Make "date" a proper date with different columns for day, month and year ------------------------------------------------
all_debates <- all_debates %>% 
  mutate(date = mdy(date)) %>% 
  mutate(day = day(date),
         month = month(date),
         year = year(date)
  )

# Find all names and save as a tibble --------------------------------------------------------------------------------
last_name <- str_extract(all_debates$text, "^[A-Za-z]+:|^M[RS]\\..+:") %>% #Find name
  str_extract("[A-Za-z]+:") %>% #Remove MR. and MS.
  str_extract("[A-Za-z]+") #Remove semicolon
last_name <- tibble(last_name) #Make last_name a tibble

# bind column to all debates and fill out NA's---------------------------------------------------------
all_debates <- cbind(all_debates, last_name)
all_debates <- na.locf(all_debates)

#make all last_names uppercase ----------------------------------------------------------------------------------------
all_debates %>% 
  mutate(last_name = toupper(last_name))

#Combine the tibble with candidates and the debates by last_name and year ---------------------------------------------
all_debates <- left_join(all_debates, candidates, by = c("last_name" = "last_name", "year" = "year"))
all_debates[is.na(all_debates)] <- "not_a_candidate" #fill na's

# Remove the names from the text --------------------------------------------------------------------------------------
 all_debates <- all_debates %>%
   mutate(text = str_remove(text, "^[A-Z]+:|^M[RS]\\..+:"))

# reorder columns ----------------------------------------------------------------------------------------------------
all_debates <- all_debates %>% 
  relocate(last_name, .before = text)

all_debates <- all_debates %>% 
  relocate(first_name, .before = last_name)


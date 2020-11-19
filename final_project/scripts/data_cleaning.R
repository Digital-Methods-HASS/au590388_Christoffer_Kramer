
# Load relevant libraries -------------------------------------------------
library(tidyverse)
library(tidytext)
library(dplyr)
library(zoo)
library(stringr)
library(naniar)
library(lubridate)
# Make list of candidates a tibble ------------------------------------------------
candidates <- read.csv(file = "data/candidates_since_1960.csv", sep = ";")
candidates <- tibble(candidates) %>% 
  mutate(last_name = toupper(last_name))



# Save transcripts as csv and create a tibble --------------------------------------------------------------
write.csv(all_debates, "data/all_debates.csv", row.names=FALSE)
all_debates <- read.csv("data/all_debates.csv")
all_debates <- tibble(all_debates)



# Clean names in debate column ----------------------------------------------
#Functions that cleans names by replacing an existing string with a new string
clean_names <- function(dataset, old_pattern, new_replacement) {
  mutate_if(dataset,
            is.character,
            str_replace_all, pattern = old_pattern, replacement = new_replacement)
}

#Find the wrong names
wrong_names <- debate_names[grep("[A-Za-z]+-\\d+-\\d+", debate_names, invert = TRUE)]

#Remove translations page from list of names and the dataset
debate_names <- debate_names[!(debate_names == "/voter-education/debate-transcripts/2000-debate-transcripts-translations/")]
all_debates <- all_debates[!(all_debates$date == "/voter-education/debate-transcripts/2000-debate-transcripts-translations/"),]

#Make a list of correct names
right_names <- c("october-7-2020", "september-26-2008", "october-2-2008", "september-26-2008")   

i <- 0 #Index
#Loop through every wrong name and replace it with a name from the vector "right_names" in the dataset and the vector with names
for (name in wrong_names) {
  i <- i+1  
  all_debates <- clean_names(all_debates, old_pattern = name, new_replacement = right_names[i])
  debate_names[name] <- right_names[i] 
}


# Make "date" a proper date with different columns for day, month and year ------------------------------------------------
all_debates <- all_debates %>% 
  mutate(date = mdy(date)) %>% 
  mutate(day = day(date),
         month = month(date),
         year = year(date)
  )

# Find all names and save as a tibble --------------------------------------------------------------------------------
last_name <- str_extract(all_debates$text, "^[A-Z]+:") %>% 
  str_extract("[A-Z]+")
last_name <- tibble(last_name)


# bind column to all debates and fill out every cell in last_name, make all last_names uppercase ------------------------------------------------------------------------------------------
all_debates <- cbind(all_debates, last_name)
all_debates <- na.locf(all_debates)
all_debates %>% 
  mutate(last_name = toupper(last_name))

#Combine the tibble with candidates and the debates by last_name and year ---------------------------------------------
all_debates <- left_join(all_debates, candidates, by = c("last_name" = "last_name", "year" = "year"))
all_debates[is.na(all_debates)] <- "not_a_candidate" #fill na's

# Remove the names from the text --------------------------------------------------------------------------------------
all_debates <- all_debates %>%  
  mutate(text = str_remove(text, "^[A-Z]+:"))

# reorder columns ----------------------------------------------------------------------------------------------------
all_debates <- all_debates %>% 
  relocate(last_name, .before = text)
all_debates <- all_debates %>% 
  relocate(first_name, .before = last_name)

view(all_debates)

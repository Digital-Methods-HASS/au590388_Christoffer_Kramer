
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
#SOME OF THESE SHOULD BE AF FUNCTION
debate_names #Do all debates have proper names?

all_debates <- mutate_if(all_debates,
    is.character,
    str_replace_all, pattern = "/voter-education/debate-transcripts/2008-debate-transcript/", replacement = "september-26-2008"
  ) 

all_debates <- mutate_if(all_debates,
                         is.character,
                         str_replace_all, pattern = "/voter-education/debate-transcripts/2008-debate-transcript-2/", replacement = "october-2-2008"
)

all_debates <- mutate_if(all_debates,
                         is.character,
                         str_replace_all, pattern = "/voter-education/debate-transcripts/vice-presidential-debate-at-the-university-of-utah-in-salt-lake-city-utah/", replacement = "october-7-2020"
)
all_debates <- all_debates[!(all_debates$date == "/voter-education/debate-transcripts/2000-debate-transcripts-translations/"),]


# Make "date" a proper date with lubridate --------------------------------
all_debates <- all_debates %>% 
  mutate(date = mdy(date))


# Find all names and save as a tibble ----------------------------------
last_name <- str_extract(all_debates$text, "^[A-Z]+:") %>% 
  str_extract("[A-Z]+")
last_name <- tibble(last_name)


# bind column to all debates, left JOIN candidate tibble -----------------------------------------------------------
all_debates <- cbind(all_debates, last_name)
all_debates <- na.locf(all_debates)
all_debates %>% 
  mutate(last_name = toupper(last_name))

test <- all_debates %>% 
  mutate(day = day(date),
         month = month(date),
         year = year(date)
         )

view(test)

all_debates <- left_join(all_debates, candidates, by = c("last_name" = "last_name", "year" == year(date)))

all_debates$position[all_debates$last_name == "WALLACE" & all_debates$date == "september-29-2020"] <- NA
all_debates$party[all_debates$last_name == "WALLACE" & all_debates$date == "september-29-2020"] <- NA

all_debates[is.na(all_debates)] <- "not_a_candidate"

all_debates <- all_debates %>%  
  mutate(text = str_remove(text, "^[A-Z]+:"))

# reorder columns ---------------------------------------------------------
all_debates <- all_debates %>% 
  relocate(last_name, .before = text)
# Replace with NA where name=WALLACE and debate=september-29-2020 -------------

# Make "date" a proper date with lubridate --------------------------------
all_debates <- all_debates %>% 
  mutate(date = mdy(date))

 view(all_debates)

# 
# test <- all_debates %>% 
#    select(last_name, date) %>% 
#     distinct() %>%
#    group_by(last_name) %>% 
#    summarise(n = n()) %>% 
#    filter(n > 2)
# 
# view(test) 
# 
# test <- all_debates %>% 
#   select(last_name, date) %>% 
#   filter(last_name == "BUSH") %>% 
#   distinct()
# 
# test


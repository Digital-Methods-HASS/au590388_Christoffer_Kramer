
# Load libraries ----------------------------------------------------------
library(rvest) 
library(dplyr) 
library(tidyr)
library(tidyverse)


# Scrape Debate function --------------------------------------------------
scrape_debates <- function(website) { 
  p_html <-  read_html(website) %>% 
    html_nodes("p") %>% 
    html_text() 
  
  vect_p_html <- c(p_html) #Save the output in a vector.
}


# Get and store links to debates ---------------------------------------------------
link_html <- read_html("https://www.debates.org/voter-education/debate-transcripts/") %>% 
  html_nodes("blockquote") %>% 
  html_children() %>% 
  html_nodes("a")  %>%
  html_attr("href")



vect_link <- c(link_html) #save the output in a vector
vect_link #Check output

#Clean messy links
vect_link[1] <- "/voter-education/debate-transcripts/september-29-2020-debate-transcript/"
vect_link[2] <- "/voter-education/debate-transcripts/vice-presidential-debate-at-the-university-of-utah-in-salt-lake-city-utah/"



# Loop through the links and store the content ----------------------------
debate_names <-NULL 
all_debates <- tibble()

for (link in vect_link[!is.na(vect_link)]) { 

  name <- str_extract(link, "[A-Za-z]+-\\d+-\\d+")
  
 if(is.na(name)) { 
   
  name <- str_extract(link, ".+")
  
 }
  
  debate_names <- append(debate_names, name) 
  
  website <- paste0("https://www.debates.org/", link) 
  debate <- scrape_debates(website)
  debate <- tibble(line = 1:length(debate), text = debate, date = name) 
  all_debates <- bind_rows(all_debates, debate)
}

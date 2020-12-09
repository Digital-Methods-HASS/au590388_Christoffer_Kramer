### Web scrape ###

# Load libraries ----------------------------------------------------------
library(rvest) #web scraping
library(tidyverse) #data cleaning


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

#Clean messy links----------------------------------------------------------------
vect_link[1] <- "/voter-education/debate-transcripts/september-29-2020-debate-transcript/"
vect_link[2] <- "/voter-education/debate-transcripts/vice-presidential-debate-at-the-university-of-utah-in-salt-lake-city-utah/"
vect_link[3] <- "/voter-education/debate-transcripts/october-22-2020-debate-transcript/"

# Loop through the links and store the content ----------------------------
all_debates_raw <- tibble()

for (link in vect_link[!is.na(vect_link)]) {
  date <- str_extract(link, "[A-Za-z]+-\\d+-\\d+")
  
  if(is.na(date)) {
    
    date <- str_extract(link, ".+")
    
  } #end if
  
  website <- paste0("https://www.debates.org/", link)
  debate <- scrape_debates(website) #create an object storing the transcript
  debate <- tibble(line = 1:length(debate), text = debate, date = date)
  all_debates_raw <- bind_rows(all_debates_raw, debate) #row bind the transcript to all_debates 
} #end loop

write.csv(all_debates_raw, "./data/all_debates_raw.csv", row.names=FALSE) #create csv

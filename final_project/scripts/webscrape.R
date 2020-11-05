library(rvest) 
library(dplyr) 
library(tidyr)
library(stringr)
library(janitor)
library(tidyverse)
library(tidytext)
library(ggplot2)
library(janeaustenr)

scrape_debates <- function(website) { #Create a function called scrape_debates
  p_html <-  read_html(website) %>%  #Create an object which contains the parameter "website" and is read as a html file
    html_nodes("p") %>% #Grab all <p> elements in the html file.
    html_text() #Parse the result as text.
  
  vect_p_html <- c(p_html) #Save the output in a vector.
}

test_debate <- scrape_debates("https://www.debates.org/voter-education/debate-transcripts/2008-debate-transcript/")
tail(scrape_debates("https://www.debates.org/voter-education/debate-transcripts/2008-debate-transcript/"))
test_debate <- tibble(line = 1:length(test_debate), text = debate, debate = "2008-debate-manually")
link_html <- read_html("https://www.debates.org/voter-education/debate-transcripts/") %>% 
  html_nodes("blockquote") %>% #Grab the blockqoute elements
  html_children() %>% #Navigate to the blockqoute's children.
  html_node("a")  %>% #Grab <a> elements
  html_attr("href") #Grab <a> elements which contains a hyperlink.

vect_link <- c(link_html) #save the output in a vector

vect_link

debate_names <-NULL #Create an empty object

for (link in vect_link[!is.na(vect_link)]) { #For every link in the vector "vect_link" (Na excluded")
  
  name <- str_extract(link, "[A-Za-z]+-\\d+-\\d+") #Create an object called name, set the value to be the regex match.
  
  if(is.na(name)) { #If name is NA
    name <- str_extract(link, ".+") #Set name's value to be the same as the current link
  }
  
 # debate_names = append(debate_names, paste("debate_",name, sep = "")) #Add the object "name" to the vector "debate_names"
  
  website <- paste0("https://www.debates.org/", link) #Create an object called "website".
  debate <- scrape_debates(website) #Scrape data from the website and save it in an object called "debate"
  debate <- tibble(line = 1:length(debate), text = debate, debate = name) #Make "debate" a tibble, so it can be text-mined
 debate_names <- append(debate_names, assign(paste("debate_", name, sep = ""), debate)) #Create an object with the same name as the element in "debate_names" which contains the value of debate.

}


for (debate in debate_names) {
  

  rbind(test_debate, debate)
  
  
  
}

view(test_debate)

debate_names
`debate_/voter-education/debate-transcripts/2008-debate-transcript-2/`

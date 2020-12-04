
# Load libraries ----------------------------------------------------------
library(tidyverse)
library(tidytext)
library(ggplot2)
library(ggwordcloud)
library(wordcloud)
library(reshape2)

# Function for saving PDF -------------------------------------------------
save_plot_pdf <- function(name, path_destination = "./plots/", width_value = 8.26, height_value = 11.69){
  dev.copy(pdf, paste(path_destination, name, ".pdf", sep = ""), width= width_value, height= height_value) #Units are inches
  dev.off()
}

# Function for creating word clouds ---------------------------------------
plot_wordclouds <- function(data_set, label_value = word, size_value = n, max_size = 10, color_value = n, shape_value ="diamond") {
  ggplot(data_set, aes(label = {{label_value}}, size = {{size_value}})) +
    geom_text_wordcloud_area(aes(color = {{color_value}}), shape = shape_value) +
    scale_size_area(max_size) +
    theme_minimal()    
}

# Function for creating commparison clouds --------------------------------
create_comparison_cloud <- function(data_set,  title_value = "", color_values = c("darkred", "darkgreen"), title_bg_colors = color_values, title_text_colors = c("white")) {
  data_set %>% 
    comparison.cloud(colors = color_values,
                     random.order = FALSE, 
                     scale = c(2, 0.2),
                     title.bg.colors = title_bg_colors,
                     title.colors = title_text_colors,
                     title.size = 1) +
    title(main = title_value, line = 1)
}

# Tokenize by word and remove "uh" and "uhh" ------------------------------
my_stop_words <- tibble(word = c("uh", "uhh")) #custom stop words

debate_words <- all_debates %>% 
  unnest_tokens(word, text) %>% 
  filter(!grepl("[[:digit:]]", word)) %>%  #Remove digits
  anti_join(my_stop_words)


# Remove stop words -------------------------------------------------------
stop_words_removed <- debate_words %>% 
  mutate(word = gsub("\u2019", "'", word)) %>%  #Make read it at unix
  anti_join(stop_words)

# Word cloud: Democrats by year --------------------------------------------------
stop_words_removed %>% 
  filter(party == "D") %>% 
  count(year, party, word, sort = TRUE) %>% 
  group_by(year) %>% 
  slice_max(order_by = n, n = 20) %>% 
  plot_wordclouds() +
  scale_color_gradientn(colors = c("darkgreen","blue","red")) +
  facet_wrap(~year, ncol = 3, scales = "free") +
  labs(title = "Fig. 1: Stop Word Filtering - Democrats")

save_plot_pdf("fig_1")

# Word cloud: Republicans by year -----------------------------------------
stop_words_removed %>% 
  filter(party == "R") %>% 
  count(year, party, word, sort = TRUE) %>% 
  group_by(year) %>% 
  slice_max(order_by = n, n = 20) %>% 
  plot_wordclouds() +
  scale_color_gradientn(colors = c("darkgreen","blue","red")) +
  facet_wrap(~year, ncol = 3, scales = "free") +
  labs(title = "Fig. 2: Stop Word Filtering - Republicans")

save_plot_pdf("fig_2")

# Comparison cloud both parties -------------------------------------------
stop_words_removed  %>% 
  filter(grepl("[DR]", party)) %>% 
  mutate(party = str_replace(party, "D", "Democrats")) %>% 
  mutate(party = str_replace(party, "R", "Republicans")) %>% 
  count(party, word, sort = TRUE) %>% 
  acast(word ~ party, value.var = "n", fill = 0) %>%   
  create_comparison_cloud(color_values = c("Blue", "Red"))

save_plot_pdf(name ="fig_3")

# Commonality cloud (not included in portfolio!) --------------------------
stop_words_removed %>%
  filter(grepl("[DR]", party)) %>%
  count(party, word, sort = TRUE) %>%
  acast(word ~ party, value.var = "n", fill = 0) %>%
  commonality.cloud(colors = c("darkred", "darkgreen"),
                   random.order = FALSE,
                   scale = c(2, 0.2)) +
  title(main = "Fig. 4: Commonality Cloud - Both Parties")

save_plot_pdf("fig_4")


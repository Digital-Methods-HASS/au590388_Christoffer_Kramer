
### EXTRA FOR STOP WORD FILTERING AND TF-IDF ###

# Load libraries ----------------------------------------------------------
library(wordcloud) #comparison and commonality clouds
library(reshape2) #transforming data to term matrix

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

path_dest <- "././plots/extras/" #Destination for plot pdfs"

### Stop word filtering ###

# Comparison cloud -------------------------------------------
stop_words_removed  %>% 
  filter(grepl("[DR]", party)) %>% 
  mutate(party = str_replace(party, "D", "Democrats")) %>% 
  mutate(party = str_replace(party, "R", "Republicans")) %>% 
  count(party, word, sort = TRUE) %>% 
  acast(word ~ party, value.var = "n", fill = 0) %>%   
  create_comparison_cloud(color_values = c("Blue", "Red"))

save_plot_pdf("extra_comparison_cloud", path_dest)

# Commonality cloud  --------------------------
stop_words_removed %>%
  filter(grepl("[DR]", party)) %>%
  count(party, word, sort = TRUE) %>%
  acast(word ~ party, value.var = "n", fill = 0) %>%
  commonality.cloud(random.order = FALSE,
                    scale = c(2, 0.2)) +
  title(main = "Commonality Cloud - Both Parties")

save_plot_pdf("extra_commonality_cloud", path_dest)

### TF-IDF ###

# Calculate TF-idf by party -----------------------------------------------------
word_count_party <- debate_words %>% 
  count(party, word, sort = TRUE) #count words by each party

total_words_party <- word_count_party %>%
  group_by(party) %>% 
  summarise(total = sum(n)) # Calculate total words for each party

word_count <- left_join(word_count_party, total_words_party) # join total amount of words with word count

word_tf_idf_party <- word_count_party %>% 
  bind_tf_idf(word, party, n) # Calculate tf_idf

# Word cloud: Tf-idf by party ---------------------------------------------
word_tf_idf_party %>% 
  group_by(party) %>% 
  slice_max(order_by = tf_idf, n = 20) %>% 
  plot_wordclouds(size_value = tf_idf, color_value = tf_idf) +
  scale_color_gradientn(colors = c("darkgreen","blue","red")) +
  facet_wrap(~party, ncol = 2, scales = "free") +
  labs(title = "TF-IDF for each party across all years" )

save_plot_pdf("extra_tf_idf_by_party", path_dest)

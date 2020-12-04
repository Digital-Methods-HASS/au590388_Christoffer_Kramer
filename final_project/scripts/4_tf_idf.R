library(tidyverse) #Cleaning data
library(tidytext) #Text-mining
library(ggplot2) #Plotting
library(ggwordcloud) #Plotting word clouds
library(reshape2) #transform text to term document matrix
library(wordcloud) #Make comparison and commonality word clouds


# Calculate TF-idf by years -----------------------------------------------------
word_count_year <- debate_words %>% 
  count(year, word, sort = TRUE) #count words each year

total_words_year <- word_count_year %>%
  group_by(year) %>% 
  summarise(total = sum(n)) # Calculate total words for each year

word_count_year <- left_join(word_count_year, total_words_year) # join total amount of words with word count

word_tf_idf <- word_count_year %>% 
  bind_tf_idf(word, year, n) # Calculate tf_idf

# Calculate TF-idf by party -----------------------------------------------------
word_count_party <- debate_words %>% 
  count(party, word, sort = TRUE) #count words by each party

total_words_party <- word_count_party %>%
  group_by(party) %>% 
  summarise(total = sum(n)) # Calculate total words for each party

word_count <- left_join(word_count_party, total_words_party) # join total amount of words with word count

word_tf_idf_party <- word_count_party %>% 
  bind_tf_idf(word, party, n) # Calculate tf_idf

# Word cloud: tf-idf by year -----------------------------------------------------
word_tf_idf %>%
  group_by(year) %>%
  slice_max(order_by = tf_idf, n = 20) %>%
  plot_wordclouds(size_value = tf_idf, color_value = tf_idf) +
  scale_color_gradientn(colors = c("darkgreen","blue","red")) +
  facet_wrap(~year, ncol = 3, scales = "free") +
  labs(title = "Fig. 5: Tf-idf each year - Both Parties")

save_plot_pdf("fig_5")

# Word cloud: Tf-idf by party ---------------------------------------------
word_tf_idf_party %>% 
  group_by(party) %>% 
  slice_max(order_by = tf_idf, n = 20) %>% 
  plot_wordclouds(size_value = tf_idf, color_value = tf_idf) +
  scale_color_gradientn(colors = c("darkgreen","blue","red")) +
  facet_wrap(~party, ncol = 2, scales = "free") +
  labs(title = "Fig. 6: TF-IDF for each party across all years" )

save_plot_pdf("fig_6")

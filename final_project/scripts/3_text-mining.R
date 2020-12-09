### Text mining: sentiment analysis, tf-idf, and stop word filtering ###

# Load libraries ----------------------------------------------------------
library(tidytext)
library(ggplot2)
library(ggwordcloud)

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

# Plot stop word filtering R and D ----------------------------------------
stop_words_removed %>% 
  filter(grepl("[DR]", party)) %>% 
  count(year, party, word, sort = TRUE) %>% 
  group_by(year, party) %>% 
  slice_max(order_by = n, n = 20) %>% 
  plot_wordclouds() +
  scale_color_gradientn(colors = c("darkgreen","blue","red")) +
  facet_wrap(~year + party) +
  labs(title = "Fig. 1: Stop Word Filtering")

save_plot_pdf("fig_1")

# TF-IDF ------------------------------------------------------------------
word_count_year <- debate_words %>% 
  count(year, word, sort = TRUE)

total_words_year <- word_count_year %>%
  group_by(year) %>% 
  summarise(total = sum(n))

word_count_year <- left_join(word_count_year, total_words_year)

word_tf_idf_year <- word_count_year %>% 
  bind_tf_idf(word, year, n)

# Plot TF-IDF -------------------------------------------------------------
word_tf_idf_year %>%
  group_by(year) %>%
  slice_max(order_by = tf_idf, n = 20) %>%
  plot_wordclouds(size_value = tf_idf, color_value = tf_idf) +
  scale_color_gradientn(colors = c("darkgreen","blue","red")) +
  facet_wrap(~year, ncol = 3, scales = "free") +
  labs(title = "Fig. 2: Tf-idf each year - Both Parties")

save_plot_pdf("fig_2")

# Sentiment Analysis ------------------------------------------------------
distortion_words <- tibble(word = c("trump", "vice"))

sentiment_debate_words <- debate_words %>% 
  filter (year >= 1992) %>%
  anti_join(distortion_words) %>% 
  inner_join(get_sentiments("bing"))

#Plot Pie chart function
plot_pie_chart <- function(data_set, fill_value = sentiment){
  data_set %>%  
    mutate(total = sum(n)) %>% 
    mutate(share = n/total) %>% 
    ggplot() + 
    geom_bar(aes(x = "", y = share, fill = {{fill_value}}), stat = "identity") +
    scale_fill_brewer(palette = "Set3") +
    coord_polar("y", start = 0) +
    theme(axis.text.x = element_blank()) 
}

#Republicans
sentiment_debate_words %>%   
  filter(party == "R") %>% 
  group_by(year, sentiment) %>%
  tally() %>%
  plot_pie_chart() +
  facet_wrap(~year, ncol = 7) +
  labs(title = "Fig. 3: Republicans' sentiment by year - BING",
       x = "",
       y = "",
       fill = "sentiments")

save_plot_pdf("fig_3")

#Democrats
sentiment_debate_words %>%
  filter(party == "D") %>% 
  filter(year >= 1992) %>% 
  group_by(year, sentiment) %>% 
  tally() %>% 
  plot_pie_chart() +
  facet_wrap(~year, ncol = 7) +
  labs(title = "Fig. 4: Democrats sentiment by year - BING",
       x = "",
       y = "",
       fill = "sentiments")

save_plot_pdf("fig_4")

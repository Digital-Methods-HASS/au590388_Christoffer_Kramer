### Extra for Sentiment analysis ###

# Add afinn lexicon -----------------------------------------------
sentiment_debate_words <- sentiment_debate_words %>% 
  inner_join(get_sentiments("afinn"))
  
# Pie chart Republicans - total sentiment ---------------------------------
sentiment_debate_words %>% 
  filter(grepl("[DR]", party)) %>% 
  count(sentiment, party, sort = TRUE) %>% 
  plot_pie_chart() +
  labs(title = "Extra: Republicans Total Sentiment Since 1992 - BING",
       x = "",
       y = "",
       fill = "sentiments")

save_plot_pdf("extra_republicans_total_sentiment_BING", path_dest)

# Pie chart democrats - total sentiment  ----------------------------------
sentiment_debate_words %>%
  filter(party == "D") %>% 
  count(sentiment) %>%  
  plot_pie_chart() +
  labs(title = "Extra: Democrats Total Sentiment Since 1992 - BING",
       x = "",
       y = "",
       fill = "sentiments")

save_plot_pdf("extra_democrats_total_sentiment_BING", path_dest)


# Plot bar chart: Total Sentiment distribution for both parties (Afinn) ----------
sentiment_debate_words %>%
  filter(grepl("[RD]", party)) %>%  
  count(value, party) %>%
  ggplot(aes(x = value, y = n)) +
  geom_col() +
  labs(title = "Extra: Total Sentiment distribution since 1992 for both parties - AFINN",
       x = "sentiment",
       y = "count") +
  facet_wrap(~party)

save_plot_pdf("extra_total_sentiment_distribution_both_parties", path_dest)

# Plot bar chart: Sentiment distribution facet by year and party ----------
sentiment_debate_words %>%
  filter(grepl("[RD]", party)) %>%  
  count(value, party, year) %>%
  ggplot(aes(x = value, y = n)) +
  geom_col() +
  labs(title = "Extra: Sentiment distribution facet by year and party - AFINN",
       x = "sentiment",
       y = "count") +
  facet_wrap(~year + party)

save_plot_pdf("extra_sentiment_distribution_by_year_and_party", path_dest)

# Word cloud, both parties: sentiment and word count year -----------------
sentiment_debate_words %>%
  filter(grepl("[DR]", party)) %>% 
  count(year, word, party, value, sort = TRUE) %>%
  group_by(year, party) %>% 
  slice_max(order_by  = n, n= 50) %>%    
  plot_wordclouds(color_value = value) +
  scale_color_gradient(low = "red", high = "green") +
  facet_wrap(~year + party) +
  labs(title = "Extra: Worcloud - sentiment and word count facet by year and party")

save_plot_pdf("extra_word_cloud_by_year_party_sentiment_and_count", path_dest)

# Sentiment Comparison Cloud - Republicans --------------------------------
sentiment_debate_words %>% 
  filter(party == "R") %>% 
  count(word, sentiment, sort = TRUE) %>% 
  acast(word ~ sentiment, value.var = "n", fill = 0) %>% 
  create_comparison_cloud(title_value = "Extra: Sentiment Comparison Cloud - Republicans")

save_plot_pdf("extra_sentiment_comparison_republicans", path_dest)

# Sentiment comparison cloud - Democrats ----------------------------------
sentiment_debate_words %>% 
  filter(party == "D") %>% 
  count(word, sentiment, sort = TRUE) %>%   
  acast(word ~ sentiment, value.var = "n", fill = 0) %>% 
  create_comparison_cloud(title_value = "Extra: Sentiment Comparison Cloud - Democrats")

save_plot_pdf("extra_sentiment_comparison_cloud_democrats", path_dest)

### Distortion ###

#Looks at how skewed the sentiment analysis is by looking at negation words

# List of words that negates the next word
negation_words <- c("not", "no", "never", "without", "don't", "can't", "cannot", "doesn't", "couldn't", "shouldn't")


# Tokenize by bigram, seperate and inner_join Afinn -----------------------
all_debates_bigrams <- all_debates %>% 
  filter (year >= 1992) %>%
  unnest_tokens(bigram, text, token = "ngrams", n = 2) %>% 
  separate(bigram, c("word1", "word2"), sep = " ") %>% 
  filter(word1 %in% negation_words) %>% 
  inner_join(get_sentiments("afinn"), by = c(word2 = "word"))

# Plot bar chart: How each year is skewed ---------------------------------
all_debates_bigrams %>% 
  count(word1, word2, year, value, sort = TRUE) %>% 
  mutate(contribution = n * value) %>% 
  group_by(year) %>% 
  summarise(total = sum(contribution)) %>% 
  ggplot(aes(x = year, y = total), stat = "identity") +
  geom_col() +
  scale_x_continuous(breaks=seq(1992, 2020, by = 4)) +
  scale_y_continuous(breaks = seq(0, 70, by = 10)) +
  labs(title = "Extra: Sentiment distortion each year- AFINN",
       x = "Year",
       y = "Sentiment value")

save_plot_pdf("extra_distortion_each_year", path_dest)

# Plot bar: Top 30 words that mainly skew the result ----------------------
all_debates_bigrams %>% 
  count(word1, word2, value, sort = TRUE) %>% 
  mutate(contribution = n * value) %>%
  arrange(desc(abs(contribution))) %>%
  head(30) %>% 
  mutate(word2 = reorder(word2, contribution)) %>%
  arrange(desc(n)) %>% 
  ggplot(aes(n * value, word2, fill = n * value > 0)) +
  geom_col(show.legend = FALSE) +
  labs(title = "Extra: Sentiment distortion by word - AFINN",
       x = "Total sentiment value",
       y = "Word")

save_plot_pdf("extra_sentiment_distribution_top_30_words", path_dest)


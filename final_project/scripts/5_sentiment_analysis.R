library(tidyverse)
library(tidytext)
library(ggplot2)
library(ggwordcloud)
library(wordcloud)
library(reshape2)

distortion_words <- tibble(word = c("trump", "vice"))

sentiment_debate_words <- debate_words %>% 
  anti_join(distortion_words) %>% 
  inner_join(get_sentiments("afinn")) %>% 
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

#Pie chart Republicans - over all sentiment
sentiment_debate_words %>% 
  filter (year >= 1992) %>% 
  filter(party == "R") %>% 
  count(sentiment, sort = TRUE) %>% 
  plot_pie_chart() +
  labs(title = "Fig. 7: Republicans Total Sentiment Since 1992 - BING",
       x = "",
       y = "",
       fill = "sentiments")

save_plot_pdf("fig_7")

#Pie chart Democrats - over all sentiment 
sentiment_debate_words %>%
  filter(year >= 1992) %>%   
  filter(party == "D") %>% 
  count(sentiment) %>%  
  plot_pie_chart() +
  labs(title = "Fig. 8: Democrats Total Sentiment Since 1992 - BING",
       x = "",
       y = "",
       fill = "sentiments")

save_plot_pdf("fig_8")

#Pie chart Democrats - over all sentiment 
sentiment_debate_words %>%
  filter(year >= 1992) %>%  
  filter(grepl("[RD]", party)) %>% 
  count(sentiment) %>%  
  plot_pie_chart() +
  labs(title = "Fig. 9: Borth Parties' Total Sentiment Since 1992 - BING",
       x = "",
       y = "",
       fill = "sentiments")

save_plot_pdf("fig_9")

sentiment_debate_words %>%
  filter(grepl("[RD]", party)) %>% 
  filter(year >= 1992) %>% 
  count(value) %>%
  ggplot(aes(x = value, y = n)) +
  geom_col() +
  labs(title = "Fig. 10: Combined Sentiment Distribution For Both Parties - AFINN",
       x = "sentiment",
       y = "count")

save_plot_pdf("fig_10")

sentiment_debate_words %>%
  filter(party == "R") %>% 
  filter(year >= 1992) %>% 
  count(value) %>%
  ggplot(aes(x = value, y = n)) +
  geom_col() +
  labs(title = "Fig. 11: Sentiment distribution since 1992 for Republicans - AFINN",
       x = "sentiment",
       y = "count")

save_plot_pdf("fig_11")

sentiment_debate_words %>%
  filter(party == "D") %>% 
  filter(year >= 1992) %>% 
  count(value) %>%
  ggplot(aes(x = value, y = n)) +
  geom_col() +
  labs(title = "Fig. 12: Sentiment distribution since 1992 for Democrats - AFINN",
       x = "sentiment",
       y = "count")

save_plot_pdf("fig_12")

#Republicans
sentiment_debate_words %>%   
  filter(party == "R") %>% 
  filter(year >= 1992) %>% 
  group_by(year, sentiment) %>% 
  tally() %>% 
  plot_pie_chart() +
  facet_wrap(~year, ncol = 7) +
  labs(title = "Fig. 13: Republicans' sentiment by year - BING",
       x = "",
       y = "",
       fill = "sentiments")

save_plot_pdf("fig_13")

#Democrats
sentiment_debate_words %>%
  filter(party == "D") %>% 
  filter(year >= 1992) %>% 
  group_by(year, sentiment) %>% 
  tally() %>% 
  plot_pie_chart() +
  facet_wrap(~year, ncol = 7) +
  labs(title = "Fig. 14: Democrats sentiment by year - BING",
       x = "",
       y = "",
       fill = "sentiments")

save_plot_pdf("fig_14")

#All 
sentiment_debate_words %>%
  filter(year >= 1992) %>% 
  group_by(year, sentiment) %>% 
  tally() %>% 
  plot_pie_chart() +
  facet_wrap(~year, ncol = 7) +
  labs(title = "Fig. 15: Total sentiment by year - BING",
       x = "",
       y = "",
       fill = "sentiments")

save_plot_pdf("fig_15")

negation_words <- c("not", "no", "never", "without")

all_debates_bigrams <- all_debates %>% 
  unnest_tokens(bigram, text, token = "ngrams", n = 2) %>% 
  separate(bigram, c("word1", "word2"), sep = " ") %>% 
  filter(word1 %in% negation_words) %>% 
  inner_join(get_sentiments("afinn"), by = c(word2 = "word"))

save_plot_pdf("fig_16")

all_debates_bigrams %>% 
  count(word1, word2, value, sort = TRUE) %>% 
  mutate(contribution = n * value) %>%
  arrange(desc(abs(contribution))) %>%
  head(30) %>% 
  mutate(word2 = reorder(word2, contribution)) %>%
  arrange(desc(n)) %>% 
  ggplot(aes(n * value, word2, fill = n * value > 0)) +
  geom_col(show.legend = FALSE) +
  labs(title = "Fig. 16: Sentiment distortion by word - AFINN",
       x = "Total sentiment value",
       y = "Word")

save_plot_pdf("fig_16")

all_debates_bigrams %>% 
  count(word1, word2, year, value, sort = TRUE) %>% 
  mutate(contribution = n * value) %>% 
  group_by(year) %>% 
  summarise(total = sum(contribution)) %>% 
  ggplot(aes(x = year, y = total), stat = "identity") +
  geom_col() +
  scale_x_continuous(breaks=seq(1960, 2020, by = 4)) +
  scale_y_continuous(breaks = seq(0, 70, by = 10)) +
  labs(title = "Fig. 17: Sentiment distortion each year- AFINN",
       x = "Year",
       y = "Sentiment value")


save_plot_pdf("fig_17")

sentiment_debate_words %>%
  filter(party == "D") %>%
  filter(year >= 1992) %>% 
  count(year, word, value, sort = TRUE) %>%
  group_by(year) %>% 
  slice_max(order_by  = n, n= 50) %>%    
  plot_wordclouds(color_value = value) +
  scale_color_gradient(low = "red", high = "green") +
  facet_wrap(~year, ncol = 3) +
  labs(title = "Fig. 18: Democrats' sentiment and word count year")

save_plot_pdf("fig_18")


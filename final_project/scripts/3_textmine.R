
# Load libraries ----------------------------------------------------------
library(tidyverse)
library(tidytext)
library(dplyr)
library(ggplot2)
library(tidyr)
library(ggwordcloud)
library(wordcloud)
library(reshape2)
library(qdap)
# Tokenize, remove digits, remove uh and uhh ------------------------------
my_stop_words <- tibble(word = c("uh", "uhh"))

debate_words <- all_debates %>% 
  unnest_tokens(word, text) %>% 
  anti_join(my_stop_words) %>% 
  filter(is.na(as.numeric(word))) %>%
  count(year, party, word, sort = TRUE)

all_years <- debate_stop_words_removed

# Stop word filtering -------------------------------------------
debates_stop_words_removed <- debate_words %>% 
  mutate(word = gsub("\u2019", "'", word)) %>%  
  anti_join(stop_words) %>% 
  group_by(year)
view(debates_stop_words_removed)
view(debate_stop_words_removed)

#Get a list of all years for plotting and loops
all_years <- debate_stop_words_removed %>% 
  select(year) %>% 
  unique() %>% 
  arrange(desc(year))



# Word clouds -------------------------------------------------------------

#Democrats
debates_stop_words_removed %>% 
    filter(party == "D") %>% 
    group_by(year) %>% 
    top_n(20) %>% 
    ungroup %>% 
    ggplot(aes(label = word, size = n)) +
    geom_text_wordcloud_area(aes(color = n, shape = "diamond")) +
    #scale_size_area(max_size = 12) +
    scale_color_gradientn(colors = c("darkgreen","blue","red")) +
    theme_minimal() +
    facet_wrap(~year, ncol = 3, scales = "free")
color_list <- c("red", "blue", "black")  
#Republicans
debates_stop_words_removed %>% 
  filter(party != "I") %>%
  filter(party != "not_a_candidate") %>% 
  group_by(year, party) %>% 
  top_n(40) %>% 
  ggplot(aes(label = word, size = n)) +
  geom_text_wordcloud_area(aes(color = party, ordered.colors = TRUE, shape = "diamond", fill = party, random = FALSE)) +
  scale_colour_manual(values = c("blue", "red"), aesthetics = c("color", "fill")) +
  theme_minimal() +
  facet_wrap(~year, ncol = 3, scales = "free")

ggsave("word_cloud_3.pdf", width = 65, height = 35, units = "cm")

for (i in all_years) {
print(i)
 plot <- debates_stop_words_removed %>%
    filter(party != "not_a_candidate") %>%
    filter(party != "I" ) %>%
    filter(year == i) %>%
    acast(word ~ party, fun.aggregate = sum, value.var = "n", fill = 0) %>%
    comparison.cloud(colors = c("gray20", "gray80"),
                     max.words = 20)
 print(plot)
 ggsave(paste(i,"word_cloud.pdf", sep = "_"), width = 65, height = 35, units = "cm")
}


# Affin Democrats and Republicans -----------------------------------------
affin_R <- debate_words_R %>% 
  inner_join(get_sentiments("afinn"))

affin_D <- debate_words_D %>% 
  inner_join(get_sentiments("afinn"))

# Plot Afinn --------------------------------------------------------------
affin_R_plot <- affin_R %>% 
  count(value) %>% 
  ggplot(aes(x = value, y = n)) + 
  geom_col()

affin_D_plot <- affin_D %>% 
  count(value) %>% 
  ggplot(aes(x = value, y = n)) + 
  geom_col()
affin_D_plot

# NRC ---------------------------------------------------------------------
nrc_R <- debate_words_R %>% 
  inner_join(get_sentiments("nrc"))

nrc_D <- debate_words_D %>% 
  inner_join(get_sentiments("nrc"))

# Plot NRC ----------------------------------------------------------------
ggplot(data = nrc_R, aes(x = sentiment, y = n)) +
  geom_col()

ggplot(data = nrc_D, aes(x = sentiment, y = n)) +
  geom_col()


# bing --------------------------------------------------------------------
bing_R <- debate_words_R %>% 
  inner_join(get_sentiments("bing"))

bing_D <- debate_words_D %>% 
  inner_join(get_sentiments("bing"))

# Plot bing ---------------------------------------------------------------)
ggplot(data = bing_R, aes(x = sentiment, y = n)) +
  geom_col()

ggplot(data = bing_D, aes(x = sentiment, y = n)) +
  geom_col()



# Do everything above based on each year ----------------------------------


# TF_IDF Republicans ------------------------------------------------------------------
total_words_R <- all_debates %>% 
  filter(party == "R") %>% 
  unnest_tokens(word, text) %>% 
  count(year, word, sort = TRUE) %>% 
  group_by(year) %>% 
  summarise(total = sum(n))

r_words <- all_debates %>% 
  unnest_tokens(word, text) %>% 
  count(year, word, sort = TRUE)

R_word_count <- left_join(r_words, total_words_R, by = "year")

R_word_count
view(debate_words_count)

R_td_idf <- R_word_count %>% 
  bind_tf_idf(word, year, n) 

R_td_idf


for (i in total_words_R$year) {
  #print(i)

  plot <- R_td_idf %>%
    filter(year == i) %>%
    arrange(desc(tf_idf)) %>%
    head(50) %>%
    ggplot(aes(label = word, size = tf_idf)) +
    geom_text_wordcloud_area(aes(color = tf_idf), shape = "diamond") +
    scale_size_area(max_size = 50) +
    scale_color_gradientn(colors = c("darkgreen","blue","red")) +
    theme_minimal()

  print(plot)
 #ggsave(paste(i,"word_cloud.pdf", sep = "_"), width = 65, height = 35, units = "cm")
  
  
}

# TF for democrats --------------------------------------------------------


# TF without names --------------------------------------------------------


# Who mentions each other most? --------------------------------------------


# Sentiment analysis based on TF_IDF --------------------------------------


# Often mentioned together ------------------------------------------------


# Ekstra shit -------------------------------------------------------------
#count total words in each debate for td-idf analysis later




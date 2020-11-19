
# Load libraries ----------------------------------------------------------
library(tidyverse)
library(tidytext)
library(dplyr)
library(ggplot2)
#Tokenize by word
debate_words <- all_debates %>% 
  unnest_tokens(word, text) %>% 
  count(date, word, sort = TRUE)

#count total words in each debate for td-idf analysis later
total_words <- debate_words %>% 
  group_by(date) %>% 
  summarise(total = sum(n)) %>% 
  arrange(desc(total))

view(debate_words)  
view(total_words)

#Combine debate words and total words, so I always know how many total words there are
debate_words <-left_join(debate_words, total_words)

# tidy_debates %>% 
#   count(word, sort = TRUE)

debate_tf_idf <- debate_words %>% 
  bind_tf_idf(word, date, n)

tf <- debate_tf_idf %>% 
  select(-total) %>% 
  arrange(desc(tf_idf))

view(tf)

for (debate in debate_words$debate) {
  ggplot(debate_words, aes(n/total, fill = debate)) +
    geom_histogram(show.legend = FALSE) +
    xlim(NA, 0.0009)
}


ggplot(debate_words, aes(n/total, fill = debate)) +
  geom_histogram(show.legend = FALSE) +
  facet_wrap(~debate, ncol = 2, scales = "free_y")

ggplot(debate_words, aes(n/total, fill = debate)) +
  geom_histogram(show.legend = FALSE) +
  xlim(NA, 0.0009) +
facet_wrap(~debate, ncol = 2, scales = "free")

ggplot(debate_words, aes(n/total, fill = debate)) +
  geom_histogram(show.legend = FALSE)

# libraries
library(tidyverse)
library(ggthemes)

# read data in
emma_book <- read_tsv("processed-data/emma-book.tsv") %>% # and then
  mutate(source = "book")

emma_script <- read_tsv("processed-data/emma-script.tsv") %>%
  mutate(source = "script")

# create a mutate to add a column called "paragraph" to both
# data frames that contain paragraph number # 45 min after the hours
emma_book <- emma_book %>%
  mutate(paragraph = rownames(emma_book))

emma_script <- emma_script %>%
  mutate(paragraph = rownames(emma_script))

# combine both corpora into one dataframe
emma_corpora <- bind_rows(emma_book,
                          emma_script) %>%
  rename(text = ".")

# count how many paragraphs per corpora
emma_corpora %>%
  count(source)

##### TOKENIZATION ####
library(tidytext)
# remove period after title
emma_corpora <- emma_corpora %>%
  mutate(text_clean = gsub("Mr\\.|", "Mr", text))

# tokenize corpora
tokenized_emma <- emma_corpora %>%
  unnest_tokens(word, text)

# size of corpora (number of tokens)
tokenized_emma %>%
  count(source)

# number of types
tokenized_emma %>%
  distinct(source, word) %>%
  count(source)

# tokenize corpora by sentence
emma_sentences <- emma_corpora %>%
  unnest_tokens(sentence, text, token = "sentences")

# count number of sentences per source check in: 13 min after the hour
emma_sentences %>%
  count(source)

# count number of sentences per paragraph
emma_sentences %>%
  count(source, paragraph) %>%
  group_by(source) %>%
  summarize(mean_sentence_count = mean(n),
            sd_sentence_count = sd(n))

# unnest trigrams
emma_trigrams <- emma_sentences %>%
  unnest_tokens(ngrams, sentence, token = "ngrams", n = 3)

# count how many of each trigram per corpus # check in at 23 past the hour
emma_trigrams %>%
  filter(!is.na(ngrams)) %>%
  count(source, ngrams, sort = TRUE) %>%
  group_by(source) %>%
  slice_max(order_by = n, n = 15) %>%
  #top_n(10) %>%
  ggplot(aes(y = reorder_within(ngrams, n, source),
             x = n,
             fill = source)) +
  geom_col() +
  facet_wrap(~source, scales = "free") +
  scale_y_reordered() +
  theme_linedraw() +
  labs(y = "",
       x = "raw frequency",
       title = "Top 15 most frequent trigrams",
       subtitle = "across corpora") +
  theme(legend.position = "none") +
  #scale_fill_manual(values = c("darkslategray4",
  #                             "lightgoldenrod3"))
  scale_fill_colorblind()

ggsave("images/most-freq-trigrams.png")


most_frequent_trigrams <- emma_trigrams %>%
  filter(!is.na(ngrams)) %>%
  count(source, ngrams, sort = TRUE) %>%
  group_by(source) %>%
  slice_max(order_by = n, n = 15)

write_csv(most_frequent_trigrams, "processed-data/most-freq-trigrams.csv")

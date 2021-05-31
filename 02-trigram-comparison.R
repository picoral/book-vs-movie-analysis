# libraries
library(tidyverse)

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



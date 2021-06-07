# load libraries
library(tidyverse)
library(spacyr)

# read data in
emma_script <- read_tsv("processed-data/emma-script.tsv") %>%
  rename(text = ".")

emma_book <- read_tsv("processed-data/emma-book.tsv") %>%
  rename(text = ".")
  
# annotate text with spacyr
spacy_initialize(model = "en_core_web_sm")

annotated_script <- spacy_parse(emma_script$text,
                                dependency = TRUE,
                                nounphrase = TRUE)

annotated_book <- spacy_parse(emma_book$text,
                              dependency = TRUE,
                              nounphrase = TRUE)

annotated_script <- annotated_script %>%
  mutate(source = "script")

annotated_book <- annotated_book %>%
  mutate(source = "book")

annotated_data <- bind_rows(annotated_script,
                            annotated_book)

annotated_data %>%
  count(source)

## noun phrases
# one word noun phrase: beg_root
# two word noun phrase: beg end_root
# three word noun phrase: beg mid end_root 
# four word noun phrase: be mid mid end_root

# extract the complete noun phrases from the data
# noun_phrase source
# 20 minutes after the hour (14:20)
annotated_data <- annotated_data %>%
  mutate(np_id = NA)

np_count <- 0
for (i in 1:nrow(annotated_data)) {
  
  if (annotated_data$nounphrase[i] == "beg") {
    np_count <- np_count + 1
  }
  
  if (annotated_data$nounphrase[i] != "" & 
      annotated_data$nounphrase[i] != "beg_root") {
    annotated_data$np_id[i] <- np_count
  }
}

write_tsv(annotated_data, "processed-data/annotated-data.tsv")

all_nps <- annotated_data %>%
  group_by(source, np_id) %>%
  summarize(complete_np = tolower(paste(token, collapse = " ")),
            np_lemma = paste(lemma, collapse = " "),
            np_pos = paste(pos, collapse = " "))

library(tidytext)
all_nps %>%
  count(source, complete_np, sort = TRUE) %>%
  group_by(source) %>%
  slice_max(n, n = 15) %>%
  ggplot(aes(y = reorder_within(complete_np, n, source),
            x = n)) +
  geom_col() +
  facet_wrap(~source, scales = "free") +
  scale_y_reordered()

all_nps %>%
  count(source, np_pos, sort = TRUE) %>%
  group_by(source) %>%
  slice_max(n, n = 15) %>%
  ggplot(aes(y = reorder_within(np_pos, n, source),
             x = n)) +
  geom_col() +
  facet_wrap(~source, scales = "free") +
  scale_y_reordered()






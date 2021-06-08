# loading the libraries
library(tidyverse)
library(tidytext)
library(spacyr)
spacy_initialize(model = "en_core_web_sm")

# read the data in
emma_book <- read_tsv("processed-data/emma-book.tsv") %>%
  rename(text = ".")

emma_script <- read_tsv("processed-data/emma-script.tsv") %>%
  rename(text = ".")

# annotate both data sets
annotated_book <- spacy_parse(emma_book$text,
                              tag = TRUE,
                              dependency = TRUE,
                              nounphrase = TRUE)
annotated_script <- spacy_parse(emma_script$text,
                                 tag = TRUE,
                                 dependency = TRUE,
                                 nounphrase = TRUE) 

# add source to both annotate dataframe
annotated_book <- annotated_book %>%
  mutate(source = "book")
annotated_script <- annotated_script %>%
  mutate(source = "script")

# combine dataframes
annotated_data <- bind_rows(annotated_book,
                            annotated_script)
annotated_data %>%
  count(source)

# extract noun phrases function
extracted_nounphrases_book <- spacy_extract_nounphrases(emma_book$text)

# assign unique id to tokens in the same noun phrase
annotated_data <- assign_id_to_nps(annotated_data)

# extract noun phrases by source
emma_nps <- extract_nps(annotated_data)

# visualize most common noun phrases for each source
emma_nps %>%
  count(source, complete_np) %>%
  group_by(source) %>%
  slice_max(n, n = 15) %>%
  ggplot(aes(y = reorder_within(complete_np, n, source),
             x = n)) +
  geom_col() +
  facet_wrap(~source, scales = "free") +
  scale_y_reordered() +
  theme_linedraw() +
  labs(y = "noun phrases",
       x = "raw frequency")


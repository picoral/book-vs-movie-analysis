# load libraries
library(janeaustenr)
library(tidyverse)

# get the book emma
data(emma)
view(emma)

# create new_emma with lines combined into paragraphs
new_emma <- combine_into_paragraphs(emma)
view(new_emma)

# save new_emma to disk
new_emma %>%
  data.frame() %>%
  write_tsv("data/emma-book.tsv")


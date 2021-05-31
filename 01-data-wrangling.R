# load libraries
library(janeaustenr)
library(tidyverse)

# run source code
source("00-utils.R")

#### BOOK DATA WRANGLING ####
# get the book emma
data(emma)
view(emma)

# create new_emma with lines combined into paragraphs
new_emma <- combine_into_paragraphs(emma)
view(new_emma)
class(new_emma)

# save new_emma to disk
new_emma %>%
  data.frame() %>%
  write_tsv("processed-data/emma-book.tsv")

#### SCRIPT DATA WRANGLING ####
# read data in from disk
emma_script <- read_tsv("raw-data/emma-script.tsv",
                        skip_empty_rows = FALSE,
                        na = c("NA"))
# read data in from github
emma_script <- read_tsv("https://raw.githubusercontent.com/picoral/book-vs-movie-analysis/main/raw-data/emma-script.tsv",
                        skip_empty_rows = FALSE,
                        na = c("NA"))

# class of emma_script
class(emma_script)
class(emma_script$.)
# combine lines into paragraphs
new_emma_script <- combine_into_paragraphs(emma_script$.)
length(new_emma_script)
view(new_emma_script)

new_emma_script %>%
  data.frame %>%
  write_tsv("processed-data/emma-script.tsv")




# load library
library(tidyverse)

# function that combines lines into paragraphs
combine_into_paragraphs <- function(my_char_vector) {
  # step 1: collapse all lines into one line
  char_vector_combined <- paste(my_char_vector, collapse = " ")
  # step 2: split our one line by two or more spaces
  char_vector_paragraphs <- unlist(str_split(char_vector_combined,
                                            pattern = "\\s\\s+"))
  return(char_vector_paragraphs)
}

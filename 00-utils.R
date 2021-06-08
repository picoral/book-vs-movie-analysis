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


# function to assign unique id to all tokens in the same noun phrase
assign_id_to_nps <- function(my_data) {
  new_data <- my_data %>%
    mutate(np_id = ifelse(nounphrase == "beg",
                          rownames(.), NA)) %>%
    mutate(np_id = ifelse(nounphrase == "end_root",
                          0, np_id)) %>%
    fill(np_id) %>%
    mutate(np_id = ifelse(nounphrase == "end_root",
                          lag(np_id), np_id)) %>%
    mutate(np_id = ifelse(np_id == "0",
                          NA, np_id))
  
  return(new_data)
}

# function to extract noun phrases and accompanying labels
extract_nps <- function(my_data) {
  my_nps <- my_data %>%
    group_by(source, np_id) %>%
    summarize(complete_np = tolower(paste(token, collapse = " ")),
              np_lemma = paste(lemma, collapse = " "),
              np_pos = paste(pos, collapse = " "),
              np_tag = paste(tag, collapse = " "))
  return(my_nps)
}

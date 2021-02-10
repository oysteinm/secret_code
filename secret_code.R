# Secret code solution

browseURL("https://learnesy.com/secret-code-quiz/")

library(tidyverse)
library(readxl)
library(httr)
library(xlsx)

url <- "https://learnesy.com/wp-content/uploads/2021/02/Secret_Code.xlsx"

GET(url, write_disk(tmpfi <- tempfile(fileext = ".xlsx")))
Secret_Code <- read_excel(tmpfi, skip = 2)

Secret_Code

# Search pattern
# ^        >> from the beginning of the string...
# .*       >> every character till... 

pattern <- c("^.*0.*0.*7")  

Secret_Code <- 
  Secret_Code %>%
  mutate(`Shipment number` = as.character(`Shipment number`), # turn number into text
         `Secret code?` = if_else(str_detect(`Shipment number`, pattern), "Yes", "No"), # search pattern
         `Shipment number` = as.numeric(`Shipment number`)) # turn text back into number

Secret_Code

Secret_Code %>%
  group_by(`Secret code?`) %>%
  summarise(N=n())

# Write the data back to a new excel sheet
write.xlsx(Secret_Code, file = "Secret_Code_Solved.xlsx",
           sheetName = "Secret_Code", append = FALSE)

# Column names in excel files often contain mixed case names and
# spaces or other characters such as brackets or other special signs that can be awkward to work with in R.
# To solve that an easy option is to use the janitor package.

library(janitor)

test <- clean_names(Secret_Code)
test

# Avoid backticks in variable names

test <- 
  test %>%
  mutate(shipment_number = as.character(shipment_number), # turn number into text
         secret_code = if_else(str_detect(shipment_number, pattern), "Yes", "No"), # search pattern
         shipment_number = as.numeric(shipment_number)) # turn text back into number

test


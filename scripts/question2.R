#install.packages("dplyr")
#install.packages("lubridate")
library(lubridate)
library(dplyr)
hate_data <- read.csv("20170816_Documenting_Hate .csv", stringsAsFactors = FALSE)
with_month <- mutate(hate_data, Article.Date = mdy_hm(Article.Date)) %>% mutate(month = month(Article.Date))




#install.packages("dplyr")
#install.packages("lubridate")
library(lubridate)
library(dplyr)
hate_data <- read.csv("20170816_Documenting_Hate .csv", stringsAsFactors = FALSE)
with_month <- mutate(hate_data, Article.Date = mdy_hm(Article.Date)) %>% mutate(month = month(Article.Date))
months <- c("February", "March",
            "April", "May", "June", "July",
            "August")

compare_month <- function(picked_month) {
  month_index <- 1 + match(picked_month, months)
  month_data <- filter(with_month, month == month_index)
  other_month_data <- filter(with_month, month != month_index)
  head(other_month_data)
}

compare_month("June")
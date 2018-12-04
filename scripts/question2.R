#install.packages("dplyr")
#install.packages("lubridate")
library(lubridate)
library(dplyr)
library(ggplot2)
hate_data <- read.csv("20170816_Documenting_Hate .csv", stringsAsFactors = FALSE)
with_month_day <- mutate(hate_data, Article.Date = mdy_hm(Article.Date)) %>% 
  mutate(month = month(Article.Date), article_day = day(Article.Date)) %>% 
  mutate(State = replace(State, State == "", "No State Given"))
months <- c("February", "March",
            "April", "May", "June", "July",
            "August")
ggplot(with_month_day, aes(Article.Date)) + geom_density(adjust = 1/8)

compare_month <- function(picked_month) {
  month_index <- 1 + match(picked_month, months)
  month_data <- filter(with_month_day, month == month_index)
  other_month_data <- filter(with_month_day, month != month_index)
  head(other_month_data)
  top_data <- filter(month_data, State %in% (top_n(data.frame(table(month_data$State)), 6) %>% pull("Var1")))
  head(top_data)
  ggplot(data=top_data, aes(article_day, fill = State)) + 
    geom_density(alpha = 0.3)
    #geom_histogram(data=other_month_data, fill = "blue", alpha = 0.2)
}

compare_month("June")
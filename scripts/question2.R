#install.packages("dplyr")
#install.packages("lubridate")
library(lubridate)
library(dplyr)
library(ggplot2)
hate_data <- read.csv("20170816_Documenting_Hate .csv", stringsAsFactors = FALSE)
with_month_day <- mutate(hate_data, Article.Date = mdy_hm(Article.Date)) %>% 
  mutate(month = month(Article.Date), article_day = day(Article.Date)) %>% 
  mutate(State = replace(State, State == "", "No State Given"))
compare_month <- function(date_range) {
  month_data <- filter(with_month_day, (Article.Date > ymd(date_range[1]) & 
                          Article.Date < ymd(date_range[2])))
  top_data <- filter(month_data, State %in% 
                        (top_n(data.frame(table(month_data$State)), 6) %>% 
                            pull("Var1")))
  head(top_data)
  return(ggplot(data=top_data, aes(article_day, fill = State)) + 
    geom_density(alpha = 0.3, adjust=1/5))
}
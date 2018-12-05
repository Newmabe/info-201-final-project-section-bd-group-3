#install.packages("dplyr")
#install.packages("lubridate")
library(lubridate)
library(dplyr)
library(ggplot2)
hate_data <- read.csv("20170816_Documenting_Hate .csv", stringsAsFactors = FALSE)

compare_month <- function(date_range) {
  
}
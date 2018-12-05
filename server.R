#install.packages(c("ggplot2", "mapdata", "maptools", "openintro", "ggmap", "googleway"))
library(shiny)
library(dplyr)
library(ggplot2)
library(mapdata)
library(maptools)
library(openintro)
library(googleway)
library(ggmap)
library(lubridate)

server <- function(input, output) {
  df <- read.csv("20170816_Documenting_Hate .csv", stringsAsFactors = FALSE)
  colnames(df) <- c("Article_Date", "Crime_Date", "Summary", "Organization",
                    "City", "State", "URL", "Blank 1", "Blank 2")
  df <- df %>% 
    select("Article_Date", "Crime_Date", "Summary", "Organization",
           "City", "State", "URL")
  ## Location Data Processing
  data <- reactive({
    filter(df, State == input$state)
  })
  
  city_map <- reactive({
    read.csv("uscitiesv1.4.csv", stringsAsFactors = FALSE) %>% 
      filter(state_id == input$state)
  })
  
  state_data <- reactive({
    inner_join(data(), city_map(), by = c("City" = "city"))
  })
  
  country_data <- reactive({
    inner_join(df, read.csv("uscitiesv1.4.csv", stringsAsFactors = FALSE), by = c("City" = "city"))
  })
  state_name <- reactive({
    abbr2state(input$state)
  })
  
  output$plot <- renderPlot({
    ggplot() +
      geom_polygon(data = map_data("state", region = state_name()), aes(x=long, y=lat, group = group)) +
      coord_fixed(1.3) +
      geom_point(data = state_data(), aes(x=lng, y=lat), color="red", size = 3, na.rm = TRUE) +
      ggtitle(paste("Hate Crimes in", state_name()))
  })
  
  output$country_plot <- renderPlot({
    ggplot() +
      geom_polygon(data = map_data("usa"), aes(x=long, y=lat, group = group)) +
      coord_fixed(1.3) +
      geom_point(data = country_data(), aes(x=lng, y=lat), color="blue", size = 1, na.rm = TRUE) +
      ggtitle("Hate Crimes in USA")
  })
  
  observations <- reactive({
    summarize(state_data(), n = n())
  })
  
  output$num_observations <- renderText({
    num <- observations()
    state <- state_name()
    message <- paste("In 2017, there were", num[1, 1], "hate crimes reported in", state)
    return(message)
  })
  
  ## Time Data Processing
  df <- mutate(df, Crime_Date = as.Date(Crime_Date, format = "%m/%d/%Y"))
  change_data <- reactive({
    mutate(df, Month = months(df$Crime_Date)) %>% 
      mutate(Day = day(df$Crime_Date)) 
  })
  month_data <- reactive({
      filter(change_data(), Month == input$month)
  })
  output$month_plot <- renderPlot({
      hist(month_data()$Day, main = paste("Crimes in", input$month), xlab = "Date of Crime",
           ylab = "# of crimes", col = "red", labels = TRUE)
  })
  output$all_months <- renderPlot({
    hist(change_data()$Month, main = "Crimes in 2017", xlab = "Month",
         ylab = "# of crimes", col = "blue", labels = TRUE)
  })
}

shinyServer(server)
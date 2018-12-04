#install.packages(c("ggplot2", "mapdata", "maptools", "openintro", "ggmap", "googleway"))
library(shiny)
library(dplyr)
library(ggplot2)
library(mapdata)
library(maptools)
library(openintro)
library(googleway)
library(ggmap)

server <- function(input, output) {
  df <- read.csv("20170816_Documenting_Hate .csv", stringsAsFactors = FALSE)
  colnames(df) <- c("Article Date", "Crime Date", "Summary", "Organization",
                    "City", "State", "URL", "Blank 1", "Blank 2")
  df <- df %>% 
    select("Article Date", "Crime Date", "Summary", "Organization",
           "City", "State", "URL")
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
  
  observations <- reactive({
    summarize(state_data(), n = n())
  })
  
  output$num_observations <- renderText({
    num <- observations()
    state <- state_name()
    message <- paste("In 2017, there were", num[1, 1], "hate crimes reported in", state)
    return(message)
  })
}

shinyServer(server)
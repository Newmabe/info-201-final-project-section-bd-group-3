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
  
  #City tab
  us_cities <- data.frame(read.csv("uscitiesv1.4.csv"), stringsAsFactors = FALSE)
  city_data <- data.frame(city = unique(df$City), stringsAsFactors = FALSE)
  counts <- c()
  city_density <- c()
  for(city_name in city_data$city){
    counts <- c(counts, nrow(filter(df, city_name == City)))
    city_density <- c(city_density, mean(filter(us_cities, city_name == city)$density))
  }
  city_data <- mutate(mutate(city_data, count = counts), density = city_density)
  rm(us_cities)
  
  city_selection <- reactive({
    return(filter(city_data, city == input$city))
  })
  
  output$city_plot <- renderPlot(ggplot(city_data) +
    geom_point(mapping = aes(x = density, y = count)) +
      geom_smooth(mapping = aes(x = density, y = count))+
      coord_cartesian(xlim = c(0, 3000), ylim = c(0, 300))
  )
  
  output$city_text <- renderText(c("In 2017, the population density of", city_selection()$city, "was",
                                   as.character(city_selection()$density),"people per square mile and there were",
                                   as.character(city_selection()$count), "reported hate crimes."))
}

shinyServer(server)
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
  hate_data <- read.csv("20170816_Documenting_Hate .csv", 
                        stringsAsFactors = FALSE)

  colnames(hate_data) <- c("Article_Date", "Crime_Date", "Summary", 
                           "Organization", "City", "State", "URL", "Blank 1", 
                           "Blank 2")
  df <- hate_data %>% 
    select("Article_Date", "Crime_Date", "Summary", "Organization",
           "City", "State", "URL")
  #time data processing
  with_month_day <- mutate(hate_data, Article.Date = mdy_hm(Crime_Date)) %>% 
     mutate(month = month(Article.Date), Day = day(Article.Date)) %>% 
     mutate(State = replace(State, State == "", "No State Given")) %>% 
     select("Summary", "State", "Article.Date", month, Day)
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
  
  output$summary <- renderText({
    states_data <- data.frame(state = unique(abbr2state(df$State)), stringsAsFactors = FALSE)
    counts <- c()
    for(state_name in states_data$state) {
      counts <- c(counts, nrow(filter(df, state_name == State)))
    }
    states_data <- mutate(states_data, count = counts)
    maximum <- 0
    for(count in states_data$count) {
      maximum <- max(maximum, count)
    }
    max_crime <- filter(states_data, count == maximum)
    return (paste("The most hate crimes occurred in", max_crime[1, 1], "with", maximum, "crimes reported in 2017."))
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
  output$time_selectors <- renderPlot({
     
     month_data <- filter(with_month_day, (Article.Date > ymd(input$daterange[1]) & 
                                              Article.Date < ymd(input$daterange[2])))
     top_data <- filter(month_data, State %in% 
                           (top_n(data.frame(table(month_data$State)), 6) %>% 
                               pull("Var1")))
     ggplot(data=top_data, aes(Article.Date, fill = State)) + 
        geom_density(alpha = 0.3, adjust=1/4) + 
        labs(title = "Most Popular States", x = "Date", 
             subtitle = "Click on Graph to see popular news articles for that day",
             y = "Proportion of News Articles", color = "Top Locations") +
        theme(plot.title = element_text(lineheight = 1.5, face = "bold", 
                                        hjust = 0.5))
  })
  output$month_plot <- renderPlot({
      hist(month_data()$Day, main = paste("Crimes in", input$month), xlab = "Date of Crime",
           ylab = "# of crimes", col = "red", labels = TRUE)
  })
  output$all_months <- renderPlot({
    hist(change_data()$Month, main = "Crimes in 2017", xlab = "Month",
         ylab = "# of crimes", col = "blue", labels = TRUE)
  })
  
  output$top_stories <- renderTable({
     #https://shiny.rstudio.com/articles/plot-interaction.html
     x_val <- function(e) {
        if(is.null(e)) return("NULL\n")
        return(round(e$x, 1))
     }
     clicked_time <- (as_datetime(x_val(input$plot_click)))
     day_data <- select(with_month_day, Summary, month, State, Day) %>% 
        filter(Day == day(clicked_time), month == month(clicked_time))
     top_state <- filter(day_data, State %in% 
                 (top_n(data.frame(table(day_data$State)), 6) %>% 
                             pull("Var1")))
     select(top_state, State, Headline = Summary)
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
  
  output$cities_plot <- renderPlot(ggplot(city_data) +
    geom_point(mapping = aes(x = density, y = count)) +
      geom_smooth(mapping = aes(x = density, y = count))+
      coord_cartesian(xlim = c(0, 3000), ylim = c(0, 300))
  )
  
  city_selection <- reactive({
    return(filter(city_data, city == input$city))
  })
  
  city_selection_color <- reactive({
    colors <- c()
    for(city_name in city_data$city){
      if(city_name == input$city){
        colors <- c(colors, 'red')
      } else{
        colors <- c(colors, NA)
      }
    }
    return(colors)
  })
  
  output$cities_text <- renderText("The graph above plots population density vs number of hate crimes for all cities contained in the dataset.
                                   The graph does not seem to have a significant trend for number of hate crimes reported as population density increases.")
  
  output$city_plot <- renderPlot(ggplot(city_data, aes(x = "", y = count, fill = city_selection_color())) +
                                  geom_bar(width = 1, stat = 'identity') +
                                  coord_polar("y", start=0) +
                                   theme(legend.position = 'none')
                                  )
  
  output$city_text <- renderText(c("In 2017, the population density of", city_selection()$city, "was",
                                   as.character(city_selection()$density),"people per square mile and there were",
                                   as.character(city_selection()$count), "reported hate crimes. In the graph above, the colored in
                                   section is the percentage of total hate crime in the US in that city."))
}

shinyServer(server)
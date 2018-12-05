library(shiny)

ui <- navbarPage(
  "Hate Crimes in 2017",
  tabPanel("Location",
           sidebarLayout(
             sidebarPanel(
               textInput("state", "Please enter the two letter abbreviation
                         of a state (ex. WA)", "WA")
             ),
             mainPanel(
               plotOutput("plot"),
               textOutput("num_observations"),
               plotOutput("country_plot"),
               textOutput("summary")
             )
           )),
  tabPanel("Time",
           sidebarLayout(
             sidebarPanel(
                dateRangeInput("daterange", "Date range:",
                               start = "2017-2-13",
                               end = "2017-8-30",
                               min = "2017-2-13",
                               max = "2017-8-31"), 
             selectInput("month", "Please select a month:",
                         c("February", "March",
                           "April", "May", "June", "July",
                           "August"), "February")
               
             ), mainPanel(
               plotOutput("time_selectors", click = "plot_click"),
               tableOutput("top_stories"),
               plotOutput("month_plot"),
               plotOutput("all_months")
               
             )
           )),
  tabPanel("Cities",
           sidebarLayout(
             sidebarPanel(
               textInput('city',"Enter the name of a city(case sensitive)",'Seattle')
             ),
             mainPanel(
               plotOutput("cities_plot"),
               textOutput('cities_text'),
               plotOutput('city_plot'),
               textOutput('city_text')
               ))
          )
)

shinyUI(ui)
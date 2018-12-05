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
               selectInput("month", "Please select a month:",
                           c("February", "March",
                             "April", "May", "June", "July",
                             "August"), "February")
             ), mainPanel(
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
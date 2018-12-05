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
               textOutput("num_observations")
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
               plotOutput("month_plot"),
               plotOutput("all_months"), 
               plotOutput("time_selectors"),
               textOutput("test")
             )
           )),
  tabPanel("Demographics",
           mainPanel(
             plotOutput("demographic_groups")))
)

shinyUI(ui)
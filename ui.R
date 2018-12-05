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
                               start = "2018-2-13",
                               end = "2018-8-30",
                               min = "2018-2-13",
                               max = "2018-8-31")
                ), mainPanel(
               plotOutput("month_plot"),
               plotOutput("all_months")
             )
           )),
  tabPanel("Demographics",
           mainPanel(
             plotOutput("demographic_groups")))
)

shinyUI(ui)
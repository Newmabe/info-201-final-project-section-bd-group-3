library(shiny)

ui <- navbarPage(
  "Hate Crimes in 2017",
  tabPanel("Location",
           sidebarLayout(
             sidebarPanel(
               textInput("state", "Please enter the two letter abbreviation
                         of a state (ex. WA)", "WA")
             ),
             plotOutput("plot")
           )),
  tabPanel("Time",
           sidebarLayout(
             sidebarPanel(
               selectInput("month", "Please select a month:",
                           c("January", "February", "March",
                             "April", "May", "June", "July",
                             "August", "September",
                             "October", "November", "December"))
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
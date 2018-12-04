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
               selectInput("month", "Please select a month:",
                           c("February", "March",
                             "April", "May", "June", "July",
                             "August"))
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
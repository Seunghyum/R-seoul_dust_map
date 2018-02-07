#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  navbarPage("서울 미세먼지 관련 지표"),
  titlePanel("기간별 미세먼지 농도"),
  sidebarLayout(
    sidebarPanel(
      dateInput("date", "Date:", value = "2017-01-01", format = "yyyy-mm-dd"),
      sliderInput("time", "시간", min = 01, max = 24, value = 12),
      selectInput(inputId = "topic",
                  label = "Choose a dataset:",
                  choices = c("PM10", "PM25","SO2","O3","CO"))
    ),
    
    mainPanel(
      plotlyOutput("seoul"),
      textOutput("absence_data")
    )
  ),
  fluidRow(
    column(10, offset = 1,
           dataTableOutput("table")
    )
  )
))
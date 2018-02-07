library(ggplot2)
library(rgeos)
library(maptools)
library(raster) # getData함수로 서울지도 쓰려면 적용해야함
library(viridis) # 색맹, 색약을 고려한 색상 라이브러리
library(ggmap)
library(shiny)
library(plotly)

#seoul_map <- read.csv("final_data.csv", header=T, as.is=T)


ui <- fluidPage(
  
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
      dataTableOutput("table"),
      textOutput("absence_data")
    )
  )
)

server <- function(input, output, session) {

  output$seoul <- renderPlotly({
    
    date <- gsub("-","",input$date)
    datetime <- paste(date, input$time, sep="")
    # setwd("/Users/seunghyunmoon/Code/R_Studio/dust")
    fileName <- paste("./data/", datetime, ".csv", sep="")
    seoul_map_1 <- read.csv(fileName, header=T, as.is=T)
    
    tryCatch(seoul_map_1[seoul_map_1$day == datetime,],
       error = function(e) print("I am error"),
       warning = function(w) print("I am warning"),
       finally = NULL
    )
    
    topicData <- reactive({
      switch(input$topic,
         "SO2" = as.vector(seoul_map_1$SO2),
         "O3" = as.vector(seoul_map_1$O3),
         "CO" = as.vector(seoul_map_1$CO),
         "PM10" = as.vector(seoul_map_1$PM10),
         "PM25" = as.vector(seoul_map_1$PM25)
      )
    })
    topic <- topicData()
    
    
    
    p <- ggplot(seoul_map_1, aes(x=long, y=lat, text=paste(location.station.kr.name, "\n", input$topic,":", topic))) + 
      geom_polygon(aes(fill=topic, group=measuring.code)) + 
      theme(
        plot.background = element_blank()
        ,panel.background = element_blank()
        ,panel.grid.major = element_blank()
        ,panel.grid.minor = element_blank()
        ,panel.border = element_blank()
        ,axis.title=element_blank()
        ,axis.text=element_blank()
        ,axis.ticks=element_blank()
      ) + scale_fill_viridis(direction=-1) + labs(fill = topic)
    
    ggplotly(p, tooltip="text")
    
  })
  
  #output$table <- renderDataTable(seoul_map)
  
}

shinyApp(ui, server)


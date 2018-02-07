#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$seoul <- renderPlotly({
    
    date <- gsub("-","",input$date)
    datetime <- paste(date, input$time, sep="")
    setwd("/Users/seunghyunmoon/Code/R_Studio/dust")
    fileName <- paste("./data/", datetime, ".csv", sep="")
    seoul_map_1 <<- read.csv(fileName, header=T, as.is=T)
    
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
        #,panel.background = element_blank()
        ,panel.grid.major = element_blank()
        ,panel.grid.minor = element_blank()
        ,panel.border = element_blank()
        ,axis.title=element_blank()
        ,axis.text=element_blank()
        ,axis.ticks=element_blank()
      ) + scale_fill_viridis(direction=-1) + labs(fill = topic)
    
    ggplotly(p, tooltip="text")
    
  })
  
  seoul_tb <<- read.csv("./data/representitive_region.csv", header=T, as.is=T)
  output$table <- renderDataTable(seoul_tb)
})

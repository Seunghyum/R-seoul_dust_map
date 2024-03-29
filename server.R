library(shiny)

shinyServer(function(input, output) {
  
  getDateTime <- reactive({
    date <- gsub("-","",input$date)
    datetime <<- paste(date, input$time, sep="")
  })
  
  output$seoul <- renderPlotly({
    
    datatime <- getDateTime()
    fileName <- paste("./data/", datetime, ".csv", sep="")
    
    print(fileName)
    
    result <<- read.csv(fileName, header=T, as.is=T)
    
    tryCatch(result[result$day == datetime,],
             error = function(e) print("I am error"),
             warning = function(w) print("I am warning"),
             finally = NULL
    )
    
    topicData <- reactive({
      switch(input$topic,
             "SO2" = as.vector(result$SO2),
             "O3" = as.vector(result$O3),
             "CO" = as.vector(result$CO),
             "PM10" = as.vector(result$PM10),
             "PM25" = as.vector(result$PM25)
      )
    })
    
    topic <- topicData()
    
    p <- ggplot(result, aes(x=long, y=lat, text=paste(location.station.kr.name, "\n", input$topic,":", topic))) + 
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
})

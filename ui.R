shinyUI(navbarPage("서울 미세먼지 관련 지표",
    tabPanel("지도",
       tags$head(
         tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
       ),
       fluidPage(theme = shinytheme("flatly"),
         fluidRow(
           column(3,
                  h1("미세먼지", class="title1"),
                  h1("건강영향", class="title2"),
                  h1("데이터", class="title3"),
                  br(),
                  dateInput("date", "날짜:", value = "2017-01-01", format = "yyyy-mm-dd"),
                  sliderInput("time", "시간", min = 01, max = 24, value = 12),
                  selectInput(inputId = "topic",
                              label = "Choose a dataset:",
                              choices = c("PM10", "PM25","SO2","O3","CO")),
                  hr()
           ),
           column(9,
                  plotlyOutput("seoul")
           )
         )
       )
    ),
    tabPanel("그래프")
  )
)

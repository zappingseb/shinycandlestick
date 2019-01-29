# Example app for the candlestick input

library(shiny)

devtools::load_all(".")


ui <- fluidPage(
  shinyjs::useShinyjs(),
  titlePanel("Custom input example"),
  
  fluidRow(
    column(4, wellPanel(
      CandleStick(id="myurl",candlestick_mode='option', candlestick_size="md"),
      tags$br(),
      CandleStick(id="mf",candlestick_mode='contents', candlestick_size="sm"),
      tags$br(),
      CandleStick(id="mfstick2",candlestick_mode='contents', candlestick_size="sm",
                  left=c("f"="female"),
                  right=c("m"="male"),
                  default=c("b"="both")
                  ,fa_mode=FALSE,
                  contents_color = 'red')
    )),
    column(8, wellPanel(
      verbatimTextOutput("urlText"),
      verbatimTextOutput("mfout"),
      verbatimTextOutput("mf2out")
    ))
  )
)

server <- function(input, output, session) {
    
    output$urlText <- renderText({
      as.character(input$myurl)
    })
    output$mfout <- renderText({
      as.character(input$mf)
    })
    output$mf2out <- renderText({
      as.character(input$mfstick2)
    })
    
    
}

shinyApp(ui=ui,server=server)
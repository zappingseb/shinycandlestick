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
      CandleStick(id="mf",candlestick_mode='contents', candlestick_size="sm")
    )),
    column(8, wellPanel(
      verbatimTextOutput("urlText"),
      verbatimTextOutput("mfout")
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
    
    
}

shinyApp(ui=ui,server=server)
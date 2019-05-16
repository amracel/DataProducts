library(shiny)
library(plotly)

shinyUI(fluidPage(
  titlePanel("Evaluate the Type of Oil"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("palmitic","Palmitic: ", 4,15, step = 0.1, value = 9.7),
      sliderInput("stearic","Stearic: ",1,8, step = 0.1, value = 5.2),
      sliderInput("oleic","Oleic: ",20, 80, step = 0.1, value = 31),
      sliderInput("linoleic","Linoleic", 8, 70, step = 0.1, value = 52.7),
      sliderInput("linolenic","Linolenic", 0.1, 10.0, step = 0.1, value = 0.4),
      sliderInput("eicosanoic","Eicosanoic",0.1, 3, step = 0.1, value = 0.4),
      sliderInput("eicosenoic","Eicosenoic", 0.1, 2, step = 0.1, value = 0.1)
    ),
    mainPanel(
      plotlyOutput("oilWheel"),
      h3("Documentation"),
      p("This project uses the caret oil data set. This set contains data
        related to fatty acid compositions of commercial oils, measured
        using gas chromatography. By manipulating the different fatty
        acid compositions with the slider bars, you can see what type
        of oil would be represented.")
    )
  )
))
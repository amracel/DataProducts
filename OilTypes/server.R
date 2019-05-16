library(shiny)
library(plotly)
library(caret)
library(class)

shinyServer(
  function(input, output) {
    data("oil")
    oil <- fattyAcids

    oily <- data.frame("A" = "Pumpkin", "B" = "Sunflower", "C" = "Peanut",
                       "D" = "Olive", "E" = "Soybean", "F" = "Rapeseed", 
                       "G" = "COrn")
    
    nor <- function(x) { x - min(x)/(max(x) - min(x))}
    
    modelPred <- reactive({
      # get the user data into a data frame
      user_input <- data.frame("Palmitic" = as.numeric(input$palmitic), "Stearic" = as.numeric(input$stearic),
                               "Oleic" = as.numeric(input$oleic), "Linoleic" = as.numeric(input$linoleic),
                               "Linolenic" = as.numeric(input$linolenic), "Eicosanoic" = as.numeric(input$eicosanoic),
                               "Eicosenoic" = as.numeric(input$eicosenoic))
      
      # merge it in so our normalizing will be consistent
      oilFull <- rbind(fattyAcids, user_input)
      oilNorm <- as.data.frame(lapply(oilFull, nor))
      # split back out the user's data row
      user_norm <- oilNorm[nrow(oilNorm),]
      oil_norm <- oilNorm[-c(nrow(oilNorm)),]
      
      pred <- knn(oil_norm, user_norm, cl=oilType, k=13)
      which(colnames(oily) == pred)
    })
    output$oilWheel <- renderPlotly({
      base_plot <- plot_ly(
        type = "pie",
        values = c(40, 10, 10, 10, 10, 10, 10,10,10),
        labels = c("-", "-", "-", "-", "-", "-", "-","-","-"),
        rotation = 108,
        direction = "clockwise",
        hole = 0.4,
        textinfo = "label",
        textposition = "outside",
        hoverinfo = "none",
        domain = list(x = c(0, 0.48), y = c(0, 1)),
        marker = list(colors = c('rgb(255, 255, 255)', 'rgb(255, 255, 255)', 'rgb(255, 255, 255)', 'rgb(255, 255, 255)', 'rgb(255, 255, 255)', 'rgb(255, 255, 255)', 'rgb(255, 255, 255)')),
        showlegend = FALSE
      )
      
      base_plot <- add_trace(
        base_plot,
        type = "pie",
        values = c(30, 10, 10, 10, 10, 10,10,10),
        labels = c("Oil Type","Pumpkin","Sunflower","Peanut","Olive","Soybean","Rapeseed","Corn"),
        rotation = 90,
        direction = "clockwise",
        hole = 0.3,
        textinfo = "label",
        textposition = "inside",
        hoverinfo = "none",
        domain = list(x = c(0, 0.48), y = c(0, 1)),
        marker = list(colors = c('rgb(255, 255, 255)', 'rgb(232,226,202)', 'rgb(226,210,172)', 'rgb(223,189,139)', 'rgb(223,162,103)', 'rgb(226,126,64)')),
        showlegend= FALSE
      )
      
      a <- list(
        showticklabels = FALSE,
        autotick = FALSE,
        showgrid = FALSE,
        zeroline = FALSE)
      
      b <- list(
        xref = 'paper',
        yref = 'paper',
        x = 0.23,
        y = 0.45,
        showarrow = FALSE,
        text = '-')

      pathList <- c('M 0.200 0.50 L 0.18 0.40 L 0.250 0.5 Z',
                    'M 0.235 0.45 L 0.16 0.45 L 0.250 0.5 Z',
                    'M 0.220 0.45 L 0.18 0.53 L 0.245 0.5 Z',
                    'M 0.228 0.5 L 0.20 0.58 L 0.245 0.5 Z',
                    'M 0.235 0.5 L 0.24 0.62 L 0.245 0.5 Z',
                    'M 0.235 0.5 L 0.28 0.62 L 0.245 0.5 Z',
                    'M 0.235 0.5 L 0.30 0.54 L 0.245 0.5 Z')
      
      chosenPath <- pathList[modelPred()]
      base_chart <- layout(
        base_plot,
        shapes = list(
          list(
            type = 'path',
            path = pathList[modelPred()],
            #path = 'M 0.235 0.5 L 0.28 0.62 L 0.245 0.5 Z', # rapeseed
            #path = 'M 0.235 0.5 L 0.24 0.62 L 0.245 0.5 Z', # soybean
            #path = 'M 0.228 0.5 L 0.20 0.58 L 0.245 0.5 Z', # olive
            #path = 'M 0.220 0.45 L 0.18 0.53 L 0.245 0.5 Z', # peanut
            #path = 'M 0.235 0.45 L 0.16 0.45 L 0.250 0.5 Z', # sunflower
            #path = 'M 0.200 0.50 L 0.18 0.40 L 0.250 0.5 Z', # pumpkin
            xref = 'paper',
            yref = 'paper',
            fillcolor = 'rgba(44, 160, 101, 0.5)'
          )
        ),
        xaxis = a,
        yaxis = a,
        annotations = b
      )
      base_chart
      
    })
  }
)
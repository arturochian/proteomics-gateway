controlBarExperiments <- function(input, max.projects) {
    fluidRow(
        column(3, textInput("q", label=h5("Search"), value=input$q)  ),
        column(3, sliderInput("num.datasets", label=h5("Num datasets"), min=10, max = max.projects, value=max(10,input$num.datasets)) ),
        column(2, 
               selectInput(inputId = "x",
                           label = h5("Choose X"),
                           choices = c('species', 'tissues', 'instrumentNames'),
                           selected = input$x), 
               checkboxInput(inputId = "hide.other.x", label = "Ignore Others", value = input$hide.other.x )
        ),
        column(2, 
               selectInput(inputId = "group.var",
                           label = h5("Choose Grouping"),
                           choices = c('species', 'tissues', 'instrumentNames'),
                           selected = input$group.var), 
               checkboxInput(inputId = "hide.other.group", label = "Ignore Others", value = input$hide.other.group)
        ),       
        column(2,
               h5("Download results"),
               downloadButton('downloadExperimentData', 'CSV')
        )
    ) # fluidRow
}

resultsPlotExperiments <- function(x, y, group.by, data) {
    results.plot <- nPlot(
        y = y, x = x,
        group = group.by,
        data = data,
        type = 'multiBarChart'
    )
    #             results.plot$xAxis( axisLabel = input$x )
    results.plot$chart( showControls = F )
    results.plot$chart( reduceXTicks = FALSE )
    results.plot$xAxis( staggerLabels = TRUE )
    results.plot$addParams( width = '1200' )
    results.plot$addParams( height = '600' )
    results.plot$addParams( dom = 'resultsChart' )
    return(results.plot)
}
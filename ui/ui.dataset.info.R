controlBarDataset <- function(input, dataset.accessions) {
    fluidRow(
        column(4, 
               selectInput(inputId = "dataset.selected",
                           label = h5("Choose Dataset(s)"),
                           choices = dataset.accessions,
                           selected = input$dataset.selected,
                           multiple = FALSE,
                           selectize = TRUE)
        ),
        column(3, 
               sliderInput("max.proteins.to.show", label=h5("Max proteins"), min=0, max = 30, value=10) 
        )
    ) # fluidRow
}

resultsPlotDataset <- function(x, y, project.data, protein.data) {
    results.plot <- nPlot(
        y = y, x = x,
        data = protein.data,
        type = 'discreteBarChart'
    )

    #             results.plot$xAxis( axisLabel = input$x )
#     results.plot$chart( showControls = F )
#     results.plot$chart( reduceXTicks = TRUE )
    results.plot$xAxis( staggerLabels = TRUE )
    results.plot$addParams( width = '1200' )
    results.plot$addParams( height = '600' )
    results.plot$addParams( dom = 'resultsChart' )
    return(results.plot)
}

info <- function(project.data) {
    print(project.data$title)
}
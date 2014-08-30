require(rCharts)
require(rjson)
source("./R/projects.df.R")

shinyServer(function(input, output) {
    
    output$searchResultsChart <- renderChart({
        projects <- search_projects(input$q, input$numResults)
        ag.projects <- aggregate(projects[,'numAssays'] ~ projects[,input$x] + projects[,input$group.var], data = projects, sum)
        names(ag.projects) <- c(input$x, input$group.var, "numAssays")
        if (nrow(projects)>0) {
            resultsPlot <- nPlot(
                y = 'numAssays', x = input$x,
                group = input$group.var,
                data = ag.projects,
                type = 'multiBarChart'
            )
            resultsPlot$addParams(dom = 'searchResultsChart')
            return(resultsPlot)
        }
    })
    
})


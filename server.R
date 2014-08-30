library(shiny)
require(rCharts)
library(devtools)
install_github(user = "jadianes", repo = "prider")

shinyServer(function(input, output) {
    
#     output$myChart <- renderChart({
#         names(iris) = gsub("\\.", "", names(iris))
#         p1 <- rPlot(input$x, input$y, data = iris, color = "Species", 
#                     facet = "Species", type = 'point')
#         p1$addParams(dom = 'myChart')
#         return(p1)
#     })
    
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
#             resultsPlot <- rPlot(
#                 x = 'accession', y = 'numAssays',
#                 color = 'species', facet = 'submissionType',
#                 data = projects,
#                 type = 'point'
#             )
            resultsPlot$addParams(dom = 'searchResultsChart')
            return(resultsPlot)
            
#             ggplot(projects, aes(x=accession, y=numAssays, fill = submissionType)) +
#                 geom_bar(stat="identity") +
#                 scale_fill_manual(values = c("yellow", "orange", "red")) +
#                 theme_bw() +
#                 theme(axis.text.x=element_text(angle=-90, hjust=0))
        }
    })
    
})


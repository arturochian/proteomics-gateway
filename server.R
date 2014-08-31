require(rCharts)
require(rjson)
source("./R/projects.df.R")

shinyServer(function(input, output) {
    
    searchResults <- reactive({
        projects <- search_projects(input$q, input$numResults)
        return(projects)
    })

    aggregateProjects <- function(projects) {
        projects <- reduceColumnValues(
            projects,
            input$x,
            'numAssays',
            5,
            paste('other', input$x)
        )
        projects <- reduceColumnValues(projects, input$group.var, 'numAssays', 5, paste('other', input$group.var))
        ag.projects <- aggregate(projects[,'numAssays'] ~ projects[,input$x] + projects[,input$group.var], data = projects, sum)
        names(ag.projects) <- c(input$x, input$group.var, "numAssays")
        
        ag.projects
    }
    
    reduceColumnValues <- function(df, reduce.column.name, count.column.name, max.values, reduce.to) {
        # get top values
        agg.df <- aggregate(df[,count.column.name] ~ df[,reduce.column.name],data=df,sum)
        names(agg.df) <- c(reduce.column.name, count.column.name)
        agg.df <- agg.df[order(agg.df[,count.column.name], decreasing=TRUE),]
        top.values <- agg.df[1:min(max.values,nrow(agg.df)),reduce.column.name]
        
        # reduce data frame
        df[,reduce.column.name] <- ifelse((df[,reduce.column.name] %in% top.values), as.character(df[,reduce.column.name]), reduce.to)
        
        df
    }
    
    output$searchResultsChart <- renderChart({
        ag.projects <- aggregateProjects(searchResults())
        
        if (nrow(ag.projects)>0) {
            resultsPlot <- nPlot(
                y = 'numAssays', x = input$x,
                group = input$group.var,
                data = ag.projects,
                type = 'multiBarChart'
            )
            resultsPlot$xAxis( axisLabel = input$x )
            resultsPlot$yAxis( axisLabel = "Assay count" )
            resultsPlot$addParams(width = '1200')
            resultsPlot$addParams(height = '600')
            resultsPlot$addParams(dom = 'searchResultsChart')
            return(resultsPlot)
        }
    })
    
})



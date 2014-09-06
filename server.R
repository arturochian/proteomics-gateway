require(rCharts)
require(rjson)
source("./R/projects.df.R")

shinyServer(function(input, output, session) {
    
    maxProjects <- reactive({
        numProjects <- project_count()
        return(numProjects)
    })
    
    searchResults <- reactive({
        projects <- search_projects(input$q, input$num.results)
        return(projects)
    })

    aggregateProjects <- function(projects, other.x.label, other.group.label) {
        projects <- reduceColumnValues(
            projects,
            input$x,
            'numAssays',
            5,
            other.x.label
        )
        projects <- reduceColumnValues(
            projects, 
            input$group.var, 
            'numAssays', 
            5, 
            other.group.label
        )
        ag.projects <- aggregate(
            projects[,'numAssays'] ~ projects[,input$x] + projects[,input$group.var], 
            data = projects, 
            sum
        )
        names(ag.projects) <- c(input$x, input$group.var, "numAssays")
        ag.projects$numAssays <- as.integer(ag.projects$numAssays)
        
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
    
    prepareData <- function() {
        other.x.label <- paste('others', input$x)
        other.group.label <- paste('other', input$group.var)
        search.results.df <- searchResults() 
        if (nrow(search.results.df)>0) {
            ag.projects <- aggregateProjects(search.results.df, other.x.label, other.group.label)
            
            # filter out 'others' X if required
            if (input$hide.other.x) {
                ag.projects <- ag.projects[
                    unlist(lapply(ag.projects, function(x) { which(x != other.x.label)})[input$x]),
                    ]
            }
            
            # filter out 'others' groups if required
            if (input$hide.other.group) {
                ag.projects <- ag.projects[
                    unlist(lapply(ag.projects, function(x) { which(x != other.group.label)})[input$group.var]),
                    ]
            }
            
            ag.projects
        } else {
            ag.projects <- rbind(data.frame(),
                                 c( paste("No ",input$x), paste("No",input$group.var),0)
                            )
            names(ag.projects) <- c(input$x,input$group.var,"numAssays")
            return(ag.projects)
        }
    }
    
    output$num.results.slider <- renderUI({
        sliderInput("num.results", label=h5("Num results"), min=10, max = maxProjects(), value=20)
    })
    
    
    output$searchResultsChart <- renderChart({
        ag.projects <- prepareData()

        results.plot <- nPlot(
            y = 'numAssays', x = input$x,
            group = input$group.var,
            data = ag.projects,
            type = 'multiBarChart'
        )
#             results.plot$xAxis( axisLabel = input$x )
        results.plot$chart( showControls = F )
        results.plot$chart( reduceXTicks = FALSE )
        results.plot$xAxis( staggerLabels = TRUE )
        results.plot$addParams( width = '1200' )
        results.plot$addParams( height = '600' )
        results.plot$addParams( dom = 'searchResultsChart' )
        return(results.plot)
       
    })

    output$downloadData <- downloadHandler(
        filename = function() { paste0(input$x, "-", input$group.var, '.csv') },
        content = function(file) {
            write.csv(prepareData(), file)
        }
    )

    
})



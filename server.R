require(rCharts)
source("./R/projects.df.R")
source("./R/proteins.df.R")
source("./ui/ui.experimental.stats.R")
source("./ui/ui.dataset.info.R")

shinyServer(function(input, output, session) {
    
    maxProjects <- reactive({
        numProjects <- project_count()
        return(numProjects)
    })
    
    getDatasetAccessions <- reactive({
        dataset <- project_list(maxProjects())
        return(sort(as.character(dataset$accession)))
    })
    searchResults <- reactive({
        projects <- search_projects(input$q, input$num.datasets)
        return(projects)
    })

    aggregateProjects <- function(projects, other.x.label, other.group.label, on.field) {
        projects <- reduceColumnValues(
            projects,
            input$x,
            on.field,
            5,
            other.x.label
        )
        projects <- reduceColumnValues(
            projects, 
            input$group.var, 
            on.field, 
            5, 
            other.group.label
        )
        ag.projects <- aggregate(
            projects[,on.field] ~ projects[,input$x] + projects[,input$group.var], 
            data = projects, 
            sum
        )
        names(ag.projects) <- c(input$x, input$group.var, on.field)
        ag.projects[,on.field] <- as.integer(ag.projects[,on.field])
        
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
    
    prepareExperimentData <- function() {
        other.x.label <- paste('others', input$x)
        other.group.label <- paste('other', input$group.var)
        search.results.df <- searchResults() 
        if (nrow(search.results.df)>0) {
            ag.projects <- aggregateProjects(search.results.df, other.x.label, other.group.label,"numAssays")
            
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
    
    prepareDatasetProteinData <- function() {
        if (length(input$dataset.selected)>0) {
            dataset.proteins.df <- protein_list(input$dataset.selected, 1000)
            if (nrow(dataset.proteins.df)>0) {
                # count
                dataset.df <- data.frame(table(dataset.proteins.df$accession))
                names(dataset.df) <- c("protein.accession","frequency")
                # filter out if required
                dataset.df <- dataset.df[order(dataset.df$frequency, decreasing=TRUE),]
                return(dataset.df[c(1:input$max.proteins.to.show),])
            }
        }
            
        return(data.frame())
        
    }
    
    
    ##  Experiments UI elements
    getControlBarExperiments <- reactive({
        controlBarExperiments(input, maxProjects())
    })
    output$downloadExperimentData <- downloadHandler(
        filename = function() { paste0(input$x, "-", input$group.var, '.csv') },
        content = function(file) {
            write.csv(prepareExperimentData(), file)
        }
    )


    ##  Dataset UI elements
    getControlBarDataset <- reactive({
        controlBarDataset(input, getDatasetAccessions())
    })

    output$downloadDatasetData <- downloadHandler(
        filename = function() { paste0(input$dataset.selected, '.csv') },
        content = function(file) {
            write.csv(prepareDatasetData(), file)
        }
    )
    
    ##  Abstract factory implementation
    output$control.bar <- renderUI({
        if (input$mainNavbar=='Experiments') {
            getControlBarExperiments()
        } else if (input$mainNavbar=='Dataset') {
            getControlBarDataset()
        }
    })
    output$resultsChart <- renderChart({
        if (input$mainNavbar=='Experiments') {
            ag.projects <- prepareExperimentData() 
            resultsPlotExperiments( input$x, 'numAssays', input$group.var, ag.projects ) 
        } else if (input$mainNavbar=='Dataset') {
            dataset.proteins.df <- prepareDatasetProteinData() 
            dataset.df <- project(input$dataset.selected)
            resultsPlotDataset( 'protein.accession', 'frequency', dataset.df, dataset.proteins.df ) 
        }
    })
    output$info <- renderPrint({ 
        if (input$mainNavbar=='Dataset') {
            dataset.df <- project(input$dataset.selected)
            info( dataset.df ) 
        }
    })

    
})



library(shiny)
library(ggplot2)
library(devtools)
install_github(user = "jadianes", repo = "prider")

shinyServer(function(input, output) {
    
    output$searchResultsPlot <- renderPlot({
        projects <- search_projects(input$q, input$numResults)
        if (nrow(projects)>0) {
            ggplot(projects, aes(x=accession, y=numAssays, fill = submissionType)) +
                geom_bar(stat="identity") +
                scale_fill_manual(values = c("yellow", "orange", "red")) +
                theme_bw() +
                theme(axis.text.x=element_text(angle=-90, hjust=0))
        }
    })
    
})


# ui.R
require(rCharts)

shinyUI(
    verticalLayout(  
        ## Panels
        navbarPage(
            title = "The Proteomics Repository Gateway",
            inverse = TRUE,
            collapsable = TRUE,
            tabPanel('Experiments', 
                 ## Main view
                 showOutput( "experimentCountChart", "nvd3" )
                 ##  Controls
                 
             ), # Experiments tab
            tabPanel('Proteins',
                 ## Main view
                 showOutput( "proteinCountChart", "nvd3" )
            ), # Protein tab
            tabPanel('About', 
                 ## Main view
                 h4("About the Proteomics Gateway"),
                 p("
                    Welcome! This is a portal for visual search and statistics of proteomics data. It gathers experimental
                   metadata from different repositories (right now we just use PRIDE) into meaninful and interactive charts.
                   "),
                 p("
                    Please, feel free to play around with the different controls in each of the views. Remember that you can 
                   always export your results in CSV format for later use!"),
                 h5("The Experiments view"),
                 p("Here you can group experiment search results by two different metadata variables."),
                 h5("The Proteins view"),
                 p("Comming soon!")
            ) # About tab
        ),
        fluidPage(
            uiOutput("control.panel")
        ) # fluidPage 
        
    ) # verticalLayout
) 


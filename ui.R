# ui.R
require(rCharts)

shinyUI(
    verticalLayout(  
        ## Panels
        navbarPage(id = 'mainNavbar',
            title = "The Proteomics Repository Gateway",
            inverse = TRUE,
            collapsable = TRUE,
            tabPanel(value='Experiments', title="Experimental Stats"), # Experiments tab
            tabPanel(value='Dataset', title='Dataset Info'), # Dataset tab
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
                 h5("The Experimental Stats view"),
                 p("Here you can group experiment search results by two different metadata variables."),
                 h5("The Dataset Info view"),
                 p("Here, different pieces of information relaed to a particular dataset can be visualised.")
            ) # About tab
        ), # navbar page
        ## Main view
        showOutput( "resultsChart", "nvd3" ),
        fluidPage(h5(textOutput("info"))),
        ## Controls
        fluidPage(
            uiOutput("control.bar")
        ) # fluidPage
    ) # verticalLayout
) 


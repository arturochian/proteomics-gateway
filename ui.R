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
                 showOutput( "searchResultsChart", "nvd3" ),
                 ##  Controls
                 fluidPage(
                     fluidRow(
                         column(3, textInput("q",label=h5("Search")) ),
                         column(3, uiOutput("num.results.slider") ),
                         column(2,
                                selectInput(inputId = "x",
                                            label = h5("Choose X"),
                                            choices = c('species', 'tissues', 'instrumentNames'),
                                            selected = "species"),
                                checkboxInput(inputId = "hide.other.x", label = "Ignore Others", value = FALSE)
                         ),
                         column(2,
                                selectInput(inputId = "group.var",
                                            label = h5("Choose Grouping"),
                                            choices = c('species', 'tissues', 'instrumentNames'),
                                            selected = "tissues"),
                                checkboxInput(inputId = "hide.other.group", label = "Ignore Others", value = FALSE)
                         ),
                         column(2,
                                h5("Download results"),
                                downloadButton('downloadData', 'CSV')
                         )
                     ) # fluidRow
                 ) # fluidPage 
             ), # Experiments tab
            tabPanel('About', 
                 ## Main view
                 h4("About the Proteomics Gateway"),
                 p("
                    Welcome! This is a portal for visual search and statistics of proteomics data. It gathers experimental
                   metadata from different repositories (right now we just use PRIDE) into meaninful and interactive charts.
                   "),
                 p("
                    Please, feel free to play around with the different controls in each of the views. Remember that you can 
                   always export your results in CSV format for later use!")
            ) # About tab
        )
        
        
    ) # verticalLayout
) 


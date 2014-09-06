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
                     showOutput( "searchResultsChart", "nvd3" )
             )
        ),
        
        ##  Controls
        fluidPage(
            fluidRow(
                column(3,
                    textInput("q",label=h5("Search"))
                ),
                          
#                           selectInput("sizeVar", 
#                                       label = "Choose count to display",
#                                       choices = c("Assays", "Proteins", "Peptides", "Spectra"),
#                                       selected = "Assays"),
                          
                column(3,
#                     sliderInput("num.results", label = h5("Num results"), min = 20, 
#                               max = 1000, value = 20),
                    uiOutput("num.results.slider")
                ),
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
    ) # verticalLayout
) 


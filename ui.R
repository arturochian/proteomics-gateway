# ui.R
require(rCharts)

shinyUI(
    verticalLayout(  
        ## Panels
        navbarPage(
            title = "The Proteomics Repository Gateway",
            tabPanel('Experiments', 
                     showOutput( "searchResultsChart", "nvd3" )
             )
        ),
        
        ##  Controls
        fluidPage(
            fluidRow(
                column(3,
                    textInput("q",label=h4("Search"))
                ),
                          
#                           selectInput("sizeVar", 
#                                       label = "Choose count to display",
#                                       choices = c("Assays", "Proteins", "Peptides", "Spectra"),
#                                       selected = "Assays"),
                          
                column(3,
                    sliderInput("num.results", label = h5("Num results"), min = 20, 
                              max = 1000, value = 20)
                ),
                column(3,
                    selectInput(inputId = "x",
                              label = "Choose X",
                              choices = c('species', 'tissues', 'instrumentNames'),
                              selected = "species"),
                    checkboxInput(inputId = "hide.other.x", label = "Ignore Others", value = FALSE)
                ),
                column(3,
                    selectInput(inputId = "group.var",
                              label = "Choose Grouping",
                              choices = c('species', 'tissues', 'instrumentNames'),
                              selected = "tissues"),
                    checkboxInput(inputId = "hide.other.group", label = "Ignore Others", value = FALSE)
                )
            ) # fluidRow
        ) # fluidPage
    ) # verticalLayout
) 


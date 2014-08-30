# ui.R
require(rCharts)

shinyUI(fluidPage(
    titlePanel("The Proteomics Repository Gateway"),
    sidebarLayout(position = "right",
                  sidebarPanel(
                      fluidRow(
                          textInput("q",label=h4("Search")),
                          
#                           selectInput("sizeVar", 
#                                       label = "Choose count to display",
#                                       choices = c("Assays", "Proteins", "Peptides", "Spectra"),
#                                       selected = "Assays"),
                          
                          sliderInput("numResults", label = h5("Num results"), min = 10, 
                                      max = 50, value = 10),
                          selectInput(inputId = "x",
                                      label = "Choose X",
                                      choices = c('species', 'tissues', 'instrumentNames'),
                                      selected = "species"),
                          selectInput(inputId = "group.var",
                                      label = "Choose Grouping",
                                      choices = c('species', 'tissues', 'instrumentNames'),
                                      selected = "tissues")
                      )
                  ),
                  mainPanel(
                      showOutput("searchResultsChart", "nvd3")
                  )
    )
))


library(shiny)
library(rCharts) 

shinyUI(
    navbarPage("Storm Data Report",
        tabPanel("Plot",
                sidebarPanel(
                    sliderInput("range", 
                        "Range:", 
                        min = 1990, 
                        max = 2011, 
                        value = c(2000, 2011),
                        format="####"),
                    uiOutput("evtypeControls"),
                    actionButton(inputId = "clear_all", label = "Clear selection", icon = icon("check-square")),
                    actionButton(inputId = "select_all", label = "Select all", icon = icon("check-square-o"))
                ),
                mainPanel( 
                    tabsetPanel(
                      # Summary 
                      tabPanel(p(icon("list-alt"), "Summary"),
                               mainPanel(
                                 includeMarkdown("README.md")
                               )
                               
                               
                      ),                    
                    # Time series data
                    tabPanel(p(icon("line-chart"), "By year"),
                                 h4('Number of events by year', align = "center"),
                                 showOutput("eventsByYear", "nvd3"),
                                 h4('Population impact by year', align = "center"),
                                 showOutput("populationImpact", "nvd3"),
                                 h4('Economic impact by year', align = "center"),
                                 showOutput("economicImpact", "nvd3")
                        )
                    )
                ) 
        )
    )
)

library(shiny)

library(ggplot2)
library(rCharts)
library(ggvis)

library(data.table)
library(reshape2)
library(dplyr)
library(markdown)
library(mapproj)
library(maps)

#loading include file with helper functions
source("include.R", local = TRUE)


#data loading
dt <- fread('data/events.agg.csv') %>% mutate(EVTYPE = tolower(EVTYPE))
evtypes <- sort(unique(dt$EVTYPE))

shinyServer(function(input, output, session) {
    
    #defining and initializing reactive values
    values <- reactiveValues()
    values$evtypes <- evtypes
    
    #event type checkbox
    output$evtypeControls <- renderUI({
        checkboxGroupInput('evtypes', 'Event types', evtypes, selected=values$evtypes)
    })
    
    #observers for clear and select all
    observe({
        if(input$clear_all == 0) return()
        values$evtypes <- c()
    })
    
    observe({
        if(input$select_all == 0) return()
        values$evtypes <- evtypes
    })

    #time series data
    dt.agg.year <- reactive({
      dataset.by.year(dt, input$range[1], input$range[2], input$evtypes)
    })
    
    #yearly events
    output$eventsByYear <- renderChart({
      events.by.year.plot(dt.agg.year())
    })
    
    #population impact
    output$populationImpact <- renderChart({
      impact.by.year.plot(
            dt = dt.agg.year() %>% select(Year, Injuries, Fatalities),
            dom = "populationImpact",
            yAxisLabel = "Affected",
            desc = TRUE
        )
    })
    
    #economic impact
    output$economicImpact <- renderChart({
      impact.by.year.plot(
            dt = dt.agg.year() %>% select(Year, Crops, Property),
            dom = "economicImpact",
            yAxisLabel = "Total damages (in million $)"
        )
    })
    
})



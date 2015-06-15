
#aggregate dataset by year 
dataset.by.year <- function(dt, year_min, year_max, evtypes) {
    round_2 <- function(x) round(x, 2)
    
    #iltering data
    dt %>% filter(YEAR >= year_min, YEAR <= year_max, EVTYPE %in% evtypes) %>%
      
    #aggrigation abd grouping
    group_by(YEAR) %>% summarise_each(funs(sum), COUNT:CROPDMG) %>%
      
    #rounding
    mutate_each(funs(round_2), PROPDMG, CROPDMG) %>%
    rename(
        Year = YEAR, Count = COUNT,
        Fatalities = FATALITIES, Injuries = INJURIES,
        Property = PROPDMG, Crops = CROPDMG
    )
}

#impact by year plot

impact.by.year.plot <- function(dt, dom, yAxisLabel, desc = FALSE) {
    impact.plot <- nPlot(
        value ~ Year, group = "variable",
        data = melt(dt, id="Year") %>% arrange(Year, if (desc) { desc(variable) } else { variable }),
        type = "stackedAreaChart", dom = dom, width = 650
    )
    impact.plot$chart(margin = list(left = 100))
    impact.plot$yAxis(axisLabel = yAxisLabel, width = 80)
    impact.plot$xAxis(axisLabel = "Year", width = 70)
    
    impact.plot
}

#events by year plot

events.by.year.plot <- function(dt, dom = "eventsByYear", yAxisLabel = "Count") {
    events.by.year <- nPlot(
        Count ~ Year,
        data = dt,
        type = "lineChart", dom = dom, width = 650
    )
        
    events.by.year$chart(margin = list(left = 100))
    events.by.year$yAxis( axisLabel = yAxisLabel, width = 80)
    events.by.year$xAxis( axisLabel = "Year", width = 70)
    events.by.year
}

# New script for the temperature forecast app in Shiny

library(shiny)
library(dplyr)
library(DT)
library(ggplot2)
library(shinydashboard)
library(dygraphs)
library(plotly)
library(shinythemes)
library(prophet)
library(leaflet)

#m.data <- read.csv("C:/Users/Taha/Documents/simple-app/temp_algeria.csv", header = T, stringsAsFactors = T)
m.data <- read.csv("temp_algeria.csv", header = T, stringsAsFactors = T)

m.data$ds <- as.Date(m.data$ds,format = "%Y-%m-%d")

colnames(m.data) <- c("Country", "State", "ds", "y", "elevation", "coord", "lat", "alt")

ui <- dashboardPage(
  
  dashboardHeader(
    
    title = ('Temperature Forecast in Algeria'), titleWidth = 500),
  
  dashboardSidebar(
    
    width = 250,
    
    selectInput("Country", "Country",
                choices = c(as.character(unique(m.data$Country))),
                multiple = FALSE),
    
    uiOutput("state"),
    
    br(), br(), br(), br(), br(), br(), br(), br(), br(),
    br(), br(), br(), br(), br(), br(), br(), br(), br(),
    
    actionButton("credit", "Created by: Taha Bouhoun", width = '88%',
                 style="color: #ffffff; background-color: #000000; border-color: #000000"),
    
    actionButton("email", "taha@minerva.kgi.edu",
                 icon = icon("envelope-open", "fa-2x"),
                 width = '88%', style="color: #fff; background-color: #3b49b5; border-color: #3b49b5")
  ),
  
  dashboardBody(
    
    tags$head(tags$style(HTML('
      .main-header .logo {
        font-family: "Trebuchet MS", sans-serif;
        font-size: 2em;
        letter-spacing: -1px;
        border-bottom: 2px solid black;
        text-transform: uppercase;
      }
    '))),
    
    tabBox(width = '100%', height = '100%', selected = NULL,
           tabPanel('Data & Graphs', icon = icon("equalizer", lib="glyphicon"),
    fluidRow(
      box(width = 6, title = 'Basic Information', status = "primary",
          solidHeader = TRUE, collapsible = TRUE,
          infoBoxOutput("o.min.date", width = 6),
          infoBoxOutput("o.max.date", width = 6),
          
          infoBoxOutput("o.min.temp", width = 6),
          infoBoxOutput("o.max.temp", width = 6),
          
          infoBoxOutput("o.number.datapoints", width = 6),
          infoBoxOutput("o.perc.na", width = 6),
  
          infoBoxOutput("o.sample1", width = 6),
          infoBoxOutput("o.sample2", width = 6)),
      
      box(title = 'Historical Monthly Temperature', status = "primary",
          solidHeader = TRUE, collapsible = TRUE,
          align="center", width = 6, plotlyOutput("plot1", width = '100%'))
    ),
    
    br(),
    
    fluidRow(
      box(title = 'Fitting the Best Model', status = "success",
          solidHeader = TRUE, collapsible = TRUE,
          align="center", width = 6, dygraphOutput("forecast_plot", width = '100%')),
      
      box(title = 'Long-term Trend and Seasonality', status = "success",
          solidHeader = TRUE, collapsible = TRUE,
          align="center", width = 6, plotOutput("component_plot", width = '100%'))
    )
    ),
    
    tabPanel('Map', icon = icon("globe", lib="glyphicon"),
             leafletOutput("mymap", height = 550)),
    
    tabPanel('About', icon = icon("cog", lib="glyphicon"),
             fluidPage(box(column(includeHTML('base.html'), width = 8, offset = 2), 
                           width = 12, status = 'primary'))
             )
  )
  )
)

server <- function(input, output) {
  
  selected.country <- reactive({
    data.country <- subset(m.data, Country == input$Country)
    data.country
  })
  
  output$state <- renderUI({selectInput("State", "Station", 
                                        choices = c(as.character(unique(selected.country()$State))),
                                        multiple = FALSE)})
  
  selected.state <- reactive({
    data.state <- subset(selected.country(), State == input$State)
    data.state
  })
  
  output$mymap <- renderLeaflet({
    leaflet() %>% 
      addProviderTiles(providers$Stamen.Terrain) %>% setView(selected.state()$lat[1], selected.state()$alt[1], zoom = 5.5) %>% addMarkers(data = cbind(selected.state()$lat[1], selected.state()$alt[1])) %>% addCircleMarkers(data = unique(cbind(m.data$lat, m.data$alt)), radius = 5)
  })
  
  output$o.basicinfo.box <- renderValueBox({
    valueBox(value = tags$p("Basic info", style = "font-size: 70%; font-family:sans-serif;"), 
             subtitle='', width = 4)
  })
  
  output$o.number.datapoints <- renderInfoBox({
    infoBox(title = "Number of records", value = dim(selected.state())[1],
            icon = icon("info-sign", lib="glyphicon"), width = 2)
  })
  
  
  output$o.perc.na <- renderInfoBox({
    infoBox(title = "Percentage of Missing values",
            value = paste(round((sum(is.na(selected.state()$y))/length(selected.state()$y)*100), digits = 2),"%"),
            icon = icon("warning-sign", lib="glyphicon"))
  })
  
  output$o.min.date <- renderInfoBox({
    infoBox(title = "Record starts from",
            value = min(selected.state()$ds, na.rm = T),
            icon = icon("calendar", lib = "glyphicon"))
  })
  
  output$o.max.date <- renderInfoBox({
    infoBox(title = "Record ends at",
            value = max(selected.state()$ds, na.rm = T),
            icon = icon("calendar", lib = "glyphicon"))
  })
  
  output$o.min.temp <- renderInfoBox({
    infoBox(title = "Minimum Average Temperature",
            value = min(selected.state()$y, na.rm = T),
            icon = icon("cloud", lib="glyphicon"))
  })
  
  output$o.max.temp <- renderInfoBox({
    infoBox(title = "Maximum Average Temperature",
            value = max(selected.state()$y, na.rm = T),
            icon = icon("fire", lib="glyphicon"))
  })
  
  output$o.sample1 <- renderInfoBox({
    infoBox(title = "Elevation from Sea Level",
            value = paste(selected.state()$elevation[1], 'meters'),
            icon = icon("object-align-bottom", lib="glyphicon"))
  })
  
  output$o.sample2 <- renderInfoBox({
    infoBox(title = "Geographical Coordinates",
            value = paste(selected.state()$coord[1]),
            icon = icon("map-marker", lib="glyphicon"))
  })
  
  
  model <- reactive({
    req(selected.state())
    forecast.dates <- selected.state() %>% select(3,4)
    model <- prophet(forecast.dates)
    return(model)
  })
  
  #model_dup <- duplicatedRecative(model)
  
  future <- reactive({
    req(model())
    make_future_dataframe(model(), freq='month', periods = 240)
  })
  
  #future_dup <- duplicatedRecative(future)
  
  forecast <- reactive({
    req(model(), future())
    predict(model(), future())
  })
  
  #forecast_dup <- duplicatedRecative(forecast)
  
  output$plot1 <- renderPlotly({
    
    x.label <- list(title = "Date")
    y.label <- list(title = "Avg. Temperature")
    
    plot_ly(selected.state(),
      x = ~as.Date(ds, format = "%Y-%m-%d"),
      y = ~as.numeric(y),
      mode = 'markers+lines',
      line = list(color = 'rgb(148,0,211)', width = 0.5))%>%
      layout(xaxis = x.label, yaxis = y.label)
  })
  
  output$forecast_plot <- renderDygraph({
    dyplot.prophet(model(), forecast())
  })
  
  output$component_plot <- renderPlot({
    prophet_plot_components(model(), forecast())
  })
  
}

shinyApp(ui, server)
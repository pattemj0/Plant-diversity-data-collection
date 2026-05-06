setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(shiny)
library(lubridate)
library(DT)


# Function for saving data to a CSV file
log_line <- function(newdata, filename = 'plant_data.csv'){
  (dt <- Sys.time() %>% round %>% as.character)
  (newline <- c(dt, newdata) %>% paste(collapse=',') %>% paste0('\n'))
  cat(newline, file= filename, append=TRUE)
  print('Data stored!')
}

################################################################################
################################################################################

filename <- "plant_data.csv"

if (!file.exists(filename)) {
  header <- "timestamp,plot,sample,total_species,plants"
  writeLines(header, filename)
}

ui <- fluidPage(
  titlePanel(h4("app for entering plant data")),
  br(),
  fluidRow(
    column(4, selectInput('plot',
                          label='Plot number',
                          choices = paste('Plot', 1:7),
                          width='95%')),
    
    column(4, radioButtons('sample',
                          label='Sample number',
                          choices = paste('Sample', 1:4),
                          inline = TRUE,
                          width='95%')),
    
    # Example input: manual text entry
    column(4, selectizeInput('plants',
                        label='plant species observed',
                        choices = c('Tall Fescue', 'White clover', 'Common Dandelion'),
                        options = list(create = TRUE),
                        multiple = TRUE,
                        width = '95%')),
    
    # Example input: selecting pre-canned options
    column(4, textInput('number',
                          label='total species',
                          value = '',
                          width='95%'))),
    
   
  br(),
  br(),
  fluidRow(column(2),
           # Save button!
           column(8, actionButton('save',
                                  h2('Save!'),
                                  width='100%')),
           column(2))
)

################################################################################
################################################################################

server <- function(input, output) {
  
  # Save button ================================================================
  observeEvent(input$save, {
    newdata <- c(
      input$plot,
      input$sample,
      input$number,
      paste(input$plants, collapse = "; "))
    log_line(newdata)
    showNotification("Save successful!")
  })
  #=============================================================================
  
}

################################################################################
################################################################################

shinyApp(ui, server)


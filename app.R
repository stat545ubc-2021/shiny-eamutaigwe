library(shiny)
library(palmerpenguins)
library(shinythemes)
library(tidyverse)
library(ggplot2)
library(plotly)
library(DT)

options(shiny.autoreload = TRUE)

penguins <- palmerpenguins::penguins

# Rename variables in the penguins dataset to something more presentable.
new_names <- c("Species", 
               "Island", 
               "Bill length (mm)", 
               "Bill depth (mm)", 
               "Flipper length (mm)", 
               "Body mass (g)", 
               "Sex",
               "Year"
)
penguins_sub1 <- penguins %>% 
  rename_at(1:8, ~ new_names)


# Define UI for application that draws a scatter plot
ui <- navbarPage(tags$b("Gorgeous Penguins"), inverse = TRUE, theme = shinytheme("simplex"),
                 
        # Set tabs
        tabPanel("Characteristics of Penguins", 
          tabsetPanel(
            tabPanel(tags$b("How to Use the App"),
                    # Add image
                    img(src = "penguins.png", height = 140, width = 170),
                    
                    # Short description of the app      
                    h4("This app provides an avenue to visually explore the various size relationships 
                      in species of penguins on 3 islands."), 
                                     
                    tags$p(h4("The penguins dataset by Horst AM et al (2020) is used for this purpose.",
                          em(a("Palmerpenguins", href = "https://allisonhorst.github.io/palmerpenguins/")))),
                                     
                    # Set font size            
                    fluidPage(
                      tags$head(
                        tags$style(HTML("
                            li {font-size: 18px;
                            }
                            li span {font-size: 12px;
                            }
                            list-style-type: square;
                            }
                      "))
                      ),
                                       
      # Explain how to use the app      
      tags$p(h4("The app has the following features:")),
                                       
      tags$ol(
              tags$li("It gives the user the freedom to select species of interest"),
              tags$li("It also provides the option to choose specific size characteristics, 
                      (i.e. variables) to map to the x- and y-coordinates"),
              tags$li("The user can also select a variable to map to colour"),
              tags$li("The user can also give the plot a custom title based on characteristics plotted"),
              tags$li("There is also an option to study the penguins within a specific year"),
              tags$li("The user can select year of interest using the slider manually or by pressing the play button.
                      The play can be paused at will"),
              tags$li("Hover your cursor over each point on the plot, and the values of the variables plotted on the x-axis, 
                      y-axis will be displayed. Also displayed are values of variables plotted to size and color."),
              tags$li("Values on the data table change in accordance with your selection of species and year."),
              tags$li("You can search through the data table by typing value of interest."),
              tags$li("There is an option to select the number of rows of the data table to display at any time, 
                      and also move from one interface to another."),
              tags$li("Finally, you can click on the DOWNLOAD FILTERED DATA button to download the data table in .csv according to your selection.
                      The plotly package provides a camera icon on top of the plot for downloading the plot."),
              ))),
                            
              tabPanel(tags$b("Customize a Scatterplot"),
                  fluidPage(
                  # Sidebar for selection of species and other variables
                      sidebarLayout(
                        sidebarPanel(
                          #img(src = "penguins.png", height = 140, width = 170),
                          h4(strong("Characteristic inputs")),
                                           
                          # Create drop-down menu for species selection
                          selectInput("species",
                                     label = h5("Select species:"),
                                     choices = c("Adelie", "Chinstrap", "Gentoo"),
                                     selected = "Adelie",
                                     width = "300px"
                          ),
                          # Select a variable for x-axis from the data frame
                          varSelectInput("X_Axis",
                                        h5("Select variable for the X-axis"), 
                                        data = Filter(is.numeric, penguins_sub1[3:6]), 
                                        selected = "Body mass (g)",
                                        width = "300px"
                          ),
                          # Select a variable for y-axis from the data frame
                          varSelectInput("Y_Axis",
                                        label = h5("Select variable for the Y-axis"),
                                        data = Filter(is.numeric, penguins_sub1[3:6]),
                                        selected = "Bill length (mm)",
                                        width = "300px"
                          ),
                          # Select a variable to map to size from the data frame
                          varSelectInput("size",
                                       label = h5("Select variable to map to size of points"),
                                       data = Filter(is.numeric, penguins_sub1[3:6]),
                                       selected = "Flipper length (mm)",
                                       width = "300px"
                          ),
                          # Select a variable to map to colour from the data frame
                          radioButtons("radio", 
                                      label = h5("Select variable to map to colour"),
                                      choices = c("Sex", "Island"),
                                      selected = "Sex"
                          ),
                          # Create a placeholder for adding plot title
                          textInput("plot_name", 
                                   label = h5("Enter plot title"), 
                                   placeholder = "Weight of penguin vs Bill length",
                                   width = "300px"
                          ),
                          # Create a slider input for year selection
                          sliderInput("year",
                                     label = h5("Year of Interest:"),
                                     min = 2007,
                                     max = 2009,
                                     value = 2007,
                                     animate = TRUE),
                                     width = 3
                          ),
                          # Show a plot of the generated distribution
                          mainPanel(
                              plotlyOutput("demoPlot"),
                                           
                          br(), br(),
                      )
                  )
              )    
          ),
             tabPanel(tags$b("Filtered Data Table"),
             
            # Show a filtered table
            dataTableOutput("my_table"),
            # Create a download button
            downloadButton("datadownload", "DOWNLOAD FILTERED DATA"),
                           width = 9,
                        )
                  )
        )
)

br()

# Define server logic required to draw a scatter plot and produce a data table
server <- function(input, output) {
  filtered <- reactive(
    penguins_sub1 %>%
      drop_na() %>% 
      filter(Species == input$species,
             Year >= input$year) 
  )
  output$demoPlot <- renderPlotly({
    plotme <- filtered() %>% 
      # Produce a scatter plot
      ggplot(aes_string(input$X_Axis, 
                        input$Y_Axis, 
                        size = input$size, 
                        colour = input$radio)) +
      geom_point(alpha = 0.7, show.legend = FALSE)  +
      ggtitle(input$plot_name) +
      theme_bw()
    ggplotly(plotme)
  })
  
  # Output an interactive data table
  output$my_table <- DT::renderDataTable(
    filtered()
  )
  
  # Download filtered data table
  output$datadownload <- downloadHandler(
    filename = function() {
      paste("data", ".csv", sep="")
    },
    content = function(file) {
      filteredtable <- filtered()
      write.csv(filteredtable, file, row.names = FALSE)
    })
}

# References
# https://stackoverflow.com/questions/61625109/r-shiny-ggplot-reactive-to-varselectinput
# https://www.bioinformatics.babraham.ac.uk/shiny/Intro_to_Shiny_course/examples/06_tidyverse/
# https://shiny.rstudio.com/articles/plot-interaction.html
# https://shiny.rstudio.com/articles/download.html
# https://shanghai.hosting.nyu.edu/data/r/case-1-3-shinyapp.html#using_texts_as_visualization

# Run the application 
shinyApp(ui = ui, server = server)

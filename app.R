library(shiny)
library(palmerpenguins)
library(shinythemes)
library(tidyverse)
library(ggplot2)


options(shiny.autoreload = TRUE)

penguins <- palmerpenguins::penguins

# Define UI for application that draws a scatter plot
ui <- fluidPage(

  # UI theme
  theme = shinytheme("superhero"),
    
  # Application title
  titlePanel("Characteristics of Penguins"),
  
  # Brief description of the features in the Appication
  
  h5("This app provides an avenue to visually explore the various size relationships 
  in species of penguins on 3 islands."), 
  
  "The penguins dataset by Horst AM et al (2020) is used for this purpose.",
  em(a("Palmerpenguins", href = "https://allisonhorst.github.io/palmerpenguins/")),
  
  h5("The app has the following features:
  1. It gives the user the freedom to select species of interest.
  2. It also provides the option to choose specific size characteristics 
  (i.e. variables) to map to the x- and y-coordinates. 
  3. The user can also give the plot a custom title based on characteristics plotted.
  4. There is also an option to study the penguins within a specific year. 
  5. The user can select year of interest manually or by pressing the play button.
     The play can be paused at will."), 
    
  br(),
  
  # Sidebar for selection of species and other variables
    sidebarLayout(
        sidebarPanel(
          h4(strong("Characteristic inputs")),

          # Create drop-down menu for species selection
          selectInput("species",
                      label = "Select species:",
                      choices = c("Adelie", "Chinstrap", "Gentoo"),
                      selected = "Adelie"
          ),
          # Select a variable for x-axis from the data frame
          varSelectInput("X_Axis",
                         "Select variable for the X_axis", 
                         data = Filter(is.numeric, penguins), 
                         selected = "body_mass_g"
          ),
          # Select a variable for y-axis from the data frame
          varSelectInput("Y_Axis",
                          label = "Select variable for the Y-axis",
                          data = Filter(is.numeric, penguins),
                          selected = "bill_length_mm"
          ),
          # Select a variable to map to size from the data frame
          varSelectInput("size",
                         label = "Select variable to map to size of points",
                         data = Filter(is.numeric, penguins),
                         selected = "bill_depth_mm"
          ),
          # Select a variable to map to colour from the data frame
          selectInput("colour",
                       label = "Select variable to map to colour of points",
                       choices = c("sex", "island"),
                       selected = "sex"
          ),
          # Create a placeholder for adding plot title
          textInput("plot_name", 
                    label = "Enter plot title", 
                    placeholder = "Weight of penguin vs Bill length"
          ),
          # Create a slider input for year selection
          sliderInput("year",
                      label = "Year of Interest:",
                      min = 2007,
                      max = 2009,
                      value = 2007,
                      animate = TRUE)
          ),
          # Show a plot of the generated distribution
          mainPanel(
                    plotOutput("demoPlot"),
                
          br(), br(),
        )
   )
)

# Define server logic required to draw a scatter plot
server <- function(input, output) {
    output$demoPlot <- renderPlot({
      penguins %>%
        drop_na() %>% 
          filter(species == input$species,
                year >= input$year) %>% 
        
      # Produce a scatter plot
      ggplot(aes_string(input$X_Axis, 
                        input$Y_Axis, 
                        size = input$size, 
                        colour = input$colour)) +
        geom_point(alpha = 0.7)  +
        ggtitle(input$plot_name) +
        theme_bw()
    })
}

# Acknowledgement
# I received assistance while creating the app through the following websites:
# https://stackoverflow.com/questions/61625109/r-shiny-ggplot-reactive-to-varselectinput
# https://www.bioinformatics.babraham.ac.uk/shiny/Intro_to_Shiny_course/examples/06_tidyverse/

# Run the application 
shinyApp(ui = ui, server = server)

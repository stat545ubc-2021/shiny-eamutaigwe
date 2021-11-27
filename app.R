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
  
  # Brief description on the features in the Appication
  
  h5("This app provides an avenue to visually explore the various size relationships 
  in species of penguins on 3 islands. The palmerpenguins::penguins dataset is used
  for this purpose."),
  
  h5("The app has the following features:
  1. It gives the user the freedom to select species of interest.
  2. It also provides the option to choose specific size characteristics 
  (i.e. variables) to map to the x- and y-coordinates. 
  3. The user can also give the plot a custom title based on characteristics plotted.
  4. There is also an option to study the penguins within a specific year. 
  5. The user can select one or more years of interest manually or by pressing the play button.
     The play can be paused at will."), 
    
    # Sidebar with selection of country and other variables
    sidebarLayout(
        sidebarPanel(
          h4(strong("Characteristic inputs")),
          
          # Create drop-down menu for species selection
          selectInput("species",
                      label = "Select species:",
                      choices = c("Adelie", "Chinstrap", "Gentoo"),
                      selected = "Adelie"),
          
          # Create groups using species
          #checkboxGroupInput("speciesInput",
                             #label = "Species:",
                             #choices = c("Adelie", "Chinstrap", "Gentoo"),
                             #selected = "Adelie",
          #),
          
          # Select a variable from the data frame
          varSelectInput("X_Axis",
                         "Select variable for the X_axis", 
                         data = Filter(is.numeric, penguins), 
                         selected = "body_mass_g"
          ),
          varSelectInput("Y_Axis",
                          label = "Select variable for the Y-axis",
                          data = Filter(is.numeric, penguins),
                          selected = "bill_length_mm"
          ),
          varSelectInput("size",
                         label = "Select variable to map to size of points",
                         data = Filter(is.numeric, penguins),
                         selected = "bill_depth_mm"
        ),
        selectInput("colour",
                       label = "Select variable to map to colour of points",
                       choices = c("sex", "island"),
                       selected = "sex"
        ),
          
        textInput("plot_name", 
                  label = "Enter plot title", 
                  placeholder = "Weight of penguin vs Bill length"
        ),

          # Create a slider input based on flipper length
          #sliderInput("flipperInput",
                        #"Flipper length of Interest:",
                        #min = 172,
                        #max = 231,
                        #value = c(180),
                        #animate = TRUE)
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
            #tableOutput("demoTable")
        )
   )
)

# Define server logic required to draw a bubble plot
server <- function(input, output) {
    output$demoPlot <- renderPlot({
      penguins %>%
        drop_na() %>% 
        arrange(flipper_length_mm) %>% 
          filter(species == input$species,
                #flipper_length_mm >= input$flipperInput,
                year >= input$year) %>% 
                #species == input$speciesInput) %>% 
      # Produce a bubble plot
      ggplot(aes_string(input$X_Axis, 
                        input$Y_Axis, 
                        size = input$size, 
                        colour = input$colour)) +
        geom_point(alpha = 0.7)  +
        ggtitle(input$plot_name) +
        #theme(plot.title = element_text(face="bold",  size = 18)) +
        theme_bw()
    })
    
    #output$demoTable <- gapminder %>% 
      #filter(year >= input$my_yearInput)
}

# Run the application 
shinyApp(ui = ui, server = server)

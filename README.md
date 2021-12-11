## Shiny Application for Visualizing Characteristics of Penguins

**Choice of Assignment**

This Application is part of STAT545B assignments. I chose option C, i.e. to implement additional features and improvements to my Assignment 3b shiny app.

**Implementation of feedback**

I renamed the variables of the dataset to more presentable names, and also restricted the use of the 'Year' variable to just the slider.

**How the App functions**

The app provides an avenue to visually explore the various size relationships 
in species of penguins on 3 islands. The `palmerpenguins::penguins` dataset is used
for this purpose.

Three tabs were created for a) How to use the App b) Customize a Scatterplot c) Filtered Data Table
  
**The app has the following features:**

1. It gives the user the freedom to select species of interest
2. It also provides the option to choose specific size characteristics, (i.e. variables) to map to the      x- and y-coordinates
3. The user can also select a variable to map to colour
4. The user can also give the plot a custom title based on characteristics plotted
5. There is also an option to study the penguins within a specific year
6. The user can select year of interest using the slider manually or by pressing the play button. The       play can be paused at will
7. Hover your cursor over each point on the plot, and the values of the variables plotted on the x-axis,    y-axis will be displayed. Also displayed are values of variables plotted to size and color.
8. Values on the data table change in accordance with your selection of species and year.
9. You can search through the data table by typing value of interest.
10. There is an option to select the number of rows of the data table to display at any time, and also      move from one interface to another.
11. Finally, you can click on the DOWNLOAD FILTERED DATA button to download the data table in .csv          according to your selection. The plotly package provides a camera icon on top of the plot for           downloading the plot.
    
**Link to a running instance of the Shiny app**
[Ekpereka Amutaigwe](https://ekpereka-amutaigwe.shinyapps.io/shiny-eamutaigweV2/)

**Data Source**

The penguins dataset used in the app is from:

[Horst AM, Hill AP, Gorman KB (2020). palmerpenguins: Palmer Archipelago (Antarctica) penguin data. R package version 0.1.0.](https://allisonhorst.github.io/palmerpenguins/)

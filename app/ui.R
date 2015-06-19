library(shiny)

# Define UI for miles per gallon application
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Predicting Sexe"),
  
  # Sidebar with controls to select the variable to plot against mpg
  # and to specify whether outliers should be included
  sidebarPanel(h3('Preprocessing'),
               br(),
               
               radioButtons("rz", "Do you want to remove the near zero variables?",
                            c(" No" = 1,
                              " Yes" = 1
                            )), 
               
               radioButtons("rc", "Do you want to remove the variables that are highly correlated?",
                            c(" No" = 0,
                              " Yes" = 1
                            )),
               
               radioButtons("rs", "Do you want to scale the data?",
                            c(" No" = 0,
                              " Yes" = 1
                            )),
               
               radioButtons("rp", "Do you want to perform a PCA?",
                            c(" No" = 0,
                              " Yes" = 1
                            )),
               
               radioButtons("rm", "What model do you want to use",
                            c(" General linear model" = 'glm',
                              " Linear discriminant analysis" = 'lda',
                              " Boosting trees" ='gbm'
                            )),
               
               radioButtons("rseed", "What random seed do you want to use",
                            c(" 990666" = 990666,
                              " 298194" = 298194,
                              " 971767" = 971767
                            )),
               
    br(),
    br(),
    br(),
    h3('Plotting of the most important variables of the prediction algorithm'),
    p('By plotting the variables you can try to explore what variables drive this prediction algorithm.
      What variables are most important can be found in the output of the prediction algorithm'),
    p('Make sure that the names are exact!'),
    textInput("text1", label = h4("X variable of plot"), value = "IDSSR05"),
    textInput("text2", label = h4("Y variable of plot"), value = "AGE")
  ),
  
  # Show the caption and plot of the requested variable against mpg
  mainPanel(
    p('The first goal of this app is to play around with preprocessing data. I have already uploaded a
      data set and with this data set you can predict sexe.'),
    p('The second goal of this app is that you try to understand what is used in the prediction model 
      to predict sexe. You can do this by exploring the most important variables. These are given in 
      output. You can plot them below.'),
    h3(textOutput("The output")),
    h3('Output from prediction model'),
    verbatimTextOutput("ml"),
    h3('the plot'),
    p('plot two variables that are important for the predition model'),
    plotOutput("plot1")
  )
))
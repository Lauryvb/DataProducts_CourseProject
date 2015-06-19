library(shiny)
library(ggplot2) # load ggplot
library(e1071)
library(pROC)
df= read.csv('data.csv')
df=df[,-1]
df$SEXE=factor(df$SEXE)
source('predictmodel.R')
# Define server logic required to plot various variables against mpg
shinyServer(function(input, output) {
 
  df2<- reactive({data.frame(SEXE=df$SEXE, 
                             XV=df[,which(names(df)==input$text1)],
                             YV=df[,which(names(df)==input$text2)])
    })
  
 #print the plot
  output$plot1<- renderPlot({
  print(ggplot(df2(), aes(x=XV,y=YV, color=SEXE))+ 
      geom_point(position = 'jitter')+ 
      scale_colour_discrete(name="Sexe",breaks=c("1", "2"),labels=c("Male", "Female"))+
        xlab(input$text1)+ylab(input$text2))
    
  })
  
  output$temp <- renderPrint({calgrade(c(as.numeric(input$pa1),
                                          as.numeric(input$pa2),
                                          as.numeric(input$pa3)
  ))})
  
  output$ml <- renderPrint({predictsexe(nonzero = as.numeric(input$rz),
                                        nonhighcorr= as.numeric(input$rc),
                                        scale= as.numeric(input$rs),
                                        pca=as.numeric(input$rp),
                                        model=input$rm,
                                        seeds = as.numeric(input$rseed)
                                        )})
  
  
  })
  #end of server brackets
  
  




library(ggplot2)
library(corrplot)
library(dplyr)
library(DT)

# Reading data in the beginning.
studentPerformanceData <- as.data.frame(read.csv("./dataset/student-por.csv",sep = ";",stringsAsFactors = TRUE))
# Reads in data description written in the form of an CSV
datasetDescription <- read.csv("./dataset/dataset_description.csv")

#Themeing
primary <- "#75f4f4"
secondary <- "#fffd82"
tertiary <- "#e84855"


#Server here does all the calculations when requested by the UI elements.

server <- function(input, output, session) {
  
  # Student Performance Variables
  
  #Factor Column Names
  column_names <- colnames(studentPerformanceData[sapply(studentPerformanceData,class)=="factor"])
  
  # Renders the Data Table using DT library
  output$data_table <- DT::renderDataTable(
      studentPerformanceData,
      options = list(scrollX=TRUE)
    )
  
  #Renders the summary of the data set.
  output$student_summary <- shiny::renderPrint({
    summary(studentPerformanceData)
  })
  
  # Makes the Numeric Correlation Plot
  output$student_corrplot <- renderPlot({
    corrplot(cor(studentPerformanceData[sapply(studentPerformanceData, class) == "integer"]))
  })
  
  #Generates a Dynamic UI selection
  output$x_axis_factor_columns <- renderUI({
    selectInput("x_axis", "X-Axis", column_names);
  })
  
  #Generates a Dynamic UI selection
  output$y_axis_factor_columns <- renderUI({
    selectInput("y_axis", "Y-Axis", column_names);
  })
  
  # Renders the dynamic distribution selection
  output$distribution_columns <- renderUI({
    selectInput("distribution_variable","Select the Variable You want to see the distribution of",column_names)
  })
  
  # PLots the Distribution graph as requested
  output$distribution_plot <- renderPlot({
    column_selected <- input$distribution_variable
    ggplot(studentPerformanceData, aes_string(column_selected)) + geom_bar(fill=primary, color=tertiary) + 
      theme(axis.text=element_text(size=12),axis.title=element_text(size=14,face="bold"))
  })
  
  # Making the Input Variables available in UI
  output$x_axis_chisq <- renderText({input$x_axis})
  output$y_axis_chisq <- renderText({input$y_axis})
  
  # Chi - Square Test Logic
  output$chi_sq_test_result <- renderPrint({
    x <- input$x_axis
    y <- input$y_axis
    test <- chisq.test(as.matrix(studentPerformanceData[x]),as.matrix(studentPerformanceData[y]))
    if(test$p.value > 0.05){
      "Retaining NULL Hypothesis"
    }else{
      "Retaining Alternate Hypothesis"
    }
  })
  output$chi_sq_test <- renderPrint({
    x <- input$x_axis
    y <- input$y_axis
    chisq.test(as.matrix(studentPerformanceData[x]),as.matrix(studentPerformanceData[y]))
  })
  
  #Dynamic Regression plot
  output$regression <- renderPlot({
    ggplot(studentPerformanceData,aes_string(x=input$x_axis_regression, y=input$y_axis_regression)) + geom_point(color=tertiary) + 
      geom_smooth(method = 'lm', color=primary) + 
      theme(axis.text=element_text(size=12),axis.title=element_text(size=14,face="bold"))
  })
  
  # Renders the Table for data set description
  output$dataset_description <- renderTable({
    datasetDescription
  })
  
}